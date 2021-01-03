;
;
;
SCROLL_TELETYPE equ 0x0e   


; input: al - char to print
; output-
writechar:
  mov ah, SCROLL_TELETYPE
  int 0x10
  ret


print_string:
; inp: si - address of null-terminated string
; out:
  push bx
  push ax
  mov ah, SCROLL_TELETYPE
  .loopstart:
    lodsb                         ; loads [si] into al and increments si
    cmp al, 0
    je .finish
    mov bh, 0x00                  ; display page 0
    mov bl, 0x07                  ; text attribute
    int 0x10
    jmp .loopstart
  .finish:
  pop ax
  pop bx
  ret


; input: al - contains byte
; output-
print_byte:
  push ax
  cmp al, 10
  jge .is_letter
  .is_number:
    add al, 48                    ; ascii numbers start at 48 
    jmp .cont
  .is_letter:
    add al, 55                    ; 65 is ascii 'A' and 10 = 'A'
  .cont:
  call writechar

  pop ax
  ret


;    prints value in dx as hex
; input: dx - our 2 bytes
; output-
print_hex:
  pusha
  mov al, '0'
  call writechar
  mov al, 'x'
  call writechar
  ; we have four nibbles in our 16 bits to print
  mov cl, 12                      ; first bit shift value
  .loopstart:
    mov bx, dx                    ; preserve dx
    shr bx, cl
    and bx, 0x000f
    mov al, bl
    call print_byte
    cmp cl, 0
    je .finish
    sub cl, 4
    
    jmp .loopstart
  .finish:
  popa
  ret
