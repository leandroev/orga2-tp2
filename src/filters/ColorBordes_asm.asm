extern ColorBordes_c
global ColorBordes_asm

section .rodata
	blanco: TIMES 4 db 255, 255, 255, 255
	transparencia: TIMES 2 db 0,0,0,255
section .text
					; void ColorBordes_asm (uint8_t *src, uint8_t *dst, int width, int height,
ColorBordes_asm:	; 						rdi <- src, rsi <- dst, edx <- width, ecx <- height 
                    ;	int src_row_size, int dst_row_size);
					;	r8d <- src_row_size, r9d <- dst_row_size
	push rbp
	mov rbp, rsp
	
	mov edx, edx		; limpie parte alta ancho
	mov r10, rdx 		; r10 = ancho de imagen
	shr r10, 2 			; divido el ancho por 4 ya que estare escribiendo de a 4 pixeles(16bytes)
	movdqu xmm14, [blanco]
	.marco_blanc_sup:
		movdqu [rsi], xmm14
		add rsi, 16
		dec r10
		cmp r10, 0
		jne .marco_blanc_sup

	mov ecx, ecx 		; limpie parte alta altura
	sub ecx, 2 			; no cuento del alto de la imagen la primera y ultima fila que van de blanco
	
	mov r10, rdx
	sub r10, 2 			; no cuento del ancho de la imagen, las columnas lateras de la imagen que van de blanco
	shr r10, 1 			; divido en ancho dentro del marco por 2
	mov r11, r10 		; backup r10
	
	pxor xmm15, xmm15 	; xmm15 = | 0 ... 0 |
	mov r9d, r9d 		; limpie parte alta del ancho en bytes
	add rsi, 4 			; rsi apunta a la imagen dentro del marco blanco
	movq xmm7, [transparencia]
	.primer_columna:
		movd [rsi-4], xmm14			; pinto pixel columna0 de blanco
		.ciclo:					
		movdqu xmm0, [rdi] 			; xmm0 = |p3,p2,p1,p0| => fila i-1
		movdqu xmm1, xmm0

		movdqu xmm2, [rdi+r9]		; xmm2 = |p3,p2,p1,p0| => fila i
		movdqu xmm3, xmm2

		movdqu xmm4, [rdi+r9*2] 	; xmm4 = |p3,p2,p1,p0| => fila i+1
		movdqu xmm5, xmm4

		; calculo for ii
		punpcklbw xmm0, xmm15 		; desempaqueto en words
		movdqu xmm10, xmm0 			; guardo copia de xmm0 en xmm10
		punpckhbw xmm1, xmm15 		; desempaqueto en words
		movdqu xmm11, xmm1 			; guardo copia de xmm1 en xmm11
		psubw xmm0, xmm1 			; src_matrix[i-1][j-1] - src_matrix[i-1][j+1] | src_matrix[i-1][j] - src_matrix[i-1][j+2]
		pabsw xmm0, xmm0 			; valor absoluto xmm0

		punpcklbw xmm2, xmm15 		; desempaqueto en words
		punpckhbw xmm3, xmm15 		; desempaqueto en words
		psubw xmm2, xmm3 			; src_matrix[i][j-1] - src_matrix[i][j+1] | src_matrix[i][j] - src_matrix[i][j+2]
		pabsw xmm2, xmm2 			; valor absoluto xmm2

		punpcklbw xmm4, xmm15		; desempaqueto en words
		movdqu xmm12, xmm4 			; guardo copia de xmm2 en xmm12
		punpckhbw xmm5, xmm15 		; desempaqueto en words
		movdqu xmm13, xmm5 			; guardo copia de xmm5 en xmm13
		psubw xmm4, xmm5 			; src_matrix[i+1][j-1] - src_matrix[i+1][j+1] | src_matrix[i+1][j] - src_matrix[i+1][j+2]
		pabsw xmm4, xmm4 			; valor absoluto xmm4
		; sumatoria ii
		paddw xmm0, xmm2 			
		paddw xmm0, xmm4 			
		
		; calculo for jj
		psubw xmm10, xmm12 			; src_matrix[i-1][j-1] - src_matrix[i+1][j-1] | src_matrix[i-1][j] - src_matrix[i+1][j]
		pabsw xmm10, xmm10 			; valor absoluto xmm10
		
		psubw xmm11, xmm13 			; src_matrix[i-1][j+1] - src_matrix[i+1][j+1] | src_matrix[i-1][j+2] - src_matrix[i+1][j+2]
		pabsw xmm11, xmm11			; valor absoluto xmm10
		; sumatoria de  jj
		movdqu xmm8, xmm10
		psrldq xmm8, 8 				; xmm8 = src_matrix[i-1][j] - src_matrix[i+1][j]
		
		movdqu xmm9, xmm11
		pslldq xmm9, 8 				; src_matrix[i-1][j+1] - src_matrix[i+1][j+1]
		paddw xmm10, xmm9 			
		paddw xmm11, xmm8
	
		; suma sumatorias ii y jj
		paddw xmm0, xmm10
		paddw xmm0, xmm11
		packuswb xmm0, xmm15		; empaqueto words a bytes
		por xmm0, xmm7 				; compenentes alpha = 255
		movq [rsi], xmm0 	 		; escribo los de los dos pixeles en al imagen

		dec r10 			; menos columnas que recorrer
		cmp r10, 0
		je .cambio_fila 	; llegue a la ultima columna cambio de fila
		add rsi, 8 			; avanzo dos pixeles
		add rdi, 8 			; avanzo dos pixeles
		jmp .ciclo 			; sigo en la misma fila
		.cambio_fila: 
		mov r10, r11 		; recupero el valor de r10 inicial del ciclo
		add rsi, 16 		; avanzo 4 pixeles
		add rdi, 16 		; avanzo 4 pixeles
		movd [rsi-8], xmm14 ; pinto blanco ultimo pixel de fila
		dec rcx 			; una fila menos por recorrer
		cmp rcx, 0
		jne .primer_columna
		sub rsi, 4 			; retrocedo un pixel
	
	shr rdx, 2 				; divido el ancho por 4 ya que estare escribiendo de a 4 pixeles(16bytes)
	.marco_blanc_inf:
		movdqu [rsi], xmm14
		add rsi, 16
		dec rdx
		cmp rdx, 0
		jne .marco_blanc_inf

	pop rbp
ret
