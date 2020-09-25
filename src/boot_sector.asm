;
;   boot sector: 512 bytes long, typically loaded at 0x7c00 by BIOS
;
;   adapted from https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
;
;   compile with: nasm boot_sector.asm -f bin -o boot_sector.bin
;   test with:    qemu-system-x86_64 boot_sector.bin
;


;               ^                                   ^
;               |                                   |
;               | Free                              |
;               |                                   |
;   0x100000    ------------------------------------- 
;               | BIOS                              |  256 KB
;    0xc0000    -------------------------------------
;               | Video memory                      |  128 KB
;    0xa0000    -------------------------------------
;               |                                   |
;               | Extended BIOS data area           |  639 KB
;               |                                   |
;    0x9fc00    -------------------------------------
;               |                                   |
;               | Free                              |  638KB
;               |                                   |
;    0x07e00    - - - - - - - - - - - - - - - - - - -
;               | Loaded boot sector                |  512 bytes
;    0x07c00    - - - - - - - - - - - - - - - - - - -
;               |                                   |
;               |                                   |
;    0x00500    -------------------------------------
;               | BIOS data area                    |  256 bytes
;    0x00400    -------------------------------------
;               | Interrupt vector table            |  1 KB
;    0x00000    -------------------------------------


; int 10/ ah = 0eh -> scrolling teletype BIOS routine
SCROLL_TELETYPE equ 0x0e    
%define true 1
%define false 0

PROGRAM equ 0x7f00

[org 0x7c00]                    ; let assembler know where this has been loaded so that
                                ; it can add this offset to any addresses in our code
origin:
    mov [BOOT_DRIVE], dl        ; BIOS stores our boot drive in DL
    mov bp, 0x7e00              ; set the base of the stack a little above where BIOS
    mov sp, bp                  ; loads our boot sector - so it won ’t overwrite us.

    mov bx, OS_MSG
    call print_string
    
    mov bx, PROGRAM             ; Load 4 sectors to 0x0000 (ES):0x9000 (BX)
    mov dh, 8                   ; from the boot disk.
    mov dl, [BOOT_DRIVE]
    call disk_load

    jp PROGRAM
    jp $

%include "print_functions_16.asm"
%include "disk_load.asm"

; global variables
OS_MSG: db "ros loading... please wait, this should only take a moment", 10, 13, 0
BOOT_DRIVE: db 0


times 510 -( $ - $$ ) db 0      ; pad boot sector to 512 bytes
dw 0xaa55                       ; magic number to end bootsector with to tell BIOS what this is
