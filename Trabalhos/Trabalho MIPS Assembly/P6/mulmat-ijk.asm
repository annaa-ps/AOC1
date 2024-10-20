# Programa para multiplicar duas matrizes 512x512
# Inicializa A com 1.0 e B com 2.0, e armazena o resultado em C

.data
    dim: .word 512                        # Tamanho das matrizes: 512x512
    matriz_A: .space 524288               # Espaço para matriz A (512 * 512 * 4 bytes)
    matriz_B: .space 524288               # Espaço para matriz B (512 * 512 * 4 bytes)
    matriz_C: .space 524288               # Espaço para matriz C (512 * 512 * 4 bytes)
    espaco: .asciiz " "                   # Espaço entre elementos na impressão
    quebra_linha: .asciiz "\n"            # Nova linha para impressão

.text
.globl main

main:
    # Inicializa as matrizes A e B
    li $t0, 0                              # i = 0
    la $t2, matriz_A                       # Carrega endereço de A
    la $t3, matriz_B                       # Carrega endereço de B

init_matrizes:
    bge $t0, 512, multiplica               # Se i >= 512, vai para multiplicação
    li $t1, 0                              # j = 0

init_coluna:
    bge $t1, 512, init_linha               # Se j >= 512, vai para próxima linha

    # A[i][j] = 1.0 (em hexadecimal: 0x3F800000)
    li $t4, 0x3F800000
    sw $t4, 0($t2)                         # Armazena em A[i][j]

    # B[i][j] = 2.0 (em hexadecimal: 0x40000000)
    li $t4, 0x40000000
    sw $t4, 0($t3)                         # Armazena em B[i][j]

    addi $t2, $t2, 4                       # Próxima posição em A
    addi $t3, $t3, 4                       # Próxima posição em B
    addi $t1, $t1, 1                       # j++
    j init_coluna

init_linha:
    addi $t0, $t0, 1                       # i++
    j init_matrizes

# Função para multiplicar matrizes
multiplica:
    lw $t0, dim                            # Carrega N = 512
    li $t1, 0                              # i = 0

mult_linha:
    bge $t1, $t0, fim_multiplica           # Se i >= N, termina
    li $t2, 0                              # j = 0

mult_coluna:
    bge $t2, $t0, proxima_linha            # Se j >= N, vai para próxima linha

    # soma = 0.0
    li $t4, 0x00000000                     # 0.0 em float
    mtc1 $t4, $f4                          # Move para registrador de float

    li $t3, 0                              # k = 0

mult_k:
    bge $t3, $t0, armazena_resultado       # Se k >= N, armazena em C

    # A[i][k]
    la $t5, matriz_A
    mul $t6, $t1, 512                      # i * 512
    add $t6, $t6, $t3                      # i * 512 + k
    mul $t6, $t6, 4                        # (i * 512 + k) * 4
    add $t5, $t5, $t6                      # Endereço de A[i][k]
    lwc1 $f7, 0($t5)                       # Carrega A[i][k]

    # B[k][j]
    la $t8, matriz_B
    mul $t6, $t3, 512                      # k * 512
    add $t6, $t6, $t2                      # k * 512 + j
    mul $t6, $t6, 4                        # (k * 512 + j) * 4
    add $t8, $t8, $t6                      # Endereço de B[k][j]
    lwc1 $f9, 0($t8)                       # Carrega B[k][j]

    # soma += A[i][k] * B[k][j]
    mul.s $f10, $f7, $f9
    add.s $f4, $f4, $f10

    addi $t3, $t3, 1                       # k++
    j mult_k

armazena_resultado:
    # C[i][j] = soma
    la $t5, matriz_C
    mul $t6, $t1, 512                      # i * 512
    add $t6, $t6, $t2                      # i * 512 + j
    mul $t6, $t6, 4                        # (i * 512 + j) * 4
    add $t5, $t5, $t6                      # Endereço de C[i][j]
    swc1 $f4, 0($t5)                       # Armazena soma em C[i][j]

    addi $t2, $t2, 1                       # j++
    j mult_coluna

proxima_linha:
    addi $t1, $t1, 1                       # i++
    j mult_linha

fim_multiplica:
    jr $ra                                 # Retorna

# Função para imprimir matriz C
imprimir_C:
    li $t0, 0                              # i = 0

print_linha:
    bge $t0, 512, fim_impressao            # Se i >= 512, termina
    li $t1, 0                              # j = 0

print_coluna:
    bge $t1, 512, print_nova_linha         # Se j >= 512, próxima linha

    # Carrega C[i][j]
    la $t4, matriz_C
    mul $t5, $t0, 512
    add $t5, $t5, $t1
    mul $t5, $t5, 4
    add $t4, $t4, $t5
    lwc1 $f0, 0($t4)

    # Converte para inteiro e imprime
    cvt.w.s $f0, $f0
    mfc1 $a0, $f0
    li $v0, 1
    syscall

    # Imprime espaço
    li $v0, 4
    la $a0, espaco
    syscall

    addi $t1, $t1, 1                       # j++
    j print_coluna

print_nova_linha:
    # Imprime nova linha
    li $v0, 4
    la $a0, quebra_linha
    syscall

    addi $t0, $t0, 1                       # i++
    j print_linha

fim_impressao:
    jr $ra                                 # Retorna
