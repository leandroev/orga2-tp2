global ImagenFantasma_asm

section .rodata
	mul09: dd 0.9, 0.9, 0.9, 1.0
	calc_b: dd 1.0, 2.0, 1.0, 0.0
	div8: TIMES 4 dd 8.0

section .text
;void ImagenFantasma_asm (uint8_t *src, uint8_t *dst, int width, int height,
;                      int src_row_size, int dst_row_size, int offsetx, int offsety);
; rdi <- *src, rsi <- *dst, edx <- width, ecx, height, r8d <- src_row_size, r9d <- dst_row_size
; stack_arg1 <- offsetx, stack_arg2 <- offsety
ImagenFantasma_asm:
	push rbp
	mov rbp, rsp
	push rbx
	push r12 
	push r13
	push r14
	push r15
	mov ebx, [rbp+16] 		; rbx <- offsetx
	mov r12d, [rbp+24] 		; r12 <- offsety

	mov edx, edx 			; limpio parte alta rdx
	push rdx 				; apilo rdx
	
	mov rax, rdx 			; rax <- width
	mul ecx 				; rax <- width*height
	mov r14, rax
	
	; calculo offsetx e offsety
	shl rbx, 2 				; offsetx * 4

	mov rax, r12 			
	mov r9d, r9d
	mul r9d
	mov r13, rax 			; offsety * 4 * height

	mov r15, rdi
	add r15, rbx
	add r15, r13			; r15 <- puntero a *matriz de calculo b
	
	pop rdx
	shr r9, 1 				; row_size/2
	shr rdx, 1 				; width/2
	mov r8, rdx 			; width/2

	pxor xmm0, xmm0			; limpio xmm0
	pxor xmm15, xmm15 		; limpio xmm15
	movdqu xmm13, [calc_b] 	; xmm13: |0|1|2|1|
	movdqu xmm14, [mul09] 	; xmm14: |1|0.9|0.9|0.9|

	movdqu xmm12, [div8] 	
	mov r10, 2 				; 
	; r10 lo utilizo para saber si tengo que cambiar la fila del cuadro para calcular b
	; ya que recorreremos esa fila por cada 2 filas de la imagen fuente/destino

	.ciclo:
	; calculo b/2
	movd xmm5, [r15] 		; xmm5: |0|...|0|a0|r0|g0|b0|
	punpcklbw xmm5, xmm15 	; xmm5: |0|0|0|0|a0|r0|g0|b0|
	punpcklwd xmm5, xmm15 	; xmm5: |a0|r0|g0|b0|
	
	cvtdq2ps xmm5, xmm5		; convierto a floats
	
	mulps xmm5, xmm13 		; xmm5: |0|r0|2*g0|b0|
	haddps xmm5, xmm5		; xmm5: |r0|2*g0+b0|r0|2*g0+b0|
	haddps xmm5, xmm5 		; xmm5: |r0+2*g0+b0|r0+2*g0+b0|r0+2*g0+b0|r0+2*g0+b0|
	psrldq xmm5, 4 			; xmm5: |0|r0+2*g0+b0|r0+2*g0+b0|r0+2*g0+b0|
	
	divps xmm5, xmm12 		; xmm5: |0|b/2|b/2|b/2|
	
	; procedimieto de los pixeles
	movq xmm0, [rdi] 		; xmm0: 127-bit |0000|0000|pixel1|pixel 0| 0-bit	=
							; xmm0: 127-bit |0|0|0|0|0|0|0|0|a1|r1|g1|b1|a0|r0|g0|b0| 0-bit 
	punpcklbw xmm0, xmm15 	; xmm0: |a1|r1|g1|b1|a0|r0|g0|b0|
	movdqu xmm1, xmm0 		; xmm1 = xmm0
	punpcklwd xmm0, xmm15	; xmm0: |a0|r0|g0|b0|
	punpckhwd xmm1, xmm15	; xmm1: |a1|r1|g1|b1|

	cvtdq2ps xmm0, xmm0		; convierto a floats
	cvtdq2ps xmm1, xmm1

	mulps xmm0, xmm14 		; multiplico x 0.9
	addps xmm0, xmm5 		; + b/2
	
	mulps xmm1, xmm14		; multiplico x 0.9
	addps xmm1, xmm5 		; + b/2

	cvtps2dq xmm0, xmm0 	; convierto a enteros
	cvtps2dq xmm1, xmm1 	; convierto a enteros
	 
	packusdw xmm0, xmm1 	; (|a1|r1|g1|b1|a0|r0|g0|b0|) * 0.9 + b/2
	packuswb xmm0, xmm15    ; (|0|0|0|0|0|0|0|0|a1|r1|g1|b1|a0|r0|g0|b0|) * 0.9 + b/2

	movq [rsi], xmm0 		; *src <- xmm0 : pixel 1|pixel 0	
	
	add r15, 4 				; avanzo un pixel
	dec r8 					
	cmp r8, 0
	jne .sigo
	mov r8, rdx 			; r8 = width/2
	dec r10 				
	cmp r10, 0
	je .cambio_fila
	sub r15, r9 			; vuelve al inicio de la fila para el calculo de b
	jmp .sigo

	.cambio_fila:
	add r15, r9 			; voy a la siguiente fila para el calculo de b
	mov r10, 2

	.sigo:
	add rdi, 8 				; avanzo 2 pixeles
	add rsi, 8 				; avanzo 2 pixeles
	sub r14, 2 				; dos pixeles menos que procesar
	cmp r14, 0 				; chequeo si ya no quedan pixeles por procesar
	je .fin
	jmp .ciclo

	.fin:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
ret
