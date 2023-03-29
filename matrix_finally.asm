.data
	range: .space 108
	newLine: .asciiz "\n"
	space: .asciiz " "
	test: .asciiz "fuck\n"
	
.text
main:
	# the base of array head
	la $a0, range
	
	#counter i<9
	li $t6, 9
	
	#to get input
	jal scanf
	
	#============================================================================
	
	#============================================================================
	
	la $a0, range # a0 A address
	la $a1, 36($a0) # a1 A1 address
	la $a2, 72($a0) # a2 A2 address
	li $a3, 3     # a3,size value
	
	jal transposeA1
	
	jal transposeA2
	
	la $a0, ($a1)
	jal printMatrix
	
	la $a0, ($a2)
	jal printMatrix
	
	
	
	
	#all done
	j end

scanf:
	#intialization
	sw $0, ($a0)
	
	#input int
	li $v0, 5
	syscall
	
	#save to memory
	sw $v0, ($a0)
	
	#to next position
	addi $a0, $a0, 4
	
	#if condition
	addi $t6, $t6, -1
	bne $t6, $0, scanf
	
	#all done, back to main
	jr $ra
	
transposeA1:
	la $t0, ($a0) # A moving address
	la $t1, ($a1) # A1 moving address
	li $t7, 0     # i value
	li $t8, 0     # j value
	j Loopi
	
	backTransposeA1:
	jr $ra
	
Loopi:
	j Loopj
	jDone:
	
	
	addi $t7, $t7, 1
	li $t8, 0
	bne $t7, 3, Loopi
	beq $t7, 3, backTransposeA1
	
Loopj:
	
	mul $t9, $t8, 3   #t9 j*3+1 T[j][i]
	add $t9, $t9, $t7 
	mul $t9, $t9, 4
	add $t1, $t1, $t9 #A1 moving address
	
	mul $t9, $t7, 3   #t9 j*3+1
	add $t9, $t9, $t8
	mul $t9, $t9, 4
	add $t0, $t0, $t9 #A moving
	lw $t3, ($t0)     #t4 A value
	
	sw $t3, ($t1)
	addi $t8, $t8, 1
	la $t0, ($a0)
	la $t1, ($a1)
	
	bne $t8, 3, Loopj
	beq $t8, 3, jDone

transposeA2:
	la $t0, ($a0) # A moving address
	la $t2, ($a2) # A2 moving address
	li $t7, 1     # i value
	
	mul $t1, $a3, $a3
	mul $t1, $t1, 4
	add $t1, $t1, $a0 #t1 end condition
	
	j A2Loop
	
	backA2:
	jr $ra
	
A2Loop:
	lw $t9, ($t0)
	sw $t9, ($t2)
	slt $t9, $t7, $a3
	beq $t9, 1, ifStage
	#else
	addi $t2, $t2, -20 #3*2-1=5 5*4=20
	li $t7, 1
	
	backA2Loop:
	
	addi $t0, $t0, 4
	bne $t0, $t1, A2Loop
	beq $t0, $t1, backA2

ifStage:
	addi $t2, $t2, 12 #3*4
	addi $t7, $t7, 1
	j backA2Loop

printMatrix:
	li $t7, 0     # i value
	li $t8, 0     # j value
	j printI
	printIdone:
	jr $ra
	
printI:
	
	j printJ
	
	printJDone:
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	
	addi $t7, $t7, 1
	li $t8, 0
	bne $t7, 3, printI
	beq $t7, 3, printIdone
	
printJ:
	la $t0, ($a1)
	lw $a0, ($t0)
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	addi $t8, $t8, 1
	addi $a1, $a1, 4
	bne $t8, 3, printJ
	beq $t8, 3, printJDone

end:
	li $v0, 10
	syscall
