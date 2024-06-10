;

[bits 16]

load_sectors:
	mov ah, 0x02	; read data to memory
	mov al, sector_amount-1	; no. of sectors
	mov ch, 0	    ; cylinder_count 
	mov cl, 2	    ; sector in head
	mov dh, 0	    ; head_count
	mov dl, [BOOT_DRIVE]
	xor bx, bx
	mov es, bx
	mov bx, 0x7e00
	int 0x13
	ret

; disk_handler:
; 	mov si, BOOT_DRIVE
; 	mov di, SECTOR_COUNT
	
; 	inc byte [di]	; inc sector_count
; 	mov al, [di]
; 	cmp al, [si+1]	; cmp sector_count to max_sectors
; 	jbe .end		; if below or equal, end
	
; 	mov byte [di], 1	; zero sector_count
; 	inc byte [di+1]		; inc head_count
; 	mov al, [di+1]
; 	cmp al, [si+2]	; cmp head_count to max_heads
; 	jbe .end		; if below or equal, end
	
; 	mov byte [di], 1	; zero sector_count
; 	mov byte [di+1], 0	; zero head_count
; 	inc byte [di+2]	; inc cylinder_count
; 	mov al, [di+2]
	
; 	.end:
; 	ret

; checkDrives:
; 	mov si, BOOT_DRIVE
; 	mov ah, 0x08
; 	mov dl, [si]
; 	xor di, di
; 	mov es, di
; 	int 0x13
; 	jc disk_error

; 	mov al, ch	; preserve low 8 bits of cylinder max for later
	
; 	; bits 0-5 of cl is max sector no.
; 	; starts at 1
; 	and cx, 63 ; 0b00111111
; 	mov [si+1], cl
	
; 	; dh has max no. of heads, starts at 0
; 	mov dl, dh
; 	mov [si+2], dl
	
; 	; max cylinder no., starts at 0
; 	mov cl, al
; 	mov [si+3], cl

; 	ret

; disk_error:
; 	mov al, ah
; 	call printChar
; 	mov al, 1
; 	call printChar
; 	hlt
