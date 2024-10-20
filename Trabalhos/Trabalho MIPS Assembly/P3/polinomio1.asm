#--------------------------- metodo tradicional ---------------------------
#dados
.data
inicio: .asciiz "quantos parametros serao avaliados? (maiores que 0) \n" 
condicao: .asciiz "entre com os valores para os parametros p: \n" 
pegaParametro: .asciiz "parametro p = "
recebeX: .asciiz "valor para x:  " 
resultadoAvaliacao: .asciiz "resultado =  " 
erro: .asciiz "parametro invalido. entre com outro valor" 
vetor: .word 0:60 

#--------------------------- escopo main | metodos ---------------------------
.text
.globl main
main:
	# insercao parametros
	li $v0, 4
	la $a0, inicio
	syscall
	li $v0, 5
	syscall
	move $a1, $v0 # qtde parametros
	
	# verificacao de erro
	beq $a1, $zero, erro2
	
	li $v0, 4
	la $a0, condicao
	syscall

	li $t0, 0 
	la $t1, vetor 
	
	whilem:
		beq $t0, $a1, resul1 
		li $v0, 4
		la $a0, pegaParametro
		syscall
		
		li $v0, 5
		syscall
		sw $v0, 0($t1) 
		
		addi $t1, $t1, 4 #avança para o próximo elemento do vetor
		addi $t0, $t0, 1 # j++
		j whilem
		
	resul1:
	la $a3, vetor 
	
	li $v0, 4
	la $a0, recebeX
	syscall
	
	li $v0, 5
	syscall
	
	move $a2, $v0 # $a2 recebe o valor de x
	
#chama o a funcao de avalicao do polinomio 
	jal avaliacaoTradicional
	
# resultado final
	li $v0, 4
	la $a0, resultadoAvaliacao
	syscall
	
	move $a0, $v1
	li $v0, 1
	syscall
	
# encerra o programa
	li $v0, 10
	syscall
	
#mensagem de erro
erro2:
	li $v0, 4
	la $a0, erro
	syscall
	
	# Terminação do programa
	li $v0, 10
	syscall
#--metodo avaliacao
avaliacaoTradicional:
	
	li $v1, 0 # poly = 0
	move $t0, $a1 #parametros
	move $t1, $a2 #valor de x
	move $t2, $a3 #endereco do vetor
	li $t4, 0 # Inicialização do contador
#Se o contador alcançar a quantidade de parâmetros, sai do loop
	whilet:
		beq $t4, $t0, resul2 
		lw $t5, 0($t2)
		
		# Cálculo de X elevado à potência (n-1-i)
		move $a0, $a1 # Passa a quantidade de parâmetros para a função de potência
		subi $a0, $a0, 1 # Subtrai 1 da quantidade de parâmetros
		sub $a0, $a0, $t4 # Subtrai o valor do contador de $a0
		j pow # Chama a função de potência
		retorno:
		
		# Atualização do resultado (polinômio)
		mul $t5, $t5, $v0 # Multiplica o parâmetro pelo resultado da potência
		add $v1, $v1, $t5 # Adiciona o resultado ao polinômio
		
		addi $t4, $t4, 1 # Incrementa o contador
		addi $t2, $t2, 4 # Avança para o próximo parâmetro do vetor
		j whilet
		
	resul2:
		jr $ra # Retorna ao chamador

#calculo de (x) elevado a potencia (n)
pow:
	li $v0, 1 # Inicializa o resultado como 1
	li $t7, 0 # Inicializa o contador
	while_pow:
		beq $t7, $a0, saidaFinal # Se o contador alcançar a potência desejada, sai do loop
		mul $v0, $v0, $a2 # Multiplica o resultado por X
		addi $t7, $t7, 1 # Incrementa o contador
		j while_pow
	saidaFinal:
		j retorno # Retorna ao chamador
