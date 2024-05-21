; init.asm
; load program, setup and jump to run.asm, splashscreen?

[bits 16]
[org 0x7c00]

jmp start

; offset: 0x7c02
BOOT_DRIVE db 0

%include 'src/common.asm'

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
	push 0xa000
	pop es

.screen:
	xor cx, cx
	xor dx, dx
	xor bl, bl

.loop:
	push cx
	push dx
	push bx
	call draw_cell

	pop bx
	pop dx
	pop cx
	inc bl
	inc cx
	cmp cx, VIDEO_W / CELL_SIZE
	jne .loop
	inc dx
	xor cx, cx
	cmp dx, VIDEO_H / CELL_SIZE
	jne .loop
	xor dx, dx
	mov ah, 0x86
	mov cx, 0x0010
	mov dx, 0x0000
	int 0x15

	xor cx, cx
	xor dx, dx

	jmp .loop

	jmp $

draw_cell: incbin 'bin/draw_cell.bin'

times 510-($-$$) db 0
dw 0xAA55

incbin 'bin/run.bin'