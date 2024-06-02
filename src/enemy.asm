;

[bits 16]

; move enemies on map
enemyHandler:
; 	mov si, word [enemy_rng_pointer]
; 	cmp si, enemy_rng_count
; 	jne .continue
; 	mov word [enemy_rng_pointer], 0xFFFF
; 	xor si, si
; .continue:
; 	inc word [enemy_rng_pointer]
; 	add si, enemy_rng
; 	mov al, byte [si]
	
; 	push ax ; random number [bp+8]

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
	;;; bp+8: random number
	; returns new (x,y) coord (cl,dl)
	call [di]
	
	pop si
	mov ch, dl
	mov word [si], cx


	pop bx
	inc bx
	jmp .enemy_logic_loop

.end:
	; pop ax
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


enemy_count equ enemy_positions - enemy_list
enemy_memory: times enemy_count db 0

enemy_list: db           0,      0,      0
enemy_positions: dw 0x0101, 0x1010, 0x2222 ; 0xYYXX



; enemy_rng_pointer: dw 0xFFFF
; enemy_rng_count equ 20
; enemy_rng:
; db 1, 2, 1, 3, 1, 2, 3, 2, 1, 2, 3, 1, 1, 1, 3, 2, 1, 1, 2, 3

%include "src/enemies/stalker.asm"
