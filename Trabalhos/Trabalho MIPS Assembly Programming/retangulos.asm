.data
msgSaida: .asciiz "Retângulo interseção:\n"
msgNaoHaIntersecao: .asciiz "não há interseção\n"

# Coordenadas dos dois retângulos para teste
# Retângulo 1: (x1, y1, x2, y2)
x1: .word 1
y1: .word 5
x2: .word 6
y2: .word 3

# Retângulo 2: (x3, y3, x4, y4)
x3: .word 2
y3: .word 4
x4: .word 7
y4: .word 1

.text
.globl main

main:
    # Carrega as coordenadas do Retângulo 1
    lw $t0, x1  # x1
    lw $t1, y1  # y1
    lw $t2, x2  # x2
    lw $t3, y2  # y2

    # Carrega as coordenadas do Retângulo 2
    lw $t4, x3  # x3
    lw $t5, y3  # y3
    lw $t6, x4  # x4
    lw $t7, y4  # y4

    # Calcula as coordenadas do retângulo de interseção
    # xi1 = max(x1, x3)
    bge $t4, $t0, set_xi1_x3  # Se x3 >= x1, usa x3
    move $t8, $t0             # Caso contrário, usa x1
    j set_xi1_done
set_xi1_x3:
    move $t8, $t4             # xi1 = x3
set_xi1_done:

    # yi1 = min(y1, y3)
    ble $t5, $t1, set_yi1_y3  # Se y3 <= y1, usa y3
    move $t9, $t1             # Caso contrário, usa y1
    j set_yi1_done
set_yi1_y3:
    move $t9, $t5             # yi1 = y3
set_yi1_done:

    # xi2 = min(x2, x4)
    ble $t6, $t2, set_xi2_x4  # Se x4 <= x2, usa x4
    move $s0, $t2             # Caso contrário, usa x2
    j set_xi2_done
set_xi2_x4:
    move $s0, $t6             # xi2 = x4
set_xi2_done:

    # yi2 = max(y2, y4)
    bge $t7, $t3, set_yi2_y4  # Se y4 >= y2, usa y4
    move $s1, $t3             # Caso contrário, usa y2
    j set_yi2_done
set_yi2_y4:
    move $s1, $t7             # yi2 = y4
set_yi2_done:

    # Verifica se há interseção
    # Condições: xi1 < xi2 e yi1 > yi2
    blt $t8, $s0, check_y # xi1 < xi2?
    j no_intersection
check_y:
    bgt $t9, $s1, intersection # yi1 > yi2?
    j no_intersection

intersection:
    # Exibe mensagem de saída
    li $v0, 4
    la $a0, msgSaida
    syscall

    # Exibe xi1
    li $v0, 1
    move $a0, $t8
    syscall
    # Exibe espaço
    li $v0, 11
    li $a0, 32
    syscall

    # Exibe yi1
    li $v0, 1
    move $a0, $t9
    syscall
    # Exibe espaço
    li $v0, 11
    li $a0, 32
    syscall

    # Exibe xi2
    li $v0, 1
    move $a0, $s0
    syscall
    # Exibe espaço
    li $v0, 11
    li $a0, 32
    syscall

    # Exibe yi2
    li $v0, 1
    move $a0, $s1
    syscall
    # Fim da linha
    li $v0, 11
    li $a0, 10
    syscall

    j end

no_intersection:
    # Exibe mensagem de interseção vazia
    li $v0, 4
    la $a0, msgNaoHaIntersecao
    syscall

end:
    # Finaliza o programa
    li $v0, 10
    syscall
