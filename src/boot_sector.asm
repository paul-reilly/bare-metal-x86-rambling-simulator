;
;   Master Boot Record (MBR):
;
;     Boots into a "16 bit real mode" program which should be padded out to a 512 byte boundary. Set
;     the macro PROGRAM_SZ_SECTORS to match the number of 512 byte sectors your program
;     occupies and concatenate to the end of the assembled MBR binary.
;
;     eg:
;         nasm boot_sector.asm -o boot_sector.bin
;         nasm my_program.asm -o my_program.bin
;         cat boot_sector.bin my_program.bin > image.bin
;
;     test:
;         qemu-system-i386 image.bin
;
;     write to USB thumb drive using dd:
;         WARNING: dangerous command! Please check the device name on your own system!
;                  There is a risk of overwriting the MBR or performing unknown dark magic on
;                  one of your most treasured devices.
;         sudo dd if=image.bin of=???    (eg ??? is /dev/sdb on my system)
;
;
;     based on: https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf and
;               https://wiki.osdev.org/MBR_(x86)
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;     Memory layout after boot: https://wiki.osdev.org/Memory_Map_(x86)
;     Real-mode memory management: https://archive.is/yYo2G (originally http://www.internals.com:80/articles/protmode/realmode.htm)
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;

[bits 16]

PROGRAM_DEST equ 0x7f00         ; location to load program to via 'disk_load' call
PROGRAM_SZ_SECTORS equ 8        ; number of 512 byte sectors that need to be read for program

[org 0x0600]                    ; let assembler know our origin so that it can add this offset to the address of
                                ; any labels in our code. This bootsector is initially loaded to the address 0x7c00
                                ; by the BIOS, but we copy it to 0x0600. Until the copy is done, any absolute jmps to 
                                ; labels will go to empty/garbage memory.


start:
  cli                           ; switch off interrupts

                                ; now we zero our segment registers
  xor ax, ax                    ; so first zero AX, then:
  mov ds, ax                    ;   zero Data Segment
  mov es, ax                    ;   zero Extra Segment
  mov ss, ax                    ;   zero Stack Segment
  mov sp, ax                    ;   zero Stack Pointer

  .copy_lower:                  ; set registers for 'rep movsw' instruction:
    mov cx, 0x0100              ;   num words to copy - our 512 byte MBR is 256 words
    mov si, 0x7c00              ;   source: current MBR address
    mov di, 0x0600              ;   dest: new MBR address
    rep movsw                   ; copy MBR

  jmp 0:origin                  ; jump to new address, jmp calculated as an offset from our org of 0x0600

origin:
  sti                           ; start interrupts
  mov [BOOT_DRIVE], dl          ; BIOS stores our boot drive in DL
  mov bp, 0x0900                ; set the base of the stack a little above where BIOS
  mov sp, bp                    ; loads our boot sector - so it won’t overwrite us.

  mov si, OS_MSG
  call print_string

  mov bx, PROGRAM_DEST          ; load PROGRAM_SZ_SECTORS sectors to ES:BX (= 0x0000:0x9000)
  mov dh, PROGRAM_SZ_SECTORS    ; from BOOT_DRIVE.
  mov dl, [BOOT_DRIVE]
  call disk_load

  jp PROGRAM_DEST
  jp $


%include "print_string_16.asm"
%include "disk_load.asm"


; global variables
OS_MSG: db "ros loading... please wait, this should only take a moment", 10, 13, 0
BOOT_DRIVE: db 0


disk_time_stamp:
  %assign _to_disk_time_stamp (218 - (disk_time_stamp - start))
  %warning _to_disk_time_stamp bytes available before fixed DiskTimeStamp location
  times (218 - ($-$$)) nop      ; pad to DiskTimeStamp...
  DiskTimeStamp times 8 db 0    ; .. which has a fixed location


mbr_user_code_end:              ; label used to calculate code size
  times 0x1b4 - ($ - $$) db 0   ; pad boot code to 436 so the partition table and magic number takes us to 512


mbr_partition_table:
  %assign _num_bytes (mbr_partition_table - mbr_user_code_end)
  %warning _num_bytes bytes available before fixed partition table location
  UID times 10 db 0             ; Unique Disk ID
  PT1 times 16 db 0             ; First Partition Entry
  PT2 times 16 db 0             ; Second Partition Entry
  PT3 times 16 db 0             ; Third Partition Entry
  PT4 times 16 db 0             ; Fourth Partition Entry
  dw 0xaa55                     ; magic number to end bootsector with to tell BIOS what this is