;

[bits 16]

; input ax: pointer to map
; input cl: cell x
; input dl: cell y
; returns ah: collision byte, sets zero flag if 0
checkWallCollision:
	mov di, ax

	mov al, VIDEO_W / CELL_SIZE / 8
	mul dl
	; ax = cY * 8

	push cx
	shr cl, 3
	add al, cl
	; ax = cX / 8
	pop cx

	add di, ax ; = map + cY*8 + cX / 8

	push cx
	mov al, cl
	and ax, 0x07
	mov ah, [di]
	mov cl, 7
	sub cl, al
	shr ah, cl
	and ah, 1 ; ah = collision byte
	pop cx

.end:
	ret


; input cl: cell x
; input dl: cell y
; returns ah: collision byte
; enemy on enemy collision check
checkEoECollision:
	xor ah, ah
	mov di, enemy_positions
	push cx
	mov ch, dl
.loop:
	cmp cx, word [di]
	je .collided
	add di, 2
	cmp di, enemy_positions + 2*enemy_count
	jne .loop
	jmp .end

.collided:
	xor ah, 1 ; sets zf to no

.end:
	pop cx
	ret