; draw.asm

[bits 16]

; input bl: colour
; input cl: cell x
; input dl: cell y
drawCell:
	cmp cl, VIDEO_W / CELL_SIZE
	jnb .end
	cmp dl, VIDEO_H / CELL_SIZE
	jnb .end

	push dx
	xor dh, dh
	mov ax, VIDEO_W * CELL_SIZE
	mul dx
	mov si, ax
	mov al, CELL_SIZE
	mul cl
	add si, ax ; (y*w + x) * cSize
	pop dx

	xor ax, ax

.row:
	cmp ah, CELL_SIZE
	je .col
	mov byte [es:si], bl
	inc ah
	inc si
	jmp .row
.col:
	add si, VIDEO_W - CELL_SIZE
	xor ah, ah
	inc al
	cmp al, CELL_SIZE
	jne .row

.end:
	ret


; input ax: pointer to map
drawMap:
	mov si, ax
	mov word [drawMap.x], 0

.read_and_draw:
	mov cx, 8
	mov al, byte [si]

.word_loop:
	sub cl, 1
	push ax
	shr al, cl
	and al, 1
	jnz .wall

.wall_end:
	pop ax
	inc byte [drawMap.x]
	cmp cl, 0
	jne .word_loop
	inc si
	cmp byte [drawMap.x], VIDEO_W / CELL_SIZE
	je .nRow
	jmp .read_and_draw

.nRow:
	mov byte [drawMap.x], 0
	inc byte [drawMap.y]
	cmp byte [drawMap.y], VIDEO_H / CELL_SIZE
	je .end
	jmp .read_and_draw

.wall:
	push si
	push cx
	mov bl, [pallete.2]
	mov cl, byte [drawMap.x]
	mov dl, byte [drawMap.y]
	call drawCell
	pop cx
	pop si
	jmp .wall_end

.end:
	ret

.x: db 0
.y: db 0


turtle: db \
0, 2, 2, 2, 2, 2, 2, 0,\
2, 2, 2, 6, 2, 2, 2, 2,\
2, 2, 4, 6, 6, 4, 2, 2,\
2, 2, 6, 6, 4, 4, 2, 2,\
2, 6, 4, 6, 6, 6, 1, 1,\
2, 6, 4, 6, 4, 1, 1, 1,\
2, 2, 5, 5, 2, 5, 2, 2,\
0, 2, 5, 2, 2, 5, 2, 0


; input ax: pointer to image
; input cl: cell x
; input dl: cell y
loadImageToCell:
	mov di, ax
	
	push dx
	xor dh, dh
	mov ax, VIDEO_W * CELL_SIZE
	mul dx
	mov si, ax
	mov al, CELL_SIZE
	mul cl
	add si, ax ; (y*w + x) * cSize
	pop dx

	xor ax, ax
.row:
	cmp ah, CELL_SIZE
	je .col

	; find colour -> bl
	mov bl, byte [di]

	mov byte [es:si], bl
	inc ah
	inc si
	inc di
	jmp .row
.col:
	add si, VIDEO_W - CELL_SIZE
	xor ah, ah
	inc al
	cmp al, CELL_SIZE
	jne .row

.end:
	ret



; screen_colour_loop:				; not used
; 	xor cx, cx
; 	xor dx, dx
; 	xor bl, bl

; .loop:
; 	push cx
; 	push dx
; 	push bx
; 	call drawCell

; 	pop bx
; 	pop dx
; 	pop cx
; 	inc bl
; 	inc cx
; 	cmp cx, VIDEO_W / CELL_SIZE
; 	jne .loop
; 	inc dx
; 	xor cx, cx
; 	cmp dx, VIDEO_H / CELL_SIZE
; 	jne .loop
; 	xor dx, dx
; 	mov ah, 0x86
; 	mov cx, 0x0010
; 	mov dx, 0x0000
; 	int 0x15

; 	xor cx, cx
; 	xor dx, dx

; 	jmp .loop
