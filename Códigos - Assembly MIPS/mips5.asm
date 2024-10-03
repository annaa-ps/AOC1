#Programa para subtração de inteiros (sub e subi) 

.text 
	li $t0, 75 #Colocando o valor inteiro 75 no registrador $t0
	li $t1, 25 #Colocando o valor inteiro 25 no registrador $t1
	sub $t2, $t0, $t1 #Fazendo a subtração de $t0 - $st1 e armazenando no registrador $t2 
	subi $t3, $t2, 40 #Fazendo a subtração do conteúdo de $12 com 40 e armazenando no registrador $t3