;
; wall monster, spawns and moves along walls (in the wall), when player gets close, attack

[bits 16]


wall_monster:
	push bp
	mov bp, sp

	mov dh, dl
	mov ch, cl

	xor ah, ah

.check_for_players:
	inc ah

.top_right:
; (y+r), 
; (y-1)*(r-1), (x+1)*(r-1), 
; (y+1)(x-1), 
; (x-1)*(r-3), (y+1)*(r-3),
; (y-1)(x+1)*(r-4),
; (x-1)




.bottom_right:

.bottom_left:

.top_left:


.end:
	pop bp
	ret