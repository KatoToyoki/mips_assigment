.data
	range: .space 20
	newLine: .asciiz "\n"
	
.text
	
main:
	# the base of array head
	la $s0, range
	
	#counter i<5
	li $t0, 5
	
	#the moving position
	la $t9, range
	
	#to get input
	jal scanf
	la $s0, range
	
	
	#reset to the head
	la $t0, range # address for a[i]
	la $t1, range # address for a[j]
	
	jal insertion

	loopOver:
	li $t0, 5
	jal printResult

	#all done
	j end
	
scanf:
	#intialization
	sw $0, ($s0)
	
	#input int
	li $v0, 5
	syscall
	
	#save to memory
	sw $v0, ($s0)
	
	#to next position
	addi $s0, $s0, 4
	
	#if condition
	addi $t0, $t0, -1
	bne $t0, $0, scanf
	
	#all done, back to main
	jr $ra
	
insertion:
	li $s1, 1
	li $s2, 5
	jal forLoop
	endFor:
	jr $ra
	
	
forLoop:
	add $t2, $s1, $0   # t2 = i (value)
	sll $t3, $t2, 2    # get the num of will add position
	add $t0, $s0, $t3  # t0 = a[i] address
	lw $t3, ($t0)      # t3 = current = a[i]
	add $t4, $t2, -1   # t4 = j (value)
	jal whileLoop
	
	backFor:
	beq $s1, $s2, loopOver
	
	addi $t7, $t4, 1  # t7 = j+1 value
	sll $t6, $t7, 2
	add $t6, $t6, $s0 # t6 = a[j+1] address
	lw $t8, ($t6)     # t8 = a[j+1] value
	
	add $a0, $t7, $0
	li $v0, 1
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall
		
	sw $t3,($t6)
	
	addi $s1, $s1, 1
	bne $s1, $s2, forLoop
	jr $ra
	
whileLoop:
	sgt $s3, $t4, -1
	beq $s3,0,backFor
	
	sll $t5, $t4, 2    # get the num of will add position
	add $t1, $s0, $t5  # t1 = a[j] address
	lw $t5, ($t1)      # t3 = current = a[i]
	
	sgt $s4, $t5, $t3
	and $s5, $s3, $s4
	beq $s5, 1, insideLoop
	
	jr $ra
	
insideLoop:
	addi $t7, $t4, 1  # t7 = j+1 value
	sll $t6, $t7, 2
	add $t6, $t6, $s0 # t6 = a[j+1] address
	lw $t8, ($t6)     # t8 = a[j+1] value
	
	sw $t5, ($t6)
	addi $t4, $t4, -1
	
	addi $t7, $t4, 1  # t7 = j+1 value
	sll $t6, $t7, 2
	add $t6, $t6, $s0 # t6 = a[j+1] address
	lw $t8, ($t6)     # t8 = a[j+1] value
	
	j whileLoop
	
printResult:
	
	lw $a0, ($s0)
	li $v0, 1
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	addi $s0, $s0, 4
	addi $t0, $t0, -1
	bne $t0, 0 printResult
	jr $ra
	

end:
	li $v0, 10
	syscall
