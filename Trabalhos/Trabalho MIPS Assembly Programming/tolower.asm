# Converte string para minúsculas
.data
    string: .asciiz "HELLO WORLD!"  # String inicial
    msg_result: .asciiz "\nString em minúsculas: "  # Mensagem

.text
main:
    la $t0, string       # Ponteiro para a string

loop:
    lb $t1, 0($t0)       # Carrega caractere
    beq $t1, $zero, end  # Se '\0', fim da string

    li $t2, 65           # 'A'
    li $t3, 90           # 'Z'
    blt $t1, $t2, next   # Ignora se menor que 'A'
    bgt $t1, $t3, next   # Ignora se maior que 'Z'

    li $t4, 32           # Diferença 'a' - 'A'
    add $t1, $t1, $t4    # Converte para minúsculo
    sb $t1, 0($t0)       # Salva caractere

next:
    addi $t0, $t0, 1     # Próximo caractere
    j loop               # Repete

end:
    li $v0, 4            # Imprime mensagem
    la $a0, msg_result
    syscall

    li $v0, 4            # Imprime string convertida
    la $a0, string
    syscall

    li $v0, 10           # Fim do programa
    syscall
