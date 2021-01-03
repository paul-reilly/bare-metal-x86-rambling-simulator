
disk_load:
;; Reads DH number of sectors from drive DL and writes contents to [ES:BX]
; in : dx
; out: es, bx
  push dx                       ; Store DX on stack so later we can recall
                                ; how many sectors were requested to be read,
                                ; even if it is altered in the meantime

  mov ah, 0x02                  ; BIOS read sector function
  mov al, dh                    ; read DH sectors
  mov ch, 0x00                  ; Select cylinder 0
  mov dh, 0x00                  ; Select head 0
  mov cl, 0x02                  ; Start reading from second sector (i.e. the one
                                ;   after the boot sector. Number is 1-based, so
                                ;   no zeroth sector)
  int 0x13                      ; BIOS interrupt 0x13

  jc disk_error                 ; Jump if error (i.e. carry flag set)

  pop dx                        ; Restore DX from the stack
  cmp dh, al                    ; if AL (sectors read) != DH (sectors expected)
  jne disk_error                ; display error message
  ret

disk_error:
  mov bx, DISK_ERROR_MSG
  call print_string
  jmp $

; global variables
DISK_ERROR_MSG: db "Disk read error!", 0
