; draw_cell.asm
; colours a cell on screen according to CELL_SIZE

[bits 16]

; input bl: colour
; input cx: cell x
; input dx: cell y
drawCell:
	cmp cx, VIDEO_W / CELL_SIZE
	jnb .end
	cmp dx, VIDEO_H / CELL_SIZE
	jnb .end
	
	mov ax, VIDEO_W * CELL_SIZE
	mul dx
	push ax
	mov ax, CELL_SIZE
	mul cx
	pop si
	add ax, si ; y*w + x*csize

	xor bh, bh

	mov si, ax
	push VIDEO_ADDR
	pop es

.row:
	cmp bh, CELL_SIZE
	je .col
	mov byte [es:si], bl
	inc bh
	inc si
	jmp .row
.col:
	add si, VIDEO_W - CELL_SIZE
	xor bh, bh
	inc dh
	cmp dh, CELL_SIZE
	jne .row

.end:
	ret


; input ax: pointer to map
; input bx: map size (bytes)
drawMap:
	mov si, ax

.read_and_draw:
	cmp si, 10
	je .end
	push 0
	pop es
	mov al, byte [es:si]



.end:
	ret


screen_colour_loop:
	xor cx, cx
	xor dx, dx
	xor bl, bl

.loop:
	push cx
	push dx
	push bx
	call drawCell

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
