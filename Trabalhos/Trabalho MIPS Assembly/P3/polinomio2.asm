#--------------------------- avalicao polinomial (metodo de horner) ---------------------------
#dados
.data
inicio: .asciiz "quantos parametros serao avaliados?\n"  
condicao: .asciiz "entre com os valores para os parametros p: \n" 
pegaParametro: .asciiz "parametro p = "
recebeX: .asciiz "valor para x:  " 
resultadoHorner: .asciiz "resultado = " 
erro: .asciiz "parametro invalido. entre com outro valor (diferente de 0)" 

vetor: .word 0:60 # declara um vetor com espaço para 60 palavras

.text
.globl main
main:
    # exibição da mensagem para inserir a quantidade de parâmetros
    li $v0, 4
    la $a0, inicio
    syscall

    # leitura da quantidade de parâmetros
    li $v0, 5
    syscall

    move $a1, $v0 # $a1 recebe a quantidade de parâmetros

    # verificação se a quantidade de parâmetros é zero
    beq $a1, $zero, erro2

    # exibição do aviso para inserir os parâmetros na ordem decrescente
    li $v0, 4
    la $a0, condicao
    syscall

    li $t0, 0 # inicialização do contador
    la $t1, vetor # $t1 recebe o endereço inicial do vetor

    # loop para receber os parâmetros
whilem:
    beq $t0, $a1, resul1 # se o contador alcançar a quantidade de parâmetros, sai do loop
    li $v0, 4
    la $a0, pegaParametro
    syscall

    li $v0, 5
    syscall
    sw $v0, 0($t1) # armazena o parâmetro no vetor

    addi $t1, $t1, 4 # avança para o próximo elemento do vetor
    addi $t0, $t0, 1 # incrementa o contador
    j whilem

resul1:
    la $a3, vetor # $a3 recebe o endereço do vetor

    # exibição da mensagem para inserir o valor de X
    li $v0, 4
    la $a0, recebeX
    syscall

    # leitura do valor de X
    li $v0, 5
    syscall

    move $a2, $v0 # $a2 recebe o valor de X

    # chama o método de Horner
    jal avaliacaoHorner 

    # exibição do resultado final
    li $v0, 4
    la $a0, resultadoHorner
    syscall

    move $a0, $v1
    li $v0, 1
    syscall

    # terminação do programa
    li $v0, 10
    syscall

# função de Horner para calcular o valor do polinômio
avaliacaoHorner:
    lw $v1, 0($a3) # inicializa o polinômio com o coeficiente de maior grau
    addi $a3, $a3, 4 # avança para o próximo coeficiente
    li $t0, 1 # inicializa o contador

whileh:
    beq $t0, $a1, resul2 # se o contador alcançar a quantidade de parâmetros, sai do loop
    mul $v1, $v1, $a2 # multiplica o polinômio por X
    lw $t1, 0($a3) # carrega o próximo coeficiente do vetor

    # adiciona o próximo coeficiente ao polinômio multiplicado por X
    add $v1, $v1, $t1
    addi $t0, $t0, 1 # incrementa o contador
    addi $a3, $a3, 4 # avança para o próximo coeficiente do vetor
    j whileh

resul2:
    jr $ra # retorna ao chamador

erro2:
    # exibição da mensagem de erro
    li $v0, 4
    la $a0, erro
    syscall

    # terminação do programa
    li $v0, 10
    syscall
