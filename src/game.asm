[bits 16]
[org 0x7c00]

jmp start

VIDEO_ADDR equ 0xA000
VIDEO_W    equ 320
VIDEO_H    equ 200
CELL_SIZE  equ 10 ; (1, 2, 4, 5, 8, 10, 20, 40)


BOOT_DRIVE db 0

playerpos:
.x: dw 0
.y: dw 0

pallete:
.0: db 0  ; black
.1: db 10 ; lgreen
.2: db 12 ; red
.3: db 15 ; white


start:
	xor ax, ax
	mov ds, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov sp, 0x7c00

	mov [BOOT_DRIVE], dl

	mov ax, 0x0013 ; video addr 0xA0000, 320x200, 16:10, 8bpp
	int 0x10
	push 0xA000
	pop es

	jmp player

	cli
	hlt


%include "src/draw.asm"
%include "src/player.asm" 


times 510-($-$$) db 0
dw 0xAA55