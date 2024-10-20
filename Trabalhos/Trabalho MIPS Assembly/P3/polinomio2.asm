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

    # Chama o método de Horner
    jal metodo_horner2 

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

# Função de Horner para calcular o valor do polinômio
metodo_horner2:
    lw $v1, 0($a3) # Inicializa o polinômio com o coeficiente de maior grau
    addi $a3, $a3, 4 # Avança para o próximo coeficiente
    li $t0, 1 # Inicializa o contador

whileh:
    beq $t0, $a1, saida3 # Se o contador alcançar a quantidade de parâmetros, sai do loop
    mul $v1, $v1, $a2 # Multiplica o polinômio por X
    lw $t1, 0($a3) # Carrega o próximo coeficiente do vetor

    # Adiciona o próximo coeficiente ao polinômio multiplicado por X
    add $v1, $v1, $t1
    addi $t0, $t0, 1 # Incrementa o contador
    addi $a3, $a3, 4 # Avança para o próximo coeficiente do vetor
    j whileh

saida3:
    jr $ra # Retorna ao chamador

erro2:
    # Exibição da mensagem de erro
    li $v0, 4
    la $a0, erro
    syscall

    # Terminação do programa
    li $v0, 10
    syscall
