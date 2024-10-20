.data
    dim: .word 512                          # Dimensão das matrizes (512x512)
    matriz_A: .space 524288                # Matriz A (512x512, 4 bytes por float)
    matriz_B: .space 524288                # Matriz B (512x512, 4 bytes por float)
    matriz_C: .space 524288                # Matriz C (resultado)
    espaco: .asciiz " "                     # Espaço para impressão
    quebra_linha: .asciiz "\n"              # Nova linha para impressão

.text
.globl main

main:
    # Inicializa matrizes A e B com valores
    li $t0, 0                               # i = 0
    la $t2, matriz_A                        # Carrega endereço da matriz A
    la $t3, matriz_B                        # Carrega endereço da matriz B

inicializa_matrizes:
    bge $t0, 512, multiplica                # Se i >= 512, vai para multiplicação
    li $t1, 0                               # j = 0
inicializa_coluna:
    bge $t1, 512, inicializa_linha          # Se j >= 512, próxima linha

    # Inicializa A[i][j] com 1.0
    li $t4, 0x3F800000                      # Valor hexadecimal de 1.0
    sw $t4, 0($t2)                          # Armazena A[i][j]

    # Inicializa B[i][j] com 2.0
    li $t4, 0x40000000                      # Valor hexadecimal de 2.0
    sw $t4, 0($t3)                          # Armazena B[i][j]

    addi $t2, $t2, 4                        # Avança para próxima posição em A
    addi $t3, $t3, 4                        # Avança para próxima posição em B
    addi $t1, $t1, 1                        # j++
    j inicializa_coluna

inicializa_linha:
    addi $t0, $t0, 1                        # i++
    j inicializa_matrizes                   # Próxima linha

multiplica:
    jal mulmat_ijk                          # Chama multiplicação ijk
    jal imprimir_C                          # Imprime matriz C
    li $v0, 10                              # Encerra programa
    syscall

# Função: mulmat_ijk
mulmat_ijk:
    lw $t0, dim                             # Carrega N (512)
    li $t1, 0                               # i = 0

ijk_linha:
    bge $t1, $t0, fim_mulmat_ijk            # Se i >= N, fim
    li $t2, 0                               # j = 0

ijk_coluna:
    bge $t2, $t0, proxima_linha             # Se j >= N, próxima linha

    # Inicializa soma = 0.0 (usando 0x00000000 para zero)
    li $t4, 0x00000000                      # Inicializa soma como 0.0 (zero)
    mtc1 $t4, $f4                            # Move para o registrador de ponto flutuante

    li $t3, 0                               # k = 0
ijk_k:
    bge $t3, $t0, armazenar_resultado       # Se k >= N, armazena

    # A[i][k]
    la $t5, matriz_A                        
    mul $t6, $t1, 512                        # 512 é o tamanho da linha
    add $t6, $t6, $t3                       # Índice de A[i][k]
    mul $t6, $t6, 4                          # Multiplica por 4 (tamanho do float)
    add $t5, $t5, $t6                       # Endereço de A[i][k]
    lwc1 $f7, 0($t5)                        # Carrega A[i][k]

    # B[k][j]
    la $t8, matriz_B                       
    mul $t6, $t3, 512                        # 512 é o tamanho da linha
    add $t6, $t6, $t2                       # Índice de B[k][j]
    mul $t6, $t6, 4                          # Multiplica por 4 (tamanho do float)
    add $t8, $t8, $t6                       # Endereço de B[k][j]
    lwc1 $f9, 0($t8)                        # Carrega B[k][j]

    # soma += A[i][k] * B[k][j]
    mul.s $f10, $f7, $f9                    # Multiplica A[i][k] * B[k][j]
    add.s $f4, $f4, $f10                     # soma += resultado

    addi $t3, $t3, 1                        # k++
    j ijk_k

armazenar_resultado:
    # C[i][j] = soma
    la $t5, matriz_C                        
    mul $t6, $t1, 512                        # 512 é o tamanho da linha
    add $t6, $t6, $t2                       # Índice de C[i][j]
    mul $t6, $t6, 4                          # Multiplica por 4 (tamanho do float)
    add $t5, $t5, $t6                       # Endereço de C[i][j]
    swc1 $f4, 0($t5)                        # Armazena resultado em C[i][j]

    addi $t2, $t2, 1                        # j++
    j ijk_coluna

proxima_linha:
    addi $t1, $t1, 1                        # i++
    j ijk_linha

fim_mulmat_ijk:
    jr $ra                                   # Retorna da função

# Função: imprimir_C
imprimir_C:
    li $t0, 0                                # i = 0
    li $t1, 0                                # j = 0

imprimir_elemento:
    bge $t1, 512, proxima_linha_imprimir    # Se j >= 512, próxima linha
    la $t4, matriz_C                        
    mul $t5, $t0, 512                        # 512 é o tamanho da linha
    add $t5, $t5, $t1                       # Índice de C[i][j]
    mul $t5, $t5, 4                          # Multiplica por 4 (tamanho do float)
    add $t4, $t4, $t5                       # Endereço de C[i][j]
    lwc1 $f0, 0($t4)                        # Carrega C[i][j]

    # Converte para inteiro antes de imprimir
    cvt.w.s $f0, $f0                        # Converte de float para inteiro
    mfc1 $a0, $f0                           # Move o valor convertido para $a0

    li $v0, 1                                # Serviço de impressão de inteiro
    syscall                                  # Imprime o valor

    li $v0, 4
    la $a0, espaco
    syscall                                  # Imprime espaço

    addi $t1, $t1, 1                        # j++
    j imprimir_elemento

proxima_linha_imprimir:
    li $v0, 4
    la $a0, quebra_linha
    syscall                                  # Imprime nova linha

    addi $t0, $t0, 1                        # i++
    li $t1, 0                                # j = 0
    bne $t0, 512, imprimir_elemento         # Repete até i < 512

    jr $ra                                   # Retorna da função
