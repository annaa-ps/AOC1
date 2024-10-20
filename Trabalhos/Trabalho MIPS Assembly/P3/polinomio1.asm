.data
comeco: .asciiz "Insira quantos parametros serao analisados (diferente de 0): \n" 
aviso: .asciiz "Insira os parametros do maior para o menor coeficiente\n" 
recebe_parametros: .asciiz "Parametro: "
recebeX: .asciiz "Valor de X: " 
resultado_final: .asciiz "Resultado: " 
erro: .asciiz "Precisa ser diferente de 0 a quantidade de parametros\n" 

vetor: .word 0:100 # Declara um vetor com espaço para 100 palavras

.text
.globl main
main:
	# Exibição da mensagem para inserir a quantidade de parâmetros
	li $v0, 4
	la $a0, comeco
	syscall
	
	# Leitura da quantidade de parâmetros
	li $v0, 5
	syscall
	
	move $a1, $v0 # $a1 recebe a quantidade de parâmetros
	
	# Verificação se a quantidade de parâmetros é zero
	beq $a1, $zero, erro2
	
	# Exibição do aviso para inserir os parâmetros na ordem decrescente
	li $v0, 4
	la $a0, aviso
	syscall
	
	li $t0, 0 # Inicialização do contador
	la $t1, vetor # $t1 recebe o endereço inicial do vetor
	
	# Loop para receber os parâmetros
	whilem:
		beq $t0, $a1, saida1 # Se o contador alcançar a quantidade de parâmetros, sai do loop
		li $v0, 4
		la $a0, recebe_parametros
		syscall
		
		li $v0, 5
		syscall
		sw $v0, 0($t1) # Armazena o parâmetro no vetor
		
		addi $t1, $t1, 4 # Avança para o próximo elemento do vetor
		addi $t0, $t0, 1 # Incrementa o contador
		j whilem
		
	saida1:
	
	la $a3, vetor # $a3 recebe o endereço do vetor
	
	# Exibição da mensagem para inserir o valor de X
	li $v0, 4
	la $a0, recebeX
	syscall
	
	# Leitura do valor de X
	li $v0, 5
	syscall
	
	move $a2, $v0 # $a2 recebe o valor de X
	
	# Chama o método tradicional
	jal metodo_tradicional
	
	# Exibição do resultado final
	li $v0, 4
	la $a0, resultado_final
	syscall
	
	move $a0, $v1
	li $v0, 1
	syscall
	
	# Terminação do programa
	li $v0, 10
	syscall
	
erro2:
	# Exibição da mensagem de erro
	li $v0, 4
	la $a0, erro
	syscall
	
	# Terminação do programa
	li $v0, 10
	syscall

metodo_tradicional:
	# Inicialização do resultado (polinômio) como zero
	li $v1, 0 # poly = 0
	move $t0, $a1 # $t0 recebe a quantidade de parâmetros
	move $t1, $a2 # $t1 recebe o valor de X
	move $t2, $a3 # $t2 recebe o endereço do vetor de parâmetros
	
	li $t4, 0 # Inicialização do contador
	whilet:
		beq $t4, $t0, saida2 # Se o contador alcançar a quantidade de parâmetros, sai do loop
		lw $t5, 0($t2) # Carrega o parâmetro atual do vetor
		
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
		
	saida2:
		jr $ra # Retorna ao chamador

# Função para calcular X elevado à potência (n-1-i)
pow:
	li $v0, 1 # Inicializa o resultado como 1
	li $t7, 0 # Inicializa o contador
	while_pow:
		beq $t7, $a0, saida_da_potencia # Se o contador alcançar a potência desejada, sai do loop
		mul $v0, $v0, $a2 # Multiplica o resultado por X
		addi $t7, $t7, 1 # Incrementa o contador
		j while_pow
	saida_da_potencia:
		j retorno # Retorna ao chamador
