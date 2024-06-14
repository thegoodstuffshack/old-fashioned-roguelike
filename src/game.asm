; game.asm

[bits 16]
[org 0x7c00]

jmp start

VIDEO_ADDR equ 0xA000
VIDEO_W    equ 320
VIDEO_H    equ 200
CELL_SIZE  equ 8 ; (1, 2, 4, 5, 8, 10, 20, 40)

%define coord(x,y) y*256+x     ; 0xYYXX


BOOT_DRIVE db 0

pallete:
.0: db 0  ; background - black
.1: db 10 ; dead       - lgreen
.2: db 13 ; wall       - purple
.3: db 15 ; player     - white
.4: db 12 ; enemy      - red


start:
	xor ebx, ebx
	mov ds, bx
	mov fs, bx
	mov gs, bx
	mov ss, bx
	mov sp, 0x7c00


	mov [BOOT_DRIVE], dl

	call load_sectors

	mov ax, 0x0013 ; video addr 0xA0000, 320x200, 16:10, 8bpp
	int 0x10
	push 0xA000
	pop es
	; call screen_colour_loop

	mov ax, map
	call drawMap
	call drawPlayer


game_loop:
	call inputWait
	call player

	call enemyHandler

	xor ah, ah
	int 0x16   ; clear keyboard buffer
	jmp game_loop


%include "src/draw.asm"
%include "src/disk.asm"

; returns ah: scancode
; returns al: ascii char
; input buffer NOT cleared (use ah=0)
inputWait:
	mov ah, 1	
	int 0x16
	jz inputWait
	ret


times 510-($-$$) db 0
dw 0xAA55

%include "src/player.asm"
%include "src/collision.asm"
%include "src/enemy.asm"

times 2*512-($-$$) db 0
map: incbin "bin/map.bin"
%include "src/art/include.asm"

sector_amount equ 3
times sector_amount*512-($-$$) db 0