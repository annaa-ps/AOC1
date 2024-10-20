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

#--------------------------- escopo main | metodos ---------------------------
.text
.globl main
main:
#insercao parametros
    li $v0, 4
    la $a0, inicio
    syscall
    li $v0, 5
    syscall
    move $a1, $v0 #qtde parametros

 # verificacao de erros
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

    addi $t1, $t1, 4 
    addi $t0, $t0, 1 
    j whilem

resul1:
    la $a3, vetor 
    li $v0, 4
    la $a0, recebeX
    syscall

    li $v0, 5
    syscall

    move $a2, $v0 

#chama o a funcao de avalicao do polinomio (horner)
    jal avaliacaoHorner 

 #resultado final
    li $v0, 4
    la $a0, resultadoHorner
    syscall

    move $a0, $v1
    li $v0, 1
    syscall

    li $v0, 10
    syscall

# função de Horner para calcular o valor do polinômio
avaliacaoHorner:
    lw $v1, 0($a3) # inicializa o polinômio com o coeficiente de maior grau
    addi $a3, $a3, 4 #avança para o próximo coeficiente
    li $t0, 1 # inicializa o contador

whileh:
    beq $t0, $a1, resul2 
    mul $v1, $v1, $a2 
    lw $t1, 0($a3) 
    
    add $v1, $v1, $t1
    addi $t0, $t0, 1 
    addi $a3, $a3, 4
    j whileh

resul2:
    jr $ra 

erro2:
    li $v0, 4
    la $a0, erro
    syscall

    li $v0, 10
    syscall
