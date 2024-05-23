; player.asm

[bits 16]

player:
.hold:
	call inputWait

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
	cmp al, 10 ; ctrl+enter
	je .test

	jmp .hold

.right:
	cmp cx, VIDEO_W / CELL_SIZE - 1
	je .skip
	inc byte [playerpos.x]
	jmp .moved
.left:
	cmp cx, 0
	je .skip
	dec byte [playerpos.x]
	jmp .moved
.up:
	cmp dx, 0
	je .skip
	dec byte [playerpos.y]
	jmp .moved
.down:
	cmp dx, VIDEO_H / CELL_SIZE - 1
	je .skip
	inc byte [playerpos.y]
	jmp .moved

.test:
	cmp dx, VIDEO_H / CELL_SIZE - 1
	je .skip
	inc byte [playerpos.y]
	jmp .moved

.moved:
	mov bl, [pallete.0]
	call drawCell       ; redraw background

.skip:
	call drawPlayer
	ret



drawPlayer:
	mov bl, [pallete.3]
	mov cx, [playerpos.x]
	mov dx, [playerpos.y]
	call drawCell
	ret
