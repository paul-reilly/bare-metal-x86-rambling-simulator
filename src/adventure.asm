
[org 0x7f00]

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


NORTH_OFFS equ 0                     ; north/south/east/west messages and directions (in our map) are
SOUTH_OFFS equ 2                     ; stored at these offsets to the base addresses
EAST_OFFS  equ 4                     ;
WEST_OFFS  equ 6                     ;
DESC_OFFS  equ 8


parse_input:
  push bx
  mov al, [INPUT_BUFFER]             ; get first char
  .if_north:
    cmp al, 'n'
    jne .else_if_west
    .is_north:
      mov ax, NORTH_OFFS
      call move
      jmp .end
  .else_if_west:
    cmp al, 'w'
    jne .else_if_south
    .is_west:
      mov ax, WEST_OFFS
      call move
      jmp .end
  .else_if_south:
    cmp al, 's'
    jne .else_if_east
    .is_south:
      mov ax, SOUTH_OFFS
      call move
      jmp .end
  .else_if_east:
    cmp al, 'e'
    jne .else_if_inventory  
    .is_east:
      mov ax, EAST_OFFS
      call move
      jmp .end
  .else_if_inventory:
    cmp al, 'i'
    mov al, 1
    jne .else
    .is_inventory:
      mov bx, msg_empty
      call print_string
      jmp .end
  .else:                             ; other commands
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
  add ax, DESC_OFFS
  push si
  mov si, ax
  call print_string
  pop si
  popa
  ret


;; process north = 0, south = 2 etc direction
; in : ax = direction
; out: 
move:
  mov cx, ax
  mov bx, [CURRENT_LOCATION]
  add bx, ax
  mov ax, [bx]
  cmp ax, 0
  je .cant_travel
  .can_travel:
    mov bx, message_ptrs
    add bx, cx
    mov si, [bx]
    call print_string
    mov [CURRENT_LOCATION], ax
    xor al, al                       ; al = 0 : show location description first, 
                                     ; al = 1 : just get input
    ret
  .cant_travel:
    mov si, msg_cant_travel
    call print_string
    mov al, 1
  ret


; global vars
CURRENT_LOCATION:
  dw 0


message_ptrs:
  msg_north_ptr dw msg_north
  msg_south_ptr dw msg_south
  msg_east_ptr  dw msg_east
  msg_west_ptr  dw msg_west


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