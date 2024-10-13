#Programa para leitura de strings 
#Escreva um programa que lê um nome e o imprime, no formato abaixo: 
#Qual é o seu nome?         
#Olá,________________________

.data
	pergunta: .asciiz "Qual é o seu nome?" 
	saudacao: .asciiz "Olá"
	nome: .space 25  #Variável que irá armazenar o nome com no máximo 25 caracteres 

.text 
	#impressão o conteúdo da variável pergunta 
	li $v0, 4 #instrução para imprimir string 
	la $a0, pergunta #colocando o conteúdo da variável pergunta no registrador $a0 para imprimir 
	syscall  #imprimindo o que está em $a0 
	
	#leitura do nome
	li $v0, 8 #instrução para ler string 
	la $a0, nome #colocando o conteúdo de nome no registrador $a0
	la $a1, 25  #informando o registrador $a1 o tamanho que queremos ler, nesse caso 25
	syscall 
	
	#imprimindo a saudação 
	li $v0, 4 #instrução para imprimir string 
	la $a0, saudacao #colocando o conteúdo da variável saudacao no registrador $a0 para imprimir 
	syscall 
	
	#impressão do nome 
	li $v0, 4 #instrução para imprimir string 
	la $a0, nome 
	syscall 
	