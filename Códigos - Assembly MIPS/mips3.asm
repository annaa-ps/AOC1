#Programa para imprimir um inteiro 
.data 
	#idade - variável; .word - tipo da variável; 56 - o valor inteiro armaazenado na memória RAM
	idade: .word 56
.text 
	li $v0, 1 #instrução para imprimir um inteiro 
	lw $a0, idade #load word (lw - usado para inteiros) é responsável por ir no endereço onde está a variável idade pegar o 
	              # valor nesse endereço e colocar no registrador a0
	syscall 