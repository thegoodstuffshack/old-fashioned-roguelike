; player.asm

[bits 16]

playerpos:
.x: db 10
.y: db 10
playerStatus: db 1

player:
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
	pusha
	mov ax, turdle2
	mov cl, 2
	mov dl, 2
	call drawImageToCell
	popa
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
	jnz .redraw

	mov bl, [pallete.0]
	call drawCell       ; redraw background
	jmp .skip

.redraw:
	mov byte [playerpos.x], cl
	mov byte [playerpos.y], dl

.skip:
	call drawPlayer
	ret


drawPlayer:
	mov ax, turdle2
	mov cl, [playerpos.x]
	mov dl, [playerpos.y]
	call drawImageToCell
	ret


; change/remove colour, revive?, game over, halt/reset game
playerDead:
	mov cl, byte [playerpos.x]
	mov dl, byte [playerpos.y]
	mov bl, byte [pallete.1]
	call drawCell
	jmp $


%include "src/art/include.asm"
