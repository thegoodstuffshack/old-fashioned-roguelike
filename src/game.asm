[bits 16]
[org 0x7c00]

jmp start

VIDEO_ADDR equ 0xA000
VIDEO_W    equ 320
VIDEO_H    equ 200
CELL_SIZE  equ 5 ; (1, 2, 4, 5, 8, 10, 20, 40)


BOOT_DRIVE db 0

playerpos:
.x: dw 1
.y: dw 1

pallete:
.0: db 0  ; black
.1: db 10 ; lgreen
.2: db 13 ; red
.3: db 15 ; white


start:
	xor ax, ax
	mov ds, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov sp, 0x7c00

	mov [BOOT_DRIVE], dl

	call load_sectors

	mov ax, 0x0013 ; video addr 0xA0000, 320x200, 16:10, 8bpp
	int 0x10
	push 0xA000
	pop es

	mov ax, map
	call drawMap
	call drawPlayer


game_loop:
	call inputWait
	call player

	xor ah, ah
	int 0x16   ; clear keyboard buffer
	jmp game_loop



	cli
	hlt


%include "src/draw.asm"
%include "src/player.asm"
%include "src/collision.asm"
%include "src/enemy.asm"
%include "src/disk.asm"

; returns ah: scancode
; returns al: ascii char
; input buffer NOT cleared (use ah=0)
inputWait:
	mov ah, 1	
	int 0x16
	jz inputWait
	ret
	int 0x10


times 510-($-$$) db 0
dw 0xAA55

; 0x7e00
map: incbin "bin/map.bin"
times 512 db 0