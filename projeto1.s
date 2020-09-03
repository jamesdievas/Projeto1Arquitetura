.data
    RAs:    .asciiz "\nInsira o RA do aluno "
    pontos: .asciiz ": "
    menu:   .asciiz "\n0 - Encerrar programa.\n1 - Cadastrar notas.\n2 - Excluir notas.\n3 - Exibir notas.\n4 - média aritmética da turma.\n5 - Aprovados.\n-> "
    space: .asciiz " "
    vetorRA:  .word 0, 0, 0, 0, 0
    sizevetRA: .byte 20
    matriz: .float 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    sizemat: .word 160
    consti: .byte 32
    constj: .byte 4
.text
.globl main
main:
    
    jal RegRA                       # Coletar RAs

    jal Exibir

    jal sort                        # Ordena o vetor de RA's

    jal Exibir

    loopmenu:
        li $v0, 4
        la $a0, menu
        syscall

        li $v0, 5
        syscall

        beq	$v0, 1, cadastro	    # Cadastrar notas
        beq $v0, 2, delnota         # Excluir nota
        beq	$v0, 3, Exibirmed       # Exibir notas
        beq $v0, 4, media           # Exibir media da sala
        beq $v0, 5, aprovados       # Exibir aprovados
        beq $v0, 0, fim             # Encerrar programa

    cadastro:
        jal Cadastrar
        #jal Calcular #### Calcular precisa considerar medias de 0,5 em 0,5
        j loopmenu

    delnota:
        jal Excluir
        #jal Calcular #### Calcular precisa considerar medias de 0,5 em 0,5
        j loopmenu

    nota:
        jal Exibnotas
        j loopmenu

    media:
        # função p/ calcular medias da sala
        jal Exibirmed
        j loopmenu

    aprovados:
        # função que faz a comparação de quem passou
        jal ExibAprov
        j loopmenu
    
    fim:
        li $v0, 10                  # Encerra o programa
        syscall

#----------------------------------------------------------------------

RegRA:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    move $t0, $zero                 # Inicia o contador com 0
    lerRA:
        li $v0, 4                   # Imprime a mensagem de coleta de dado
        la $a0, RAs
        syscall


        addi $t1, $t0, 1
        li $v0, 1
        move $a0, $t1
        syscall

        li $v0, 4               
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

Exibir:	
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    move $t0, $zero

    exibir:
	li $v0, 4
	la $a0, space				    # Exibe um espaço para separação dos números
	syscall
	
	li $v0, 1					    # Comando para exibir o valor
	lw $a0, vetorRA($t0)		    # Carrega o valor para exibir
	syscall
	
	addi $t0, $t0, 4
	bne $t0, 20, exibir		        # Verifica se chegou ao final do array
	
	lw $ra, 0($sp)				    # Retira da pilha o endereço que foi chamada a main
	addi $sp, $sp, 4
	
	jr $ra

#--------------------------------------------------------------------

Cadastrar:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    move $s0, $zero
    move $s1, $zero

    
    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------------------------

Excluir:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    
    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------------------------

Exibnotas:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    
    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------------------------

Exibirmed:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    
    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra

#-------------------------------------------------------------------------------------

ExibAprov:
    addi $sp, $sp, -4               # Empilha o registrador de retorno
    sw $ra, 0($sp)

    
    lw $ra, 0($sp)                  # Desempilha o registrador de retorno
    addi $sp, $sp, 4
    jr $ra
#-------------------------------------------------------------------------------------
swap:
	addi $t4, $s1, 4			    # Carrega j+1
	lw $t1, vetorRA($s1)			# Carrega array[j]
	lw $t2, vetorRA($t4)			# Carrega array[j+1]

	sw $t2, vetorRA($s1)			# Array[j] = array[j+1]
	sw $t1, vetorRA($t4)			# Array[j+1] = array[j]
	jr $ra						    # Retorna para o loop
	
sort:
	addi $sp, $sp, -4			    # Armazena na pilha o endereço de retorno
	sw $ra, 0($sp)
	
	lb $s0, sizevetRA				# i = size
	
loop1:
	blt $s0, 1, exit1			    # Verifica se i < 1
	move $s1, $zero				    # j = 0
	
loop2:
	slt $t0, $s1, $s0			    # Verifica se j < i
	beq $t0, $zero, exit2		

	addi $t5, $s1, 4
	
	lw $t3, vetorRA($s1)			# $t3 recebe array[j]
	lw $t4, vetorRA($t5)			# $t4 recebe array[j+1]

	blt $t3, $t4, continua		    # Se array[j+1] > array[j] está ordenado e continua no loop

	jal swap

continua:	
	addi $s1, $s1, 4			    # Incrementa uma posição em j (4 bytes = 1 word)
	j loop2
	
exit2:
	addi $s0, $s0, -4			    # Decrementa uma posição do i, (4 bytes = 1 word)
	j loop1
	
exit1:
	lw $ra, 0($sp)				    # Retira da pilha o endereço de retorno
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

