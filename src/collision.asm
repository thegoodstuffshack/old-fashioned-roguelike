;

[bits 16]

; input ax: pointer to map
; input cl: cell x
; input dl: cell y
; returns ah: collision bit, sets zero flag if 0
checkCollision:
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
	and ah, 1 ; ah = collision bit
	pop cx

.end:
	ret

