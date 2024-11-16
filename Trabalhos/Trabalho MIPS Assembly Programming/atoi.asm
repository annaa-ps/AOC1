.data
msg: .asciiz "Insira um numero (em decimal): "
buffer: .space 20

.text
.globl main

main:
    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 8
    la $a0, buffer
    li $a1, 20
    syscall

    la $a0, buffer #isso é para remover o \n da string
remove_newline:
    lb $t6, 0($a0)
    beq $t6, 0, convert
    beq $t6, 10, remove_end
    addi $a0, $a0, 1
    j remove_newline
remove_end:
    sb $zero, 0($a0)
    j convert
#chamada do procedimento para converter o decimal para inteiro
convert:
    la $a0, buffer
    jal atoi_decimal

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall

atoi_decimal:
    li $v0, 0
    li $t0, 10
    li $t1, -1

atoi_loop:
    lb $t2, 0($a0)
    beq $t2, 0, atoi_end
    beq $t2, 46, atoi_end

    li $t3, 48
    li $t4, 57
    blt $t2, $t3, atoi_error
    bgt $t2, $t4, atoi_error

    sub $t2, $t2, $t3
    mul $v0, $v0, $t0
    add $v0, $v0, $t2

    addi $a0, $a0, 1
    j atoi_loop
    
#retrona -1 caso tenha erro
atoi_error:
    move $v0, $t1
    j atoi_end

atoi_end:
    jr $ra