#Henrique Sartori Siqueira Ra:19240472
#J. Dievas J. Manhiça Ra:19076272
.data
    RAs:    .asciiz "\nInsira o RA do aluno "
    pontos: .asciiz ": "
    menu:   .asciiz "\n0 - Encerrar programa.\n1 - Cadastrar notas.\n2 - Alterar nota.\n3 - Exibir notas.\n4 - media aritmetica da turma.\n5 - Aprovados.\n-> "
	notasRA: .asciiz "\nNotas do RA "
	msgmedsala: .asciiz "\nMedia da sala: "
    space: .asciiz " "
	msg: .asciiz  "\n"
    vetorRA:  .word 0, 0, 0, 0, 0
    sizevetRA: .byte 20
    matriz: .float 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    #sizemat: .word 160
	mediasala: .float 0
    const02: .float 0.2
	const05: .float 0.5
	const20: .float 20.0
	const025: .float 0.25
	const5: .float 5.0
	const0: .float 0.0
.text
.globl main
main:
    
    jal RegRA                       # Coletar RAs

    jal Exibir						# Exibe o vetor,TESTE

    jal Sort	                    # Ordena o vetor de RA's

    jal Exibir						# Exibe o vetor,TESTE

    loopmenu:
        li $v0, 4					# Imprime a mensagem de menu
        la $a0, menu
        syscall

        li $v0, 5					# Coleta a opção do usuário
        syscall

        beq	$v0, 1, cadastronota    # Cadastrar notas
        beq $v0, 2, altnota         # Excluir nota
        beq	$v0, 3, nota       		# Exibir notas
        beq $v0, 4, media           # Exibir media da sala
        beq $v0, 5, aprovados       # Exibir aprovados
        beq $v0, 0, fim             # Encerrar programa
		j loopmenu					# Caso o usuário tenha entrada com um valor errado, volta para o menu

    cadastronota:
        jal Cadastrar				# Chama a função que cadastra as notas
									# Reinicializar os índices da matriz---------------------------------
		move $s1, $zero				# Zera o índice i
		calc:
			beq $s1, 160, retmenu	# Verifica se saiu da matriz
			jal Calcular 			# Calcular precisa considerar medias de 0,5 em 0,5 e esta função só calcula a med de 1 aluno
			addi $s1, $s1, 32		# Atualiza o valor da linha
			j calc
		retmenu:
        j loopmenu

    altnota:
        jal Alterar					# Chama a função que altera uma nota
        jal Calcular 				# Calcular precisa considerar medias de 0,5 em 0,5 e esta função só calcula a med de 1 aluno
									# Na alteração de nota há a recalculação da média do aluno
        j loopmenu

    nota:
        jal Exibnotas				# Chama a função que exibe as notas
        j loopmenu

    media:
        jal Medsala					# Chama a função que calcula a média da sala
        jal Exibirmed				# Chama a função que exibe a média da sala
        j loopmenu

    aprovados:
        jal ExibAprov				# Chama a função que exibe os aprovados
        j loopmenu
    
    fim:
        li $v0, 10                  # Encerra o programa
        syscall

#----------------------------------------------------------------------
# Função que coleta os RAs
RegRA:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    move $t0, $zero                 # Inicia o contador com 0
    lerRA:
        li $v0, 4                   # Imprime a mensagem de coleta de RA
        la $a0, RAs
        syscall


        addi $a0, $t0, 1            # Adiciona 1 ao contador para correta exibição do RA para o usuário
        li $v0, 1
        #move $a0, $t1
        syscall

        li $v0, 4                   # Acaba de imprimir a impressão da mensagem               
        la $a0, pontos
        syscall

        li $v0, 5                   # Coleta o RA do usuário
        syscall
        sll $t1, $t0, 2             # Multiplica o contador por 4
        sw $v0, vetorRA($t1)        # Salva o valor lido no vetor

        addi $t0, $t0, 1            # Incrementa o contador

        bne $t0, 5, lerRA           # Checa se preencheu o vetor

        lw $ra, 0($sp)              # Desempilha o regiistrador de retorno
        addi $sp, $sp, 4
        jr $ra

#--------------------------------------------------------------------
# Função teste para exibir os RAs TESTE
Exibir:	
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    move $t0, $zero                 # Zera o contador

    exibir:
	li $v0, 4
	la $a0, space				    # Exibe um espaço para separação dos números
	syscall
	
	li $v0, 1					    # Comando para exibir o valor
	lw $a0, vetorRA($t0)		    # Carrega o valor para exibir
	syscall
	
	addi $t0, $t0, 4                # Adiciona 4 ao contador para correta manipulação do vetor
	bne $t0, 20, exibir		        # Verifica se chegou ao final do array
	
	lw $ra, 0($sp)				    # Retira da pilha o endereço que foi chamada a main
	addi $sp, $sp, 4
	
	jr $ra

#--------------------------------------------------------------------
# Função que cadastra as notas
Cadastrar:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    la $a1, matriz					# Coleta o endereço base da matriz  
    addi $s1, $zero, 4                  #inicializa o j=4

    Le:
        add $s2, $zero, $zero        #i

        Ler1:
            add $t1, $s2, $s1 		# i+j
            add $t1, $t1, $a1       #i+j+base
            #add
            li $v0, 6                #lê float da tela e guarda em f0
            syscall
            s.s $f0, 0($t1)		    #guarda o valor lido na tela

            addi $s2, $s2, 32
            blt $s2, 160 , Ler1      #ver se ja deu notas da mesma prova para todos

            li $v0, 4
            la $a0, msg
            syscall
            addi $s1, $s1, 4             #indece j+=4
    
            blt $s1, 32, Le

    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------------------------
# Função que altera uma nota de um aluno
Alterar:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    
    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------------------------
# Função que exibe todas as notas dos alunos cadastrados
Exibnotas:
	addi $sp, $sp, -4				# Empilha o endereço de retorno da main
	sw $ra, 0($sp)

    move $s0, $zero
    li $s1, 0        				# Manipulação do vetor
    li $s2, 0        				# Manipulação da matriz
    la $a1, matriz  				# Endereço da matriz  de notas na memória
    la $a2, vetorRA   				# Endereço do vetor de RA na memória

    exibirpontos:
        beq $t0, 160, sairmenu 			# Checa se chegou no final da matriz

        li $v0, 4
        la $a0, notasRA 			# Imprime a msg de média XXXXXXXXXXXXXXX
        syscall

        add $t1, $s1, $a2 			# Coleta o RA do aluno
        lw $t2, 0($t1)

        li $v0, 1            		# Imprime o RA do aluno
        move $a0, $t2
        syscall

        li $v0, 4           		# Imprime os dois pontos
        la $a0, pontos
        syscall

		#### IMPRIMIR AS NOTAS E DPS A MÉDIA

        add $t0, $a1, $s2     		# Atualiza para chegar na posição correta da memória

        li $v0, 2
        l.s $f12, 0($t0)    		# Coleta a media da memória e imprime
        syscall

        li $v0, 4            		# Pula linha
        la $a0, msg
        syscall

        addi $s1, $s1, 1    		# Atualiza o valor da posição no vetor
        addi $s2, $s2, 32    		# Atualiza o valor da linha na matriz
        j exibirpontos

    sairmenu:
        lw $ra, 0($sp)				# Desempilha o endereço de retorno para a main
        addi $sp, $sp, 4
        jr $ra

#------------------------------------------------------------------------------------
# Função que exibe a média aritmética das médias dos alunos
Exibirmed:
	addi, $sp, $sp, -4				# Empilha o endereço de retorno para a main
	sw $ra, 0($sp)

	li $v0, 4						# Exibe a mensagem de média da sala
	la $a0, msgmedsala
	syscall

	li $v0, 2						# Exibe a média da sala
	l.s $f12, mediasala
	syscall

	li $v0, 4						# Pula linha
	la $a0, msg
	syscall

	lw $ra, 0($sp)					# Desempilha o endereço de retorno para a main
	addi $sp, $sp, 4
	jr $ra
    
#-------------------------------------------------------------------------------------
# Função que exibe os alunos aprovados
ExibAprov:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    
    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra
#-------------------------------------------------------------------------------------
# Função auxiliar para troca de valores entre duas variáveis
Swap:
	addi $t4, $s1, 4			    # Carrega j+1
	lw $t1, vetorRA($s1)			# Carrega array[j]
	lw $t2, vetorRA($t4)			# Carrega array[j+1]

	sw $t2, vetorRA($s1)			# Array[j] = array[j+1]
	sw $t1, vetorRA($t4)			# Array[j+1] = array[j]
	jr $ra						    # Retorna para o loop

#--------------------------------------------------------------------
# Função que ordena o vetor de RAs
Sort:
	addi $sp, $sp, -4			    # Armazena na pilha o endereço de retorno
	sw $ra, 0($sp)
	
	lb $s0, sizevetRA				# i = size
	
    loop1:
        blt $s0, 1, exit1			# Verifica se i < 1
        move $s1, $zero				# j = 0
        
    loop2:
        slt $t0, $s1, $s0			# Verifica se j < i
        beq $t0, $zero, exit2	

        addi $t5, $s1, 4			# Avança 1 posição no vetor para acessá-lo
        
        lw $t3, vetorRA($s1)		# $t3 recebe array[j]
        lw $t4, vetorRA($t5)		# $t4 recebe array[j+1]

        blt $t3, $t4, continua		# Se array[j+1] > array[j] está ordenado e continua no loop

        jal Swap

    continua:	
        addi $s1, $s1, 4			# Incrementa uma posição em j (4 bytes = 1 word)
        j loop2
        
    exit2:
        addi $s0, $s0, -4			# Decrementa uma posição do i, (4 bytes = 1 word)
        j loop1
        
    exit1:
        lw $ra, 0($sp)				# Retira da pilha o endereço de retorno
        addi $sp, $sp, 4
        
        jr $ra
#-------------------------------------------------------------------------------------
# Função que calcula a média de um aluno
Calcular:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

	lwc1 $f4, const05($gp)			# li.s $f4, 0.5
	lwc1 $f5, const02($gp)			# li.s $f5, 0.2
	lwc1 $f6, const20($gp)			# li.s $f6, 20.0
	lwc1 $f7, const025($gp)			# li.s $f7, 0.25

	addi $s3, $s1, 32				# s3 guardará o final de cada linha da matriz

	mtc1 $zero, $f2					# Zerando o registrador que guardará a média
	addi $s2, $s1, 4

	la $a1, matriz					# Coleta o endereço base da matriz


	add $t1, $s2, $a1 				# Adiciona a posição da matriz com seu respectivo endereço
	l.s $f1, 0($t1)					# Acessa o valor da nota P1

	mul.s $f3, $f1, $f4				# Multiplica a nota pelo seu respectivo peso

	add.s $f2, $f2, $f3				# Media += P1

	addi $s2, $s2, 4
	add $t1, $s2, $a1 				# Adiciona a posição da matriz com seu respectivo endereço
	l.s $f1, 0($t1)

	mul.s $f3, $f1, $f4				# Multiplica a nota pelo seu respectivo peso

	add.s $f2, $f2, $f3				# Media += P2

	addi $s2, $s2, 4				# Move J para o próximo elemento (primeira atividade)
	# Peso 5 para os projetos
	ativs:	
		beq $s2, $s3, fimAtiv		# Compara se chegou ao final da linha

		add $t1, $s2, $a1			# Adiciona o valor do endereço da matriz
		l.s $f1, 0($t1)				# Acessa o valor na matriz

		mul.s $f3, $f1, $f5			# Multiplica a nota pelo seu respectivo peso

		add.s $f2, $f2, $f3			# Media += Ax (x = nº da atividade)

		addi $s2, $s2, 4			# Atualizar o valor de J
		j ativs
	# Peso 2 para as atividades

    fimAtiv:
        div.s $f2, $f2, $f6			# Calcula a média

        l.s $f9, const025           # Carrega o valor de 0.25 para o loop
        add $t4,$zero,$zero         # Contador
        #Arredondamento
        #div.s $f12 $f12, $f4 			# Divide a média / 0.5
        #mfhi $f6 

        loopver:
        addi $t4, $t4, 1
        c.lt.s $f9,$f2              # c.lt.s (uma especie de um if)
                                	# f2=4.30 f9=4.5
        bc1t  lresto            
        add.s $f9, $f9, $f7
        j loopver

        lresto:
        rem $t4, $t4, 2             # A divisao por 2, nos permite ver se o contador eh par/impar
        bne $t4, 1, par         

		#sub.s $f9, $f9, $f7 #caso não estiver certo tentar esse
        sub.s $f9, $f9, $f2         # Quando impar, madia = f9-0,25 (arredonda para baixo)
        add.s $f2, $f2, $f9 ##### VER SE ESTA CERTO ESTA PARTE

        j fcomp

        par:                        # Quando for par, salva media = f9 (arredonda para cima)
        mov.s $f2,$f9               

        fcomp:
        mov.s $f12,$f2
        li $v0, 2   #---lembrar de fazer teste para ver se pega certo
        syscall

        addi $s3, $s3, -32			# Subtrai o índice da linha para chegar na posição da média
        add $t1, $s3, $a1			# Soma o endereço para chegar a posição correta na memória
	    s.s $f2, 0($t1)				# Salva a média na memória

	lw $ra, 0($sp)                  # Desempilha o registrador de retorno
	addi $sp, $sp, 4
	jr $ra

#-------------------------------------------------------------------------------------
# Função que calcula a média da sala
Medsala:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    #move $s0, $zero
    li $s1, 0        				# Manipulação do vetor
    la $a1, matriz  				# Endereço da matriz  de notas na memória
	l.s $f8, const0

    somamed:
        beq $t0, 160, sair 			# Checa se chegou no final da matriz

		add $t0, $a1, $s2     		# Atualiza para chegar na posição correta da memória
		l.s $f0, 0($t0)				# Carrega a média de uma aluno

		add.s $f8, $f8, $f0			# Soma médias += média de um aluno

        addi $s2, $s2, 32    		# Atualiza o valor da linha na matriz
        j somamed

    sair:
		l.s $f0, const5				# Carrega o valor de 5 para f0
		div.s $f8, $f8, $f0			# Realiza o cálculo da média da sala
		s.s $f8, mediasala			# Salva a média da sala na memória

    	lw $ra, 0($sp)              # Desempilha o registrador de retorno
    	addi $sp, $sp, 4
    	jr $ra

#-------------------------------------------------------------------------------------
######################################################################################
# RASCUNHO
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    
    lw $ra, 0($sp)                  # desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra

