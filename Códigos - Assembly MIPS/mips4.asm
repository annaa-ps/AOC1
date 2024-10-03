#Programa para soma de inteiros (add e addi) 

.text
	li $t0, 75 #Colocando o valor inteiro 75 no registrador $t0
	li $t1, 25 #Colocando o valor inteiro 25 no registrador $t1
	add $s0, $t0, $t1 #Fazendo a soma de $t0 + $st1 e armazenando no registrador $s0 
	addi $s1, $s0, 36 #Fazendo a soma do conteúdo de $s0 com 36 e armazenando no registrador $s1