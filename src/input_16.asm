

getchar:
    mov ah, 0
    int 0x16
    ret

;; writes null-terminated input to buffer
; input: dx - address of buffer
getinput:
    pusha
    mov bx, dx

    mov al, '>'
    call writechar
  .input_loop:
    mov al, 0
    call getchar
    cmp al, 13              ; check for carriage return for end of string input
    je .end
    call writechar
    mov [bx], al
    inc bx
    jmp .input_loop
  .end:
    mov [bx], byte 0x00     ; null terminate string

    mov al, 13              ; move cursor to start of new line for next exciting stage of adventure
    call writechar          ;
    mov al, 10              ;
    call writechar          ;

    popa
    ret