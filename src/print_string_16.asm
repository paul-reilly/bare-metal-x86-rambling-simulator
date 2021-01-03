
print_string:
; in : si - address of null-terminated string
; out:
  SCROLL_TELETYPE equ 0x0e
  push bx
  push ax
  mov ah, SCROLL_TELETYPE
  .loopstart:
    lodsb                       ; loads [si] into al and increments si
    cmp al, 0
    je .finish
    mov bh, 0x00                ; display page 0
    mov bl, 0x07                ; text attribute
    int 0x10
    jmp .loopstart
  .finish:
  pop ax
  pop bx
  ret