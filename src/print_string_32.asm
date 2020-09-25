[bits 32]


;    define some constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f


;    prints a null-terminated string
; input: edx - address of null-terminated string
; output-
print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY       ; set edx to the start of vid mem.
  .psloop: 
    mov al, [ebx]               ; store the char at EBX in AL
    mov ah, WHITE_ON_BLACK      ; store the attributes in AH
    cmp al, 0                   ; if (al == 0) , at end of string , so
    je .done                    ; jump to done
    mov [edx], ax               ; store char and attributes at current
                                ; character cell.
    add ebx, 1                  ; increment EBX to the next char in string.
    add edx, 2                  ; Move to next character cell in vid mem.

    jmp .psloop                 ; loop around to print the next char.

  .done:
    popa
    ret                         ; Return from the function