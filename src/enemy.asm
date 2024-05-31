;

[bits 16]

; move enemies on map
enemyHandler:
	mov si, word [enemy_rng_pointer]
	cmp si, enemy_rng_count
	jne .continue
	mov word [enemy_rng_pointer], 0xFFFF
	xor si, si
.continue:
	inc word [enemy_rng_pointer]
	add si, enemy_rng
	mov al, byte [si]
	
	push ax ; random number [bp+6]

	xor bx, bx
.enemy_logic_loop:
	cmp bx, enemy_count
	je .end
	push bx

	lea si, [ebx*2+enemy_positions]
	mov ax, word [si]
	xor cx, cx
	xor dx, dx
	mov cl, al
	mov dl, ah

	lea si, [bx+enemy_list]
	mov di, word [si]
	and di, 0x00FF
	shl di, 1
	add di, enemy_type_jt
	
	; cx: x coord
	; dx: y coord
	; bp+6: random number
	call [di]

	pop bx
	inc bx
	jmp .enemy_logic_loop

.check_player:
	xor cx, cx
	xor dx, dx
	xor bx, bx
.check_loop:
	cmp bx, enemy_count*2
	je .end

	lea si, [bx+enemy_positions]
	mov ax, [si]
	mov cl, al
	mov dl, ah 
	
	add bx, 2

	cmp cx, word [playerpos.x]
	jne .check_loop
	cmp dx, word [playerpos.y]
	jne .check_loop

	mov byte [playerStatus], 0

.end:
	pop ax
	ret


enemy_type_jt:
	dw stalker


enemy_count equ 1
enemy_list: db 0
enemy_positions: dw 0x0101

enemy_rng_pointer: dw 0xFFFF
enemy_rng_count equ 20
enemy_rng:
db 1, 2, 1, 3, 1, 2, 3, 2, 1, 2, 3, 1, 1, 1, 3, 2, 1, 1, 2, 3

%include "src/enemies/stalker.asm"
