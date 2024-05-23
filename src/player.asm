; player.asm

[bits 16]

player:
	mov bl, [pallete.3]
	mov cx, [playerpos.x]
	mov dx, [playerpos.y]
	call draw_cell

.hold:
	mov ah, 1
	int 0x16
	jz .hold

	mov cx, [playerpos.x]
	mov dx, [playerpos.y]

	cmp al, 'd'
	je .right
	cmp al, 'a'
	je .left
	cmp al, 'w'
	je .up
	cmp al, 's'
	je .down

	jmp .hold

.right:
	cmp cx, VIDEO_W / CELL_SIZE - 1
	je .skip
	inc byte [playerpos.x]
	jmp .move
.left:
	cmp cx, 0
	je .skip
	dec byte [playerpos.x]
	jmp .move
.up:
	cmp dx, 0
	je .skip
	dec byte [playerpos.y]
	jmp .move
.down:
	cmp dx, VIDEO_H / CELL_SIZE - 1
	je .skip
	inc byte [playerpos.y]
	jmp .move


.move:
	mov bl, [pallete.0]
	call draw_cell

.skip:
	xor ah, ah
	int 0x16   ; clear keyboard buffer
	jmp player