;

; input ax: pointer to map
; input bl: cell value to trigger collision (currently 1 for on, 0 for off)
; input cx: cell x
; input dx: cell y
checkCollision:
	mov di, ax

	call cellToOffset

	add di, ax
	



.end:
	ret
