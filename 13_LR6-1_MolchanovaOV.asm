use16
org 0x100

mov dx, filename
mov ah, 0x3C
mov cx, 0x0
mov dx, filename
int 21h
mov [n], ax   

mov ax, 0
mov es, ax
mov si, 0x82

xor si, si
push cx
mov cx, 16
dump:
	push cx
	mov cx, 16
	dump_line:
		push cx
		mov ax, [es:si]
		mov [Value], al
		mov cx, 2
		print_al:
			push cx
			push dx
			mov al, [Value]
			and al, 0xf0
			shr al, 4
			mov dl, al
			cmp dl, 0x09
			ja m1
			add  dl, 0x30
			jmp m2
			m1:
				add dl, 0x37

			m2:
				mov ah, 0x40
				mov bx, [n]
				mov cx, 1
				mov [buf], dl
				mov dx, buf
				int 0x21
				xor dx, dx
				
				mov al, [Value]
				shl al, 4
				mov [Value], al
				
			pop dx
			pop cx
		loop print_al
		pop cx
		
		pusha
		mov ah, 0x40
		mov bx, [n]
		mov cx, 1
		mov dx, str_space
		int 21h
		popa
		
		inc si
	loop dump_line
	push ax
	push dx
	;
	mov ah, 0x40
	mov bx, [n]
	mov cx, 2
	;
	mov dx, str_enter
	int 21h
	
	pop ax
	pop dx
	
	pop cx
loop dump
pop cx
int 20h

Value db 0
str_space db ' ','$'
str_enter db 0xD, 0xA, '$'
filename db 'MolchanovaOV.txt', 0 
n  dw 0  
buf db 1
; es=0x123
; si= 0x30
; 