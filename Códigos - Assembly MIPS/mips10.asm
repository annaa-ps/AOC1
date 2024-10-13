#Imprimindo Float 

.data 
	PI: .float 3.141592
	
.text 
	li $v0, 2 #instrução para imprimir um float 
	lwc1 $f12, PI #no caso dos float, os registradores estão no co-processador 1 (cp1) e sempre devemos colocar o valor do float 
	              #no registrador $f12, ou o valor correto não será impresso
	syscall 