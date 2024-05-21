; draw_cell.asm
; colours a cell on screen according to CELL_SIZE

[bits 16]

%include 'src/common.asm'

; input bl: colour
; input cx: cell x
; input dx: cell y
draw_cell:
	cmp cx, VIDEO_W / CELL_SIZE
	jnb .end
	cmp dx, VIDEO_H / CELL_SIZE
	jnb .end
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

.row:
	cmp dl, CELL_SIZE
	je .col
	mov byte [es:si], bl
	inc dl
	inc si
	jmp .row
.col:
	add si, VIDEO_W - CELL_SIZE
	xor dl, dl
	inc dh
	cmp dh, CELL_SIZE
	jne .row
.end:
	ret
