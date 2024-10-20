.data 
array: .word 12,15,10,5,7,3,2,1 # Nosso vetor!
msg_inicial:   .asciiz "Vetor inicial: " # Mensagem para printar o vetor inicial
msg_ordenado:  .asciiz "Vetor ordenado: " # Mensagem para printar o vetor ordenado
newline:      .asciiz "\n"              # Para quebrar linha

# 		       ATENCAO! SE FOR ALTERAR A QUANTIDADE DE ELEMENTOS, 
# 	     >>>> ALTERE <<<<< AS SEGUINTES LINHAS: 38 E 169 COM A NOVA QUANTIDADE
# 			SE NÃO ALTERAR, ELE VAI QUEBRAR! EU TO AVISANDO!

.text
.globl main

main:
	jal print_vetor_inicial		# Imprime o vetor inicial, e usamos JAL para voltar pra cá quando terminar

	# Iniciando bonitinho nossas informações apra a chamada o quicksort!
	la $t0, array 			# Carrega o endereço do array no registrador $t0.
	addi $a0, $t0, 0 		# Define o argumento 1 como o array.
	addi $a1, $zero, 0 		# Define o argumento 2 como (low = 0)
	addi $a2, $zero, 7 		# Define o argumento 3 como (high = 7, último índice no array)
	jal quicksort 			# Chama o quicksort
	
	jal print_vetor_ordenado	# Chegando aqui, é sinal que o vetor está ordenado, então basta que imprimamos ele <3

	li $v0, 10 		# Termina a execução do programa, ieeeeei
	syscall 		# Sai ENFIM

# ====================================================== PRINTS DE ESTETICA E TAMBÉM CONTROLE DOS VALORES !
print_vetor_inicial: 
	li $v0, 4             # syscall para imprimir string "Vetor inicial:"
	la $a0, msg_inicial   # carrega o endereço da string
	syscall               # executa a syscall
	
	# Loop para imprimir o vetor inicial
	la $t0, array         # Carrega o endereço do array no registrador $t0.
	li $t1, 0             # Índice do vetor
	li $t2, 8             # SE FOR BOTAR MAIS ELEMENTOS, ALTERA AQUI!
	
print_loop_inicial:
	beq $t1, $t2, print_inicial_end  # Se t1 == 8, fim do vetor
	sll $t3, $t1, 2                  # t3 = t1 * 4 (multiplica por 4 para acessar o próximo elemento do array)
	add $t4, $t0, $t3                # t4 = endereço de array[t1]
	lw $a0, 0($t4)                   # Carrega array[t1] em $a0
	
	li $v0, 1                        # syscall para imprimir inteiro
	syscall                          # executa a syscall
	
	# Imprimir uma nova linha após cada elemento
	li $v0, 4                        # syscall para imprimir string
	la $a0, newline                  # carrega o endereço de newline (ou um espaço se preferir)
	syscall
	
	addi $t1, $t1, 1                 # t1 = t1 + 1 (próximo índice)
	j print_loop_inicial             # repete o loop
	
print_inicial_end:
	jr $ra                           # Retorna para a função main
# ====================================================== FIM DO CONTROLE DOS NOSSOS PRINTS
	
	
# ====================================================== INICIO DAS NOSSAS FUNÇOES CENTRAIS DO QUICKSORT

swap:	# A função swap troca os valores de dois elementos do array. Ela pega os índices dos elementos,
	# salva um valor temporario, troca os dois, e coloca o valor salvo na outra posiçao.
	addi $sp, $sp, -12	# Cria espaço na pilha para três valores
	sw $a0, 0($sp)		# Armazena a0
	sw $a1, 4($sp)		# Armazena a1
	sw $a2, 8($sp)		# Armazena a2
	sll $t1, $a1, 2 	#t1 = 4a
	add $t1, $a0, $t1	#t1 = arr + 4a
	lw $s3, 0($t1)		#s3 = array[a]
	sll $t2, $a2, 2		#t2 = 4b
	add $t2, $a0, $t2	#t2 = arr + 4b
	lw $s4, 0($t2)		#s4 = arr[b]
	sw $s4, 0($t1)		#arr[a] = arr[b]
	sw $s3, 0($t2)		#arr[b] = temp 
	addi $sp, $sp, 12	# Restaura o tamanho da pilha
	jr $ra			# Retorna ao chamador
	
	
partition: # A função partition divide o array em duas partes em torno de um pivô.
	   # Ela percorre o array, movendo os valores menores pro lado esquerdo e os maiores pro direito. No fim, coloca o pivô na posiçao correta.
	addi $sp, $sp, -16	# Cria espaço para 5 valores na pilha
	sw $a0, 0($sp)		# Armazena a0
	sw $a1, 4($sp)		# Armazena a1
	sw $a2, 8($sp)		# Armazena a2
	sw $ra, 12($sp)		# Armazena o endereço de retorno
	move $s1, $a1		#s1 = low
	move $s2, $a2		#s2 = high
	sll $t1, $s2, 2		# t1 = 4*high
	add $t1, $a0, $t1	# t1 = arr + 4*high
	lw $t2, 0($t1)		# t2 = arr[high] //pivot
	addi $t3, $s1, -1 	#t3, i=low -1
	move $t4, $s1		#t4, j=low
	addi $t5, $s2, -1	#t5 = high - 1

	forloop: # A função percorre o array comparando cada elemento com o pivô. Se o valor for menor que o pivô, ele troca de lugar
		 # com o elemento da esquerda. Isso continua até que todos os elementos tenham sido verificados e organizados em torno do pivô.
		slt $t6, $t5, $t4	#t6=1 se j>high-1, t7=0 se j<=high-1
		bne $t6, $zero, endfor	#se t6=1 então vá para endfor
		sll $t1, $t4, 2		#t1 = j*4
		add $t1, $t1, $a0	#t1 = arr + 4j
		lw $t7, 0($t1)		#t7 = arr[j]
		slt $t8, $t2, $t7	#t8 = 1 se pivot < arr[j], 0 se arr[j]<=pivot
		bne $t8, $zero, endfif	#se t8=1 então vá para endfif
		addi $t3, $t3, 1	#i=i+1
		move $a1, $t3		#a1 = i
		move $a2, $t4		#a2 = j
		jal swap		#troca(arr, i, j)
		addi $t4, $t4, 1	#j++
		j forloop

	    endfif: # o código marca o fim da condição dentro do loop. Se o elemento não precisou ser trocado (porque era maior que o pivô),
	    	    # ele simplesmente avança pro próximo sem fazer nada, voltando ao loop principal.
		addi $t4, $t4, 1	#j++
		j forloop		#volta para forloop

	endfor: #  quando todos os elementos já foram verificados, o código sai do loop e faz uma última troca, colocando o pivô na sua
		#  posição correta no array.
		addi $a1, $t3, 1	#a1 = i+1
		move $a2, $s2		#a2 = high
		add $v0, $zero, $a1	#v0 = i+1 retorno (i + 1);
		jal swap		#troca(arr, i + 1, high);
		lw $ra, 12($sp)		#endereço de retorno
		addi $sp, $sp, 16	#restaura a pilha
		jr $ra			#retorna ao chamador


quicksort: # a função divide o array recursivamente. Ela verifica se o subarray tem mais de um elemento (comparando "low" e "high").
	   # Se sim, chama a função partition pra achar a posição correta do pivô. Depois, o quicksort é chamado de novo pra ordenar
	   # as duas partes, uma antes e outra depois do pivô, repetindo até tudo estar ordenado.
	addi $sp, $sp, -16	# Cria espaço para 4 valores na pilha
	sw $a0, 0($sp)		# armazena a0
	sw $a1, 4($sp)		# armazena low
	sw $a2, 8($sp)		# armazena high
	sw $ra, 12($sp)		# armazena o endereço de retorno
	move $t0, $a2		#salva high em t0
	slt $t1, $a1, $t0	# t1=1 se low < high, senão 0
	beq $t1, $zero, endif	# se low >= high, endif
	jal partition		# chama a partição
	move $s0, $v0		# pivô, s0 = v0
	lw $a1, 4($sp)		#a1 = low
	addi $a2, $s0, -1	#a2 = pi -1
	jal quicksort		#chama o quicksort
	addi $a1, $s0, 1	#a1 = pi + 1
	lw $a2, 8($sp)		#a2 = high
	jal quicksort		#chama o quicksort


 endif:  # o código finaliza a condição que verifica se ainda tem elementos pra ordenar.
 	 # Se não tiver, ele pula essa parte e termina o processo.
 	lw $a0, 0($sp)		#restaura a0
 	lw $a1, 4($sp)		#restaura a1
 	lw $a2, 8($sp)		#restaura a2
 	lw $ra, 12($sp)		#restaura o endereço de retorno
 	addi $sp, $sp, 16	#restaura a pilha
 	jr $ra			#retorna ao chamador


# ====================================================== PRINTS DE ESTETICA E TAMBÉM SAIA DOS DO VALORES QUE FORAM ORDENADOS! XD
print_vetor_ordenado:
	li $v0, 4             # syscall para imprimir string "Vetor ordenado:"
	la $a0, msg_ordenado  # carrega o endereço da string
	syscall               # executa a syscall
	
	la $t0, array         # Carrega o endereço do array no registrador $t0.
	li $t1, 0             # Índice do vetor
	li $t2, 8             # SE FOR BOTAR MAIS ELEMENTOS, ALTERA AQUI!
	
print_loop_ordenado:
	beq $t1, $t2, print_ordenado_end # Se t1 == 8, fim do vetor
	sll $t3, $t1, 2                  # t3 = t1 * 4 (multiplica por 4 para acessar o próximo elemento do array)
	add $t4, $t0, $t3                # t4 = endereço de array[t1]
	lw $a0, 0($t4)                   # Carrega array[t1] em $a0
	
	li $v0, 1                        # syscall para imprimir inteiro
	syscall                          # executa a syscall
	
	# Imprimir uma nova linha após cada elemento, lindo lindo lindo
	li $v0, 4                        # syscall para imprimir string
	la $a0, newline                  # carrega o endereço de newline (ou um espaço se preferir)
	syscall
	
	addi $t1, $t1, 1                 # t1 = t1 + 1 (próximo índice)
	j print_loop_ordenado            # repete o loop
	
print_ordenado_end:
	jr $ra                           # Retorna para a função main
	
# ====================================================== FIM DO CONTROLE DOS NOSSOS PRINTS