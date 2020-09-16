#Henrique Sartori Siqueira Ra:19240472
#Jemis Dievas José Manhiça Ra:19076272
.data
    RAs:        .asciiz "\n Insira o RA do aluno "
    pontos:     .asciiz ": "
    menu:       .asciiz "\n0 - Encerrar programa.\n1 - Cadastrar notas.\n2 - Alterar nota.\n3 - Exibir notas.\n4 - Media aritmetica da turma.\n5 - Aprovados.\n-> "
	msgmedsala: .asciiz "\n Media da sala: "
    RAsord:     .asciiz "\n RAs ordenados:\n"
    space:      .asciiz " "
	msg:        .asciiz "\n"
	msg1:       .asciiz "\t"
	buscaRA:    .asciiz "\n Insira o RA do aluno em questao: "
	tabela:     .asciiz " RAs\tMedia\tP1\tP2\tAT1\tAT2\tAT3\tAT4\tAT5"
    passou:     .asciiz "\n RA aprovado: "
    msgproj:    .asciiz "\n Notas projeto "
    msgativ:    .asciiz "\n Notas atividade "
    erro:       .asciiz "\n Introduza um valor valido: "
	erroRA:     .asciiz "\n RA incorreto, insira um cadastrado no sistema: "
	avs:        .asciiz "\n Qual avaliacao deseja alterar?\n 1 - Projeto 1.\n 2 - Projeto 2.\n 3 - Atividade 1.\n 4 - Atividade 2.\n 5 - Atividade 3.\n 6 - Atividade 4.\n 7 - Atividade 5.\n-> "
	alteracao:  .asciiz "\n Insira a nota: "
	#testar:    .asciiz "\nTESTE"
    vetorRA:    .word 0, 0, 0, 0, 0
    sizevetRA:  .byte 20
    matriz:     .float 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    #sizemat:   .word 160
	mediasala:  .float 0
    const10:    .float 10.0
    const2:     .float 2.0
	const5:     .float 5.0
    const05:    .float 0.5
	const20:    .float 20.0
	const025:   .float 0.25
	const0:     .float 0.0
################################################################################
.text
.globl main
main:
    jal RegRA                       # Coletar RAs

    #jal Exibir						# Exibe o vetor TESTE

    jal Sort	                    # Ordena o vetor de RA's

    li $v0, 4						# Imprime a string de "RAs ordenados"
    la $a0, RAsord
    syscall

    jal Exibir						# Exibe a ordem dos RAs que serão coletados

    loopmenu:
        li $v0, 4					# Imprime a mensagem de menu
        la $a0, menu
        syscall

        li $v0, 5					# Coleta a opção do usuário
        syscall

        beq	$v0, 1, cadastronota    # Cadastrar notas
        beq $v0, 2, altnota         # Alterar nota
        beq	$v0, 3, nota       		# Exibir notas
        beq $v0, 4, media           # Exibir media da sala
        beq $v0, 5, aprovados       # Exibir aprovados
        beq $v0, 0, fim             # Encerrar programa
		j loopmenu					# Caso o usuário tenha entrada com um valor errado, volta para o menu

    cadastronota:
        jal Cadastrar				# Chama a função que cadastra as notas

		move $s1, $zero				# Zera o índice i
		calc:
			beq $s1, 160, retmenu	# Verifica se saiu da matriz
			jal Calcular 			# Calcular precisa considerar medias de 0,5 em 0,5 e esta função só calcula a média de 1 aluno
			addi $s1, $s1, 32		# Atualiza o valor da linha
			j calc
		retmenu:
            j loopmenu

    altnota:
        jal Alterar					# Chama a função que altera uma nota
        jal Calcular 				# Calcular precisa considerar medias de 0,5 em 0,5 e esta função só calcula a média de 1 aluno
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

################################################################################
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

################################################################################
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

################################################################################
# Função que cadastra as notas
Cadastrar:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

	li $v0, 4						# Imprime a string de "RAs ordenados"
    la $a0, RAsord
    syscall

    jal Exibir						# Exibe a ordem dos RAs que serão coletados

    la $a1, matriz					# Coleta o endereço base da matriz  
    addi $s1, $zero, 4              # Inicializa o j=4

    Le:
        add $s2, $zero, $zero       # i

        blt $s1, 9, projeto         # Verifica se vai ler projetos

        li $v0, 4                   # Imprime mensagem de atividade
        la $a0, msgativ
        syscall

        move $t0, $s1               # Reposiciona o contador para começar a contagem das atividades a partir de 1

        addi $t0, $t0, -8           # Decrementa 8 para mostrar o número correto

        div $t0, $t0, 4             # Divide o valor para o correto valor da atividade

        li $v0, 1
        move $a0, $t0               # Imprime o número da atividade
        syscall

        li $v0, 4                   # Imprime dois pontos
        la $a0, pontos
        syscall

        jal Pularlinha

        j Ler1

        projeto:
            li $v0, 4               # Imprime mensagem de projeto
            la $a0, msgproj
            syscall

            div $t0, $s1, 4         # Divide o valor para o correto valor do projeto

            li $v0, 1
            move $a0, $t0           # Imprime o número da projeto
            syscall

            li $v0, 4               # Imprime dois pontos
            la $a0, pontos
            syscall

            jal Pularlinha

        Ler1:
            add $t1, $s2, $s1 		# i + j
            add $t1, $t1, $a1       # i + j + base
            
            li $v0, 6               # Lê float da tela e guarda em f0
            syscall

            jal Verintervalo        # Verifica se a nota está no intervalo correto

            s.s $f0, 0($t1)		    # Guarda o valor lido na tela

            addi $s2, $s2, 32
            blt $s2, 160, Ler1      # Ver se atribuiu todas as notas da mesma prova para todos

            jal Pularlinha

            addi $s1, $s1, 4        # Índice j += 4
    
            blt $s1, 32, Le

        lw $ra, 0($sp)              # Desempilha o registrador de retorno
        addi $sp, $sp, 4
        jr $ra

################################################################################
# Função que altera uma nota de um aluno
Alterar:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

	li $v0, 4						# Imprime a mensagem para coletar o RA
	la $a0, buscaRA
	syscall

	jal BuscarRA					# Função que coleta e verifica se o RA existe e salva a linha do respectivo aluno em s1

	menunota:
		li $v0, 4					# Imprime a mensagem para exibir o menu de avaliações
		la $a0, avs
		syscall

		li $v0, 5					# Coleta a opção do usuário
		syscall

		blt $v0, $zero, menunota    # Verifica se a opção do usuário está no intervalo correto
		bgt $v0, 7, menunota

		sll $s2, $v0, 2				# Multiplica por 4 para chegar na coluna correta

		li $v0, 4					# Imprime a mensagem para coletar a nova nota
		la $a0, alteracao
		syscall

		li $v0, 6					# Coleta a nova nota
		syscall

		jal Verintervalo			# Verifica se a nota está entre 0 a 10

		la $a2, matriz				# Carrega o endereço da matriz

		add $t1, $a2, $s1			# Soma a linha ao endereço 
		add $t1, $t1, $s2			# Soma com a coluna para chegar na correta posição na matriz
		s.s $f0, 0($t1)				# Alteração do valor na matriz
    
        lw $ra, 0($sp)              # Desempilha o registrador de retorno
        addi $sp, $sp, 4
        jr $ra
################################################################################
# Função que coleta e verifica se o RA existe
BuscarRA:
	addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

	j leituraRA

	novamente:
		li $v0, 4					# Imprime a mensagem de erro + inserir um novo RA
		la $a0, erroRA
		syscall

	leituraRA:
		li $v0, 5					# Coleta o RA
		syscall

		la $a1, vetorRA				# Recebe o endereço do vetor na memória
		move $t0, $zero				# Índice do vetor

	percorre:
		beq $t0, 5, novamente		# Verifica se chegou no final do vetor

		sll $t1, $t0, 2				# Multiplica por 4 para chegar na posição correta do vetor
		add $t1, $t1, $a1			# Chega na posição correta do vetor na memória
	
		lw $t2, 0($t1)				# Coleta o valor do RA

		beq	$v0, $t2, found			# Verifica se o RA existe

		addi $t0, $t0, 1			# Incrementa a posição do vetor
		j percorre

	found:
		#li $v0, 4					# String de teste para encontrar o erro
		#la $a0, testar
		#syscall

		mul $s1, $t0, 32			# Multiplica por 32 para chegar na linha correta da matriz

	lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra
################################################################################
# Função que exibe todas as notas dos alunos cadastrados 
Exibnotas:
	addi $sp, $sp, -4				# Empilha o endereço de retorno da main
	sw $ra, 0($sp)

    li $s0, 0						# Manipulação do vetor
    li $s1, 0        				# Manipulação da matriz (i)
    li $s2, 0        				# Manipulação da matriz (j)
    la $a1, matriz  				# Endereço da matriz  de notas na memória
    la $a2, vetorRA   				# Endereço do vetor de RA na memória

	li $v0, 4						# Imprime cabeçalho da tabela
	la $a0, tabela
	syscall

	jal Pularlinha

    exibirpontos:
        add $t0, $s0, $a2 			# Coleta o RA do aluno
        lw $t1, 0($t0)

		li $v0, 4           		# Imprime espaço
        la $a0, space
        syscall

        li $v0, 1            		# Imprime o RA do aluno
        move $a0, $t1
        syscall

        li $v0, 4           		# Imprime tab
        la $a0, msg1
        syscall

	printnota:
		add $t2, $s1, $s2			# i + j
        add $t2, $a1, $t2     		# Atualiza para chegar na posição correta da memória

        li $v0, 2
        l.s $f12, 0($t2)    		# Coleta a nota da memória e imprime
        syscall

        li $v0, 4            		# Imprime tab
        la $a0, msg1
        syscall

		addi $s2, $s2, 4			# Atualiza j (j+=4) para a próxima coluna
		beq $s2, 32, novalinha		# Confere se terminou a linha
		j printnota

	novalinha:

		jal Pularlinha				

        addi $s0, $s0, 4    		# Atualiza o valor da posição no vetor
		li $s2, 0					# Zera j para começar na primeira coluna
        addi $s1, $s1, 32    		# Atualiza o valor da linha na matriz
		beq $s1, 160, sairmenu 		# Checa se chegou no final da matriz

        j exibirpontos

    sairmenu:
        lw $ra, 0($sp)				# Desempilha o endereço de retorno para a main
        addi $sp, $sp, 4
        jr $ra

################################################################################
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

	jal Pularlinha

	lw $ra, 0($sp)					# Desempilha o endereço de retorno para a main
	addi $sp, $sp, 4
	jr $ra
    
################################################################################
# Função que exibe os alunos aprovados 
ExibAprov:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    la $a1, vetorRA                 # Carrega o endereço do vetor
    la $a2, matriz                  # Carrega o endereço da matriz
    addi $t0, $zero, 0              # Percorrerá o vetor
    addi $t1, $zero, 0              # Percorrerá as linhas da matriz
    l.s $f1, const5                 # Carrega 5.0 em f1

    verRA:
        beq $t1, 160, retornar      # Verifica se chegou no final da matriz

        add $t2, $t1, $a2           # Soma o endereço do vetor com a posição para chegar no elemento certo da matriz
        l.s $f0, 0($t2)             # Carrega o valor da média

        c.lt.s $f0, $f1             # Verifica se o aluno reprovou
        bc1t continuar
        
        add $t2, $t0, $a1           # Soma o endereço do vetor mais a posição
        lw $v1, 0($t2)              # Carrega o RA do aluno
        
        li $v0, 4
        la $a0, passou              # Exibe a string de aprovação
        syscall

        li $v0, 1
        move $a0, $v1               # Exibe o RA do aluno aprovado
        syscall
        
    continuar:
        addi $t0, $t0, 4            # Atualiza a posição do vetor
        addi $t1, $t1, 32           # Atualiza a linha da matriz
        j verRA

    retornar:
        jal Pularlinha

    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra
################################################################################
# Função auxiliar para troca de valores entre duas variáveis
Swap:
	addi $t4, $s1, 4			    # Carrega j+1
	lw $t1, vetorRA($s1)			# Carrega array[j]
	lw $t2, vetorRA($t4)			# Carrega array[j+1]

	sw $t2, vetorRA($s1)			# Array[j] = array[j+1]
	sw $t1, vetorRA($t4)			# Array[j+1] = array[j]
	jr $ra						    # Retorna para o loop

################################################################################
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
################################################################################
# Função que calcula a média de um aluno
Calcular:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

	l.s $f4, const5					# Carrega 5 (lwc1 $f4, const05)		
	l.s $f5, const2					# Carrega 2 (lwc1 $f5, const02)
	l.s $f6, const20				# Carrega 20 (=lwc1 $f6, const20)
	l.s $f7, const025 				# Carrega 0,25 (=lwc1 $f7, const025)
    l.s $f2, const0					# Zerando o registrador que guardará a média

	addi $s3, $s1, 32				# s3 guardará o final de cada linha da matriz
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

        jal Aproxima

        mov.s $f2, $f9              # Move a média para outro registrador para salvar

        addi $s3, $s3, -32			# Subtrai o índice da linha para chegar na posição da média
        add $t1, $s3, $a1			# Soma o endereço para chegar a posição correta na memória
	    s.s $f2, 0($t1)				# Salva a média na memória

	lw $ra, 0($sp)                  # Desempilha o registrador de retorno
	addi $sp, $sp, 4
	jr $ra

################################################################################
# Função que calcula a média da sala
Medsala:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    move $s2, $zero                 # Zera o registrador que manipula a matriz
    la $a1, matriz  				# Endereço da matriz  de notas na memória
	l.s $f8, const0                 # Carrega 0

    somamed:
		add $t0, $a1, $s2     		# Atualiza para chegar na posição correta da memória
		l.s $f0, 0($t0)				# Carrega a média de uma aluno

		add.s $f8, $f8, $f0			# Soma médias += média de um aluno

        addi $s2, $s2, 32    		# Atualiza o valor da linha na matriz
		beq $s2, 160, sair 			# Checa se chegou no final da matriz
        j somamed

    sair:
		l.s $f0, const5				# Carrega o valor de 5 para f0
		div.s $f8, $f8, $f0			# Realiza o cálculo da média da sala

        mov.s $f2, $f8

        jal Aproxima                # Arredonda a média da sala

        mov.s $f8, $f9

		s.s $f8, mediasala			# Salva a média da sala na memória

    	lw $ra, 0($sp)              # Desempilha o registrador de retorno
    	addi $sp, $sp, 4
    	jr $ra

################################################################################
# Função que faz o arredondamento da média
Aproxima:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    l.s $f4, const05				# lwc1 $f4, const05			
    l.s $f9, const0                 # Zera a variável que percorrerá o loop
    l.s $f7, const025 				# lwc1 $f7, const025

    chegamedia:
        c.lt.s $f9, $f2             # Verifica se a variável do loop ultrapassou a média
        bc1f remainder              # Se ultrapassou vai para o arredondamento

        add.s $f9, $f9, $f4         # Senão incrementa 0,5 

        j chegamedia

    remainder:                      
        sub.s $f9, $f9, $f7         # Decrementa 0,25

        c.lt.s $f2, $f9             # Compara se a média arrendondará para cima ou para baixo
        bc1t parabaixo

        add.s $f9, $f9, $f7         # Arredonda a média para cima
        j guardar

    parabaixo:                  
        sub.s $f9, $f9, $f7         # Arredonda a média para baixo
    guardar:
        lw $ra, 0($sp)              # Desempilha o registrador de retorno
        addi $sp, $sp, 4
        jr $ra
################################################################################
# Função que imprime uma nova linha
Pularlinha:
	addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

	li $v0, 4            			# Imprime nova linha
    la $a0, msg
    syscall
    
    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra
################################################################################
# Função que verifica se a nota está entre 0 a 10
Verintervalo:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    l.s $f5, const0                 # Carrega 0 
    l.s $f6, const10                # Carrega 10

    conf:
        c.lt.s $f0, $f5             # Verifica se não é menor que 0
        bc1t err

        c.lt.s $f6, $f0             # Verifica se não é maior que 10
        bc1t err

        j certo

        err:
            li $v0, 4               # Caso esteja fora do intervalo
            la $a0, erro            # Imprime mensagem de erro
            syscall

            li $v0, 6               # E lê a nota denovo
            syscall

            j conf

    certo:
        lw $ra, 0($sp)              # Desempilha o registrador de retorno
        addi $sp, $sp, 4
        jr $ra

######################################################################################
# RASCUNHO para as funções (empilha e desempilha)
    #addi $sp, $sp, -4               # Empilha o registrador de retorno
    #sw $ra, 0($sp)

    
    #lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    #addi $sp, $sp, 4
    #jr $ra

