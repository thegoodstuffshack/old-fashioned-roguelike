; player.asm

[bits 16]

playerpos:
.x: db 10
.y: db 10
playerStatus: db 1

player:
	cmp byte [playerStatus], 0
	je playerDead

	mov cl, [playerpos.x]
	mov dl, [playerpos.y]

	cmp al, 'd'
	je .right
	cmp al, 'a'
	je .left
	cmp al, 'w'
	je .up
	cmp al, 's'
	je .down
	cmp al, 10 ; ctrl+enter
	je .test

	jmp .skip

.right:
	cmp cl, VIDEO_W / CELL_SIZE - 1
	je .skip
	inc byte [playerpos.x]
	jmp .moved
.left:
	cmp cl, 0
	je .skip
	dec byte [playerpos.x]
	jmp .moved
.up:
	cmp dl, 0
	je .skip
	dec byte [playerpos.y]
	jmp .moved
.down:
	cmp dl, VIDEO_H / CELL_SIZE - 1
	je .skip
	inc byte [playerpos.y]
	jmp .moved

.test:
	cmp dl, VIDEO_H / CELL_SIZE - 1
	je .skip
	inc byte [playerpos.y]
	jmp .moved

.moved:
	push cx
	push dx
	mov ax, map
	mov cl, byte [playerpos.x]
	mov dl, byte [playerpos.y]
	call checkCollision ; input playerpos.x, playerpos.y, revert to cx, dx
	pop dx
	pop cx
	jnz .reverse

	mov bl, [pallete.0]
	call drawCell       ; redraw background
	jmp .skip

.reverse:
	mov byte [playerpos.x], cl
	mov byte [playerpos.y], dl

.skip:
	call drawPlayer
	ret


drawPlayer:
	mov bl, [pallete.3]
	mov cl, [playerpos.x]
	mov dl, [playerpos.y]
	call drawCell
	ret


; change/remove colour, revive?, game over, halt/reset game
playerDead:
	jmp $
