# Programa para calcular e^x usando série de Taylor
# O programa lê o valor de x e calcula e^x até um termo com valor absoluto < 10^-5

.data
    msg_input: .asciiz "Insira o valor de x: "   # Mensagem para solicitar o valor de x
    msg_result: .asciiz "Resultado: "            # Mensagem para imprimir o resultado
    x: .float 0.0        # Variável para armazenar o valor de x
    epsilon: .float 0.00001  # Precisão 10^-5
    resultado: .float 1.0    # Variável que armazena o resultado da soma da série
    termo: .float 1.0         # Variável que armazena o termo atual da série

.text
main:
    # Imprimindo mensagem para o usuário inserir o valor de x
    li $v0, 4  # Instrução para imprimir string
    la $a0, msg_input  # Coloca a mensagem msg_input no registrador $a0
    syscall  # Executa a impressão da string

    # Lendo o valor de x do usuário
    li $v0, 6  # Instrução para ler ponto flutuante
    syscall  # Lê e armazena em $f0
    s.s $f0, x  # Armazena o valor de x na variável x

    # Inicialização das variáveis do cálculo
    li $t0, 1  # k = 1 (contador para o termo da série)
    l.s $f1, termo  # f1 = termo inicial (1.0)
    l.s $f2, resultado  # f2 = resultado inicial (1.0)
    l.s $f3, epsilon  # Carrega a precisão epsilon (0.00001)

# Loop para calcular a série de Taylor
calcula_serie:
    # Calculando o próximo termo: termo = (termo * x) / k
    l.s $f4, x  # Carrega x em f4
    mul.s $f5, $f1, $f4  # f5 = termo anterior * x

    # Convertendo k para ponto flutuante
    mtc1 $t0, $f6  # Move k para registrador de ponto flutuante
    cvt.s.w $f6, $f6  # Converte k para ponto flutuante

    # Dividindo: termo = (termo anterior * x) / k
    div.s $f1, $f5, $f6  # f1 = termo atual
    abs.s $f7, $f1  # Calcula o valor absoluto do termo atual

    # Verificando se o termo atual é menor que epsilon
    c.lt.s $f7, $f3  # Verifica se |termo| < epsilon
    bc1t imprime_resultado  # Se for menor, sai do loop

    # Atualizando o resultado: resultado += termo atual
    add.s $f2, $f2, $f1  # Soma o termo atual ao resultado

    # Incrementando k
    addi $t0, $t0, 1  # k++

    # Repete o loop
    j calcula_serie

# Impressão do resultado final
imprime_resultado:
    # Imprimindo a mensagem "Resultado: "
    li $v0, 4  # Instrução para imprimir string
    la $a0, msg_result  # Coloca a mensagem msg_result no registrador $a0
    syscall  # Executa a impressão

    # Imprimindo o valor final do resultado
    li $v0, 2  # Instrução para imprimir ponto flutuante
    mov.s $f12, $f2  # Move o resultado para o registrador f12
    syscall  # Imprime o resultado

    # Encerrando o programa
    li $v0, 10  # Instrução para encerrar o programa
    syscall

