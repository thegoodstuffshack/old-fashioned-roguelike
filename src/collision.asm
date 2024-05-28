;

; input ax: pointer to map
; input cx: cell x
; input dx: cell y
; returns ah: collision bit, sets zero flag if 0
checkCollision:
	mov di, ax

	mov ax, VIDEO_W / CELL_SIZE / 8
	mul dx
	; ax = cY * 8

	push cx
	shr cx, 3
	add ax, cx
	; ax = cX / 8
	pop cx

	add di, ax ; = map + cY*8 + cX / 8

	push cx
	mov ax, cx
	and ax, 0x07
	mov ah, [di]
	mov cl, 7
	sub cl, al
	shr ah, cl
	and ah, 1 ; ah = collision bit
	pop cx

.end:
	ret

