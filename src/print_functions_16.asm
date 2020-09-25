;
;
;
SCROLL_TELETYPE equ 0x0e   


; input: al - char to print
; output-
writechar:
    ;push ax
    mov ah, SCROLL_TELETYPE
    int 0x10
    ;pop ax
    ret


;    MSG: db 'ros loading... please wait, this should only take a moment', 0
; input: bx - address of null-terminated string
; output-
print_string:
    push ax
    mov ah, SCROLL_TELETYPE
  .loopstart:
    cmp [bx], byte 0
    je .finish
    mov al, [bx]
    int 0x10
    inc bx
    jmp .loopstart
  .finish:
    pop ax
    ret


; input: al - contains byte
; output-
print_byte:
    push ax
    cmp al, 10
    jge .letter
    add al, 48        ; ascii numbers start at 48 
    jmp .cont
  .letter:
    add al, 55        ; 65 is ascii 'A' and 10 = 'A'
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
    mov cl, 12                  ; first bit shift value
  .loopstart:
    mov bx, dx                  ; preserve dx
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
