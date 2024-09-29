#Programa para imprimir apenas um caractere 
.data
	#caractere -> nome da variável; .byte -> tipo da variável; 'A' -> caractere a ser impresso 
	caractere: .byte 'A'  
.text 
	li $v0, 4 #instrução para imprimir char ou string 
	la $a0, caractere # la (load adress) para colocar no registrador a0 (que no caso é caractere) 
	                  # o que precisa ser impresso pelo syscall 
	syscall  