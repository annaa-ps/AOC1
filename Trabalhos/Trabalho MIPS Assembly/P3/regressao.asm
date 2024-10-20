.data
    n: .word 10
    pontos: .space 80 # Espaço para 10 pontos (10 * 2 * 4 bytes)
    A: .word 0
    B: .word 0
    
    msg_n: .asciiz "Digite o número de pontos (n >= 10): "
    msg_a: .asciiz "Coeficiente A: "
    msg_b: .asciiz "Coeficiente B: "
    msg_end: .asciiz "Programa Finalizado.\n"

.text
.globl main

# Função para inicializar a semente para números aleatórios
init_random:
    li $v0, 40 # Inicializa a semente
    syscall
    jr $ra

# Função para gerar um número aleatório entre 0 e 99
random:
    li $v0, 42 # Gera número aleatório
    syscall
    jr $ra

# Função para preencher o vetor de pontos com coordenadas aleatórias
preencher_pontos:
    li $t0, 0 # Contador de pontos
    la $t1, pontos # Endereço inicial do vetor

preencher_loop:
    beq $t0, $a0, fim_preencher # Se contador == n, sai do loop
    
    # Gera coordenada x aleatória
    jal random
    sw $v0, 0($t1)
    
    # Gera coordenada y aleatória
    jal random
    sw $v0, 4($t1)
    
    addi $t0, $t0, 1 # Incrementa contador
    addi $t1, $t1, 8 # Move para o próximo ponto no vetor
    j preencher_loop

fim_preencher:
    jr $ra

# Função para calcular a regressão linear
regressao_linear:
    # Inicializar variáveis
    li $t0, 0 # Contador
    li $t1, 0 # Sx
    li $t2, 0 # Sy
    li $t3, 0 # Sxx
    li $t4, 0 # Sxy
    la $t5, pontos # Endereço inicial do vetor
    
    # Loop para calcular as somas
regressao_loop:
    beq $t0, $a0, fim_regressao # Se contador == n, sai do loop
    
    # Carrega xi e yi
    lw $t6, 0($t5) # xi
    lw $t7, 4($t5) # yi
    
    # Calcula Sx, Sy, Sxx, Sxy
    add $t1, $t1, $t6 # Sx += xi
    add $t2, $t2, $t7 # Sy += yi
    mul $t8, $t6, $t6 # xi * xi
    add $t3, $t3, $t8 # Sxx += xi * xi
    mul $t8, $t6, $t7 # xi * yi
    add $t4, $t4, $t8 # Sxy += xi * yi
    
    addi $t0, $t0, 1 # Incrementa contador
    addi $t5, $t5, 8 # Move para o próximo ponto no vetor
    j regressao_loop
    
fim_regressao:
    # Calcula A
    mul $t8, $a0, $t4 # n * Sxy
    mul $t9, $t1, $t2 # Sx * Sy
    sub $t8, $t8, $t9 # n * Sxy - Sx * Sy
    mul $t9, $a0, $t3 # n * Sxx
    mul $t9, $t9, $t9 # n * Sxx - Sx * Sx (corrigido)
    sub $t9, $t9, $t8 # Corrige a subtração
    
    # Verifica se o denominador é zero
    beq $t9, $zero, set_zero_A # Se for zero, pula para definir A como 0
    div $t8, $t8, $t9 # A = (n * Sxy - Sx * Sy) / (n * Sxx - Sx * Sx)
    mflo $t8 # Obtém o quociente da divisão
    j store_A

set_zero_A:
    li $t8, 0 # Se for zero, A = 0

store_A:
    sw $t8, A # Salva A
    
    # Calcula B
    mul $t9, $t8, $t1 # A * Sx
    sub $t9, $t2, $t9 # Sy - A * Sx
    div $t9, $t9, $a0 # B = (Sy - A * Sx) / n
    mflo $t9 # Obtém o quociente da divisão
    sw $t9, B # Salva B
    
    jr $ra

# Função main()
main:
    # Inicializa a semente para números aleatórios
    jal init_random
    
    # Pede ao usuário o número de pontos
    li $v0, 4
    la $a0, msg_n
    syscall
    
    # Lê o número de pontos
    li $v0, 5
    syscall
    sw $v0, n
    
    # Verifica se n >= 10
    lw $t0, n
    blt $t0, 10, main # Se n < 10, volta para o início
    
    # Preenche o vetor de pontos com coordenadas aleatórias
    lw $a0, n # Passa o número de pontos para a função
    jal preencher_pontos
    
    # Calcula a regressão linear
    lw $a0, n # Passa o número de pontos para a função
    jal regressao_linear
    
    # Imprime os resultados
    li $v0, 4
    la $a0, msg_a
    syscall
    
    lw $t0, A # Carrega A
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 4
    la $a0, msg_b
    syscall
    
    lw $t0, B # Carrega B
    li $v0, 1
    move $a0, $t0
    syscall
    
    # Finaliza o programa
    li $v0, 4
    la $a0, msg_end
    syscall
    
    li $v0, 10
    syscall
