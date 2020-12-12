.data
    mensagem: 			.asciiz "Neuronio Perceptron \n"
    perguntatx: 		.asciiz "Qual o valor da taxa: "
    perguntaqtddados: 	.asciiz "\nQuantos dados: "
    perguntadado: 		.asciiz "\nDado: "
    msgatualpeso:		.asciiz "\n\n Peso Atual: "
    msgnovopeso:		.asciiz "\n Novo peso: "
    msgerro:			.asciiz "\n Erro: "
    msghifen:			.asciiz " - "
    qtdados:    		.word 0
    vdados:    			.word 0
    taxa:       		.float 0.05
    ent1:       		.float 0.00
    ent2:       		.float 0.8

.text
	addi $v0, $zero, 43 # Gera numero aleatorio
	syscall
	swc1 $f0, ent1
	addi $v0, $zero, 43 # Gera numero aleatorio
	syscall
	swc1 $f0, ent2
	# Carregar váriaveis
	lwc1 $f1, ent1     
    lwc1 $f2, ent2
    lwc1 $f3, vdados
    # Boas Vindas
    addi $v0, $zero, 4
	la $a0, mensagem
	syscall
	#Pergunta Taxa
	addi $v0, $zero, 4
	la $a0, perguntatx
	syscall
    
    addi $v0, $zero, 6
	syscall
	swc1 $f0, taxa
	lwc1 $f0, taxa
	
	#Pergunta Quantidade de dados
	addi $v0, $zero, 4
	la $a0, perguntaqtddados
	syscall
	
	addi $v0, $zero, 5
	syscall
	sw $v0, qtdados
	lw $t2, qtdados
	
	# Pergunta os dados
	add $t0, $zero, $zero
	addi $t4, $zero, 4
	# Inicio preenchimento do vetor
	FORDADO:
        slt $t1, $t0, $t2
        beq $t1, $zero, FIMFORDADO
        # Controle indice vetor
        mul $t3, $t0, $t4          	
		# Pergunta dado (um por vez)
		addi $v0, $zero, 4
		la $a0, perguntadado
		syscall
		# ler e armazenar
		addi $v0, $zero, 5
		syscall
		sw $v0, vdados($t3)	
		
		addi $t0, $t0, 1 ## Aumenta o $t0 (indice do FOR)
        j FORDADO	
	FIMFORDADO:
    
    # Treinar dados
    add $t6, $zero, $zero
    FORCALCULO:
        slt $t7, $t6, $t2
        beq $t7, $zero, FIMFORCALCULO
        # Controle indice vetor
        mul $t3, $t6, $t4
        
        # carrega o valor do dado        	
      	lw $s2, vdados($t3)
      	mtc1 $s2, $f13
  		cvt.s.w $f13, $f13
  		
  		# mostra os pesos atuais
  		addi $v0, $zero, 4
		la $a0, msgatualpeso
		syscall
       
        add.s $f12, $f1, $f11
		addi $v0, $zero, 2
		syscall
	
		addi $v0, $zero, 4
		la $a0, msghifen
		syscall
	
		add.s $f12, $f2, $f11
		addi $v0, $zero, 2 
		syscall
      	
      	# Calcular erro
      	add.s $f4, $f1, $f2 #(entrada1 + entrada2)
      	mul.s $f5, $f4, $f13 #(entrada1 + entrada2) * dado
      	add.s $f6, $f13, $f13 # (dado * 2)
      	sub.s $f7, $f6, $f5 # valor do erro (dado*2) - (entrada1 + entrada2)
      	
      	#mostrar valor do erro
  		addi $v0, $zero, 4
		la $a0, msgerro
		syscall
        add.s $f12, $f7, $f11
		addi $v0, $zero, 2
		syscall
    
	    # Corrigir entrada1
		mul.s $f4, $f7, $f0 # erro * taxa
		mul.s $f5, $f4, $f13 # erro * taxa * dados		
		add.s $f1, $f5, $f1 # entrada1 + (erro * taxa * dados)
	
	    # Corrigir entrada2
		mul.s $f4, $f7, $f0 # erro * taxa
		mul.s $f5, $f4, $f13 # erro * taxa * dados
		add.s $f2, $f5, $f2 # entrada2 + (erro * taxa * dados)
      			

      	# Mostra novos valores do peso do neuronio
		addi $v0, $zero, 4
		la $a0, msgnovopeso
		syscall
       
        add.s $f12, $f1, $f11
		addi $v0, $zero, 2
		syscall
	
		addi $v0, $zero, 4
		la $a0, msghifen
		syscall
	
		add.s $f12, $f2, $f11
		addi $v0, $zero, 2 
		syscall
						
		addi $t6, $t6, 1 # aumenta indice
        j FORCALCULO	
    FIMFORCALCULO:
	
 