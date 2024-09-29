.data 
	# .data é uma área para dados na memória principal 
	# msg -> variável; .sciiz -> tipo da variável; entre aspas a mensagem a ser exibida 
	msg: .asciiz "Olá, mundo!"
.text
	#.text é uma área para instruções do programa 
	
	li $v0, 4 #instrução para impressão de String
	la $a0, msg # load adress (la) vai indicar o endereço em que está a mensagem 
	syscall  #comando para imprimir
	
