; stalker.asm
; moves towards the player

[bits 16]

stalker:
	push bp
	mov bp, sp

	mov bx, word [bp+6]
	lea bx, [bx+enemy_memory]
	inc byte [bx]
	and byte [bx], 3     ; move every 4 turns
	jne .end

	; x-dir = player-enemy
	; y-dir = player-enemy
	mov bl, byte [pallete.0]
	call drawCell

	mov ch, byte [playerpos.x]
	mov dh, byte [playerpos.y]

	sub ch, cl
	mov ch, -1
	js .neg_x
	jz .zero_x
	inc ch
.zero_x:
	inc ch
.neg_x:
	sub dh, dl
	mov dh, -1
	js .neg_y
	jz .zero_y
	inc dh
.zero_y:
	inc dh
.neg_y:
	add cl, ch
	add dl, dh

; do enemy collision check on obstacles and other enemies
	mov ax, map
	call checkWallCollision
	jnz .collided
	call checkEoECollision
	jnz .collided

.collision_end:
	mov bl, byte [pallete.4]
	call drawCell

.end:
	pop bp
	ret

; for now, just don't move
.collided:
	sub cl, ch
	sub dl, dh
	jmp .collision_end
