;

[bits 16]

; move enemies on map
enemyHandler:
	xor bx, bx
.enemy_logic_loop:
	cmp bx, enemy_count
	je .end
	push bx

	lea si, [bx+enemy_list]
	mov di, word [si]
	and di, 0x00FF
	shl di, 1
	add di, enemy_type_jt

	lea si, [ebx*2+enemy_positions]
	mov cx, word [si]
	mov dl, ch
	push si

	; cl: x coord
	; dl: y coord
	; bp+6: enemy memory offset
	; returns new (x,y) coord (cl,dl)
	call [di]
	
	pop si
	mov ch, dl
	mov word [si], cx

	pop bx
	inc bx
	jmp .enemy_logic_loop

.end:
	call check_player
	cmp byte [playerStatus], 0
	je playerDead
	ret


check_player:
	xor cx, cx
	xor bx, bx
.check_loop:
	cmp bx, enemy_count*2
	je .end

	lea si, [bx+enemy_positions]
	mov cx, [si]
	
	add bx, 2

	cmp cl, byte [playerpos.x]
	jne .check_loop
	cmp ch, byte [playerpos.y]
	jne .check_loop

	mov byte [playerStatus], 0
.end:
	ret


enemy_type_jt:
	dw stalker
	dw wall_monster


enemy_count equ enemy_positions - enemy_list
enemy_memory: times enemy_count db 0

enemy_list: db               0,            0,            0,           1
enemy_positions: dw coord(1,1), coord(10,10), coord(15, 2), coord(1, 0)

%include "src/enemies/stalker.asm"
