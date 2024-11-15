# Programa para converter uma string para letras minúsculas
# A string é fornecida como entrada em um buffer na memória.

.data
    string: .asciiz "HELLO WORLD!"  # String inicial em letras maiúsculas
    msg_result: .asciiz "\nString em minúsculas: "  # Mensagem para o resultado

.text
main:
    # Inicializando os registradores e carregando o endereço da string
    la $t0, string       # $t0 aponta para o início da string

loop:
    lb $t1, 0($t0)       # Carrega o próximo caractere da string em $t1
    beq $t1, $zero, end  # Se caractere for '\0', termina o loop

    # Verifica se o caractere está entre 'A' (65) e 'Z' (90)
    li $t2, 65           # $t2 = 'A'
    li $t3, 90           # $t3 = 'Z'
    blt $t1, $t2, next   # Se $t1 < 'A', vai para o próximo caractere
    bgt $t1, $t3, next   # Se $t1 > 'Z', vai para o próximo caractere

    # Converte para minúsculo: caractere += ('a' - 'A') (32)
    li $t4, 32           # $t4 = 'a' - 'A'
    add $t1, $t1, $t4    # Converte o caractere para minúsculo
    sb $t1, 0($t0)       # Armazena o caractere convertido na string

next:
    addi $t0, $t0, 1     # Incrementa o ponteiro para o próximo caractere
    j loop               # Repete o loop

end:
    # Imprime a mensagem "String em minúsculas: "
    li $v0, 4            # Instrução para imprimir string
    la $a0, msg_result   # Endereço da mensagem em $a0
    syscall              # Executa a impressão

    # Imprime a string convertida
    li $v0, 4            # Instrução para imprimir string
    la $a0, string       # Endereço da string convertida em $a0
    syscall              # Executa a impressão

    # Encerra o programa
    li $v0, 10           # Instrução para encerrar o programa
    syscall
