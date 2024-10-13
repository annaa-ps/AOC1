# Implementar um programa que lê um float e o imprime 
.data
	msg: .asciiz "Forneça um número decimal: "
	zero: .float 0.0

.text
	#imprimindo a mensagem ao usuário 
	li $v0, 4 #instrução para imprimir uma string
	la $a0, msg #dado um load adress, para o conteúdo de msg ir para o registrador $a0 para ser impresso 
	syscall 
	
	#lendo o número
	li $v0, 6 #instrução para ler um float
	syscall #valor lido estará em $f0 
	
	
	lwc1 $f1, zero #o registrador $f1 tem o valor 0 agora
	add.s $f12, $f1, $f0         
	
	#imprimindo o número 
	li $v0, 2
	syscall 