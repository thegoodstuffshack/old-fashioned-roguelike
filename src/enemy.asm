;

[bits 16]

; move enemies on map
enemyHandler:
	mov si, word [enemy_rng_pointer]
	cmp si, enemy_rng_count
	jne .continue
	mov word [enemy_rng_pointer], 0xFFFF
	mov si, 0
.continue:
	inc word [enemy_rng_pointer]
	add si, enemy_rng
	mov al, byte [si]
	
	push ax ; random number

	call stalker

	pop ax


.end:
	ret


enemy_rng_pointer: dw 0
enemy_rng_count equ 20
enemy_rng:
db 1, 2, 1, 3, 1, 2, 3, 2, 1, 2, 3, 1, 1, 1, 3, 2, 1, 1, 2, 3

%include "src/enemies/stalker.asm"
