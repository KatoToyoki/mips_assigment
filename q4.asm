.macro scanf(%n)
	addi $sp, $sp, -16    # allocate space
	sw $v0, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	
	li $t0, 0
	li $t1, 9
	la $t2, (%n)
	
	loop:
		li $v0, 5
		syscall
		
		sw $v0, ($t2)
		addi $t2, $t2, 4
		addi $t0, $t0, 1
		bne $t0, $t1, loop
		j out
			
	out:
	lw $t2, 12($sp)      # pop
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $v0, ($sp)
	
	addi $sp, $sp, 16
.end_macro

.macro printMatrix(%num)
	addi $sp, $sp, -24    # allocate space
	sw $v0, ($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	
	li $t0, 0        # t0 = i
	li $t1, 0        # t1 = j
	la $t2, (%num)   # cal stuff
	
	printI:
		printJ:
			lw $t3, ($t2)
			add $a0, $t3, $0
			li $v0, 1
			syscall
	
			la $a0, space
			li $v0, 4
			syscall
			
			addi $t2, $t2, 4
			addi $t1, $t1, 1
			bne $t1, $a2, printJ
			j printJDone
			
		printJDone:
			la $a0, newLine
			li $v0, 4
			syscall
			addi $t0, $t0, 1
			li $t1, 0
			bne $t0, $a2, printI
			j printLoopDone
			
	printLoopDone:
	lw $t3, 20($sp)
	lw $t2, 16($sp)
	lw $t1, 12($sp)
	lw $t0, 8($sp)
	lw $a0, 4($sp)        
	lw $v0, ($sp)
	addi $sp, $sp, 20
.end_macro

.data 
	data: .space 108
	newLine: .asciiz "\n"
	space: .asciiz " "

.text

j main

transposeA1:
	addi $sp, $sp, 16
	sw $t0, ($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	
	li $t0, 0         # i
	li $t1, 0         # j
	li $t2, 0     # A[?][?]
	li $t3, 0     # T[?][?]
	
	iLoop:
		jLoop:
			mul $t3, $t1, 3
			add $t3, $t3, $t0
			sll $t3, $t3, 2
			add $t3, $t3, $a1  # t3 = T[j][i] address
			
			mul $t2, $t0, 3
			add $t2, $t2, $t1
			sll $t2, $t2, 2
			add $t2, $t2, $a0  
			lw $t2, ($t2)      # t2 = A[i][j] value
			
			sw $t2, ($t3)
			
			addi $t1, $t1, 1
			bne $t1, $a2, jLoop
			j jDone
		
		jDone:
			addi $t0, $t0, 1
			li $t1, 0
			bne $t0, $a2, iLoop
			j iDone
	
	iDone:
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, ($sp)
	jr $ra
	
transposeA2:
	addi $sp, $sp, 20
	sw $t0, ($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	
	la $t0, ($a0)  # t0 = A[?][?]  moving address
	la $t1, ($a1)  # t1 = A2[?][?] moving address
	li $t2, 1      # i
	li $t3, 0      # end condition
	li $t4, 0      # cal stuff
	
	mul $t3, $a2 $a2
	sll $t3, $t3, 2
	add $t3, $t3, $t0  # t3 = end condition
	
	forLoop:
		lw $t4, ($t0)  # t4 = A[][] value
		sw $t4, ($t1)
		
		slt $t4, $t2, $a2
		
		beq $t4, 1, ifA2
		bne $t4, 1, elseA2
		
		conditionEnd:
		addi $t0, $t0, 4
		bne $t0, $t3, forLoop
		j forDone
		
		ifA2:
			addi $t1, $t1, 12  # 3*4
			addi $t2, $t2, 1
			j conditionEnd
		
		elseA2:
			addi $t1, $t1, -20 # ((3*2-1)*4=20)
			li $t2, 1
			j conditionEnd
		
	forDone:
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, ($sp)
	jr $ra
			
main:
	la $s0, data     # A[0][0]
	la $s1, 36($s0)  # A1[0][0]
	la $s2, 72($s0)  # A2[0][0]
	
	la $a0, ($s0)
	scanf($a0)
	
	la $a1, ($s1)
	li $a2, 3
	jal transposeA1
	
	la $a1, ($s2)
	jal transposeA2
	
	la $a1, ($s1)
	printMatrix($a1)
	
	la $a1, ($s2)
	printMatrix($a1)
	
	j end

end:
	li $v0, 10
	syscall