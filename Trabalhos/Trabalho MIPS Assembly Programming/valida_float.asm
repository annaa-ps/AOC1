.data
    input_buffer: .space 32      
    prompt: .asciiz "entre com uma string: "

.text
.globl main

main:
    la $a0, prompt
    li $v0, 4
    syscall

    la $a0, input_buffer
    li $a1, 32
    li $v0, 8
    syscall

    la $a0, input_buffer
    jal floatValidate

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall

floatValidate:
    li $t0, 0
    li $t2, 0
    li $t3, 0

loop:
    lb $t1, ($a0)
    beqz $t1, end_loop

    beq $t1, '+', sinal
    beq $t1, '-', sinal

    blt $t1, '0', invalido
    bgt $t1, '9', invalido

    li $t2, 1

    beq $t0, 0, estado_digito
    beq $t0, 1, estado_digito
    beq $t0, 2, estado_digito
    beq $t0, 3, estado_digito
    beq $t0, 4, estado_digito

    j invalido

estado_digito:
    li $t0, 1
    beq $t1, 'E', expoente
    j next

ponto:
    beq $t3, 1, invalido
    li $t3, 1
    li $t0, 2
    beq $t1, 'E', expoente
    j next

sinal:
    beq $t0, 0, estado_digito
    beq $t0, 3, estado_digito
    j invalido

expoente:
    li $t0, 3
    j next

next:
    addi $a0, $a0, 1
    j loop

end_loop:
    beq $t0, 1, valido
    beq $t0, 2, valido
    j invalido

invalido:
    li $v0, 0
    jr $ra

valido:
    li $t3, 0
    li $v0, 1
    jr $ra
