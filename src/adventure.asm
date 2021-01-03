
[org 0x7f00]

DESC equ 8

adventure:
    pusha
    mov ax, 0x0002                     ; set gfx mode/clear the screen
    int 0x10                           ;

    mov ah, 0xb                        ; set background colour
    mov bh, 0                          ;
    mov bl, 0                          ; = colour
    int 0x10                           ;

    mov ax, CLEARING                   ; set location to clearing
    mov [CURRENT_LOCATION], ax         ;

    xor ax, ax                         ; zero for first run
start:
    cmp al, 1                          ; al will be set in parse_input when we jmp back
    je next_input
    call enter_location
next_input:
    mov dx, INPUT_BUFFER        
    call getinput
    call parse_input
    jmp start
    popa


parse_input:
    push bx
    mov al, [INPUT_BUFFER]             ; get first char
  .if_north:
    cmp al, 'n'
    jne .else_if_west
      .input_north:
        mov bx, [CURRENT_LOCATION]
        add bx, 0
        mov ax, [bx]
        cmp ax, 0
        je .cant_travel
        .can_go_north:
          mov si, msg_north
          call print_string
          mov [CURRENT_LOCATION], ax
          xor al, al                   ; al = 0 : show location description first, 
                                       ; al = 1 : just get input
          jmp .end
  .else_if_west:
    cmp al, 'w'
    jne .else_if_south
      .is_west:
        mov bx, [CURRENT_LOCATION]
        add bx, 6                      ; offset for possible west destination in location data
        mov ax, [bx]
        cmp ax, 0
        je .cant_travel
        .can_go_west:
          mov si, msg_west
          call print_string
          mov [CURRENT_LOCATION], ax
          xor al, al
          jmp .end
  .else_if_south:
    cmp al, 's'
    jne .else_if_east
      .is_south:
        mov bx, [CURRENT_LOCATION]
        add bx, 2
        mov ax, [bx]
        cmp ax, 0
        je .cant_travel
        .can_go_south:
          mov si, msg_south
          call print_string
          mov [CURRENT_LOCATION], ax
          xor al, al
          jmp .end
  .else_if_east:
    cmp al, 'e'
    jne .else_if_inventory  
      .is_east:
        mov bx, [CURRENT_LOCATION]
        add bx, 4
        mov ax, [bx]
        cmp ax, 0
        je .cant_travel
        .can_go_east:
          mov si, msg_east
          call print_string
          mov [CURRENT_LOCATION], ax
          xor al, al
          jmp .end
  .else_if_inventory:
    cmp al, 'i'
    mov al, 1
    jne .else
    .is_inventory:
      mov bx, msg_empty
      call print_string
      jmp .end
    ; other commands
  .else:
    mov si, msg_pardon
    call print_string
    jmp .end
  .cant_travel:
    mov si, msg_cant_travel
    call print_string
    mov al, 1
  .end:
    pop bx
    ret
    

enter_location:
    pusha
    mov ax, [CURRENT_LOCATION] 
    add ax, DESC
    push si
    mov si, ax
    call print_string
    pop si
    popa
    ret


; global vars
CURRENT_LOCATION:
    dw 0

MSGS_DIRECTIONS:
  dw msg_north
  dw msg_south
  dw msg_east
  dw msg_west

msg_north:
    db 'Somewhat unwisely, you travel north...', 10, 13, 0
msg_cant_travel:
    db 'You cannot travel that way from here, are you feeling alright?', 10, 13, 0
msg_south:
    db 'Gingerly, you travel south...', 10, 13, 0
msg_east:
    db 'Against your best judgement, you travel east...', 10, 13, 0
msg_west:
    db 'You travel west, much to your own bemusement...', 10, 13, 0
msg_empty:
    db "You don't have anything!", 10, 13, 0
msg_pardon:
    db "Pardon?", 10, 13, 0
INPUT_BUFFER:
    times 64 db 0


%include "input_16.asm"
%include "print_functions_16.asm"
%include "map.asm"


times 4096 - ($ - $$) db 0             ; pad out to 4k