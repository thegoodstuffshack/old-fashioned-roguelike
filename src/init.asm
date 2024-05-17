[bits 16]
[org 0x7c00]

jmp start


start:
	mov ah, 0x0e
	mov al, 15
	int 0x10

incbin 'bin/run.bin'

	jmp $


times 510-($-$$) db 0
dw 0xAA55