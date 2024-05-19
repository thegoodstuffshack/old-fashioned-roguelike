; init.asm
; load program, setup and jump to run.asm

[bits 16]
[org 0x7c00]

jmp start

VIDEO_ADDR equ 0xA000
VIDEO_W    equ 320
VIDEO_H    equ 200
CELL_SIZE  equ 10 ; (1, 2, 4, 5, 8, 10, 20, 40)

start:
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00

	mov ah, 0x0e
	mov al, 14
	int 0x10


	mov ax, 0x0013 ; video addr 0xA0000, 320x200, 16:10, 8bpp
	int 0x10

	push 0xa000
	pop es
	; xor si, si

	mov ah, 0x0b
	mov bh, 0
	mov bl, 7
	int 0x10

	mov ah, 0x0c
	mov bh, 1
	mov al, 12
	mov cx, 0
	mov dx, 0
	int 0x10
	mov ah, 0x0c
	mov bh, 1
	mov al, 11
	mov cx, 1
	mov dx, 0
	int 0x10

	mov ah, 0x0c
	mov bh, 1
	mov al, 35
	mov cx, 10
	mov dx, 10
	int 0x10

	mov word [es:800], 0xFFFF

	mov ah, 0x0d
	mov bh, 0
	mov cx, 10
	mov dx, 10
	int 0x10 


	mov ah, 0x0c
	mov bh, 1
	mov cx, 20
	mov dx, 20
	int 0x10


	mov bl, 0x0e ; colour of the cell
	mov cx, 0x0003 ; x
	mov dx, 0x0002 ; y
	call draw_cell

	mov bl, 0x0a ; colour of the cell
	mov cx, 0x0001 ; x
	mov dx, 0x0001 ; y
	call draw_cell

	mov bl, 0x03 ; colour of the cell
	mov cx, 0x0000 ; x
	mov dx, 0x0000 ; y
	call draw_cell


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
	mov cx, 0x0000
	mov dx, 0x00F0
	; int 0x15

	xor cx, cx
	xor dx, dx

	jmp .loop

	jmp $


; input bl: colour
; input cx: x
; input dx: y
draw_cell:
	mov ax, VIDEO_W * CELL_SIZE
	mul dx
	push ax
	mov ax, CELL_SIZE
	mul cx
	pop dx
	add ax, dx ; y*w + x*csize

	xor dx, dx

	mov si, ax
	push VIDEO_ADDR
	pop es

.loop:
	cmp dl, CELL_SIZE
	je .a
	mov byte [es:si], bl
	inc dl
	inc si
	jmp .loop
.a:
	add si, VIDEO_W - CELL_SIZE
	xor dl, dl
	inc dh
	cmp dh, CELL_SIZE
	jne .loop

	ret

times 510-($-$$) db 0
dw 0xAA55

incbin 'bin/run.bin'