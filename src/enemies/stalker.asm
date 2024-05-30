; stalker.asm
; moves towards player every 1-3 (rng) turns, on average x

[bits 16]

stalker:
	push bp
	mov bp, sp





.check_player:
	cmp cx, word [playerpos.x]
	jne .end
	cmp dx, word [playerpos.y]
	jne .end

	mov byte [playerStatus], 0

.end:
	pop bp
	ret




