.data
n: .word 10000  

# Strings para impressão dos resultados
str_simple: .asciiz "Série harmônica com precisão simples (n = 10000): "
str_double: .asciiz "Série harmônica com precisão dupla (n = 10000): "

.text
.globl main

# Calcula a série harmônica com precisão simples (float)
harmonicSeriesSimple:
    # Inicializa o acumulador (sum) com 0.0
    lui $t0, 0x3F80  # Valor flutuante 1.0 em hexadecimal
    ori $t0, $t0, 0x0000
    mtc1 $t0, $f1  # Carrega 1.0 para $f1 (precisão simples)

    # Carrega o valor de n
    lw $t0, n

    # Loop para calcular a série harmônica
    li $t1, 1
simple_loop:
    # Verifica se i <= n
    ble $t1, $t0, simple_loop_body
    jal simple_loop_end  

simple_loop_body:
    # Calcula 1/i
    mtc1 $t1, $f2   # Move i para o registro de ponto flutuante
    cvt.s.w $f2, $f2  # Converte i para ponto flutuante
    div.s $f3, $f0, $f2  # Calcula 1.0/i
    # Soma 1/i à série harmônica
    add.s $f1, $f1, $f3
    # Incrementa i
    addi $t1, $t1, 1
    j simple_loop

simple_loop_end:  # Rótulo para o salto
    mov.s $f0, $f1  # Retorna o resultado em $f0
    jr $ra  # Retorna à função de chamada

# Calcula a série harmônica com precisão dupla (double)
harmonicSeriesDouble:
    # Inicializa o acumulador (sum) com 0.0
    lui $t0, 0x3FF0 
    ori $t0, $t0, 0x0000
    mtc1 $t0, $f1  

    # Carrega o valor de n
    lw $t0, n

    # Loop para calcular a série harmônica
    li $t1, 1
double_loop:
    # Verifica se i <= n
    ble $t1, $t0, double_loop_body
    jal double_loop_end  

double_loop_body:
    # Calcula 1/i
    mtc1 $t1, $f2   
    cvt.d.w $f2, $f2  
    div.d $f3, $f0, $f2  
    # Soma 1/i à série harmônica
    add.d $f1, $f1, $f3
    # Incrementa i
    addi $t1, $t1, 1
    j double_loop

double_loop_end:  # Rótulo para o salto
    mov.d $f0, $f1  
    jr $ra  

main:
    # Calcula a série harmônica com precisão simples
    jal harmonicSeriesSimple

    # Imprime o resultado da precisão simples
    la $a0, str_simple
    li $v0, 4
    syscall
    mov.s $f12, $f0  
    li $v0, 2
    syscall

    # Calcula a série harmônica com precisão dupla
    jal harmonicSeriesDouble

    # Imprime o resultado da precisão dupla
    la $a0, str_double
    li $v0, 4
    syscall
    mov.d $f12, $f0   
    li $v0, 3
    syscall

    li $v0, 10
    syscall
