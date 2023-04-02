.macro scanf(%n)
	addi $sp, $sp, -4  # allocate space
	sw $v0, ($sp)
	
	li $v0, 5          # for syscall
	syscall
	move %n, $v0
	
	lw $v0, ($sp)      # pop
	addi $sp, $sp, 4
.end_macro

.macro print(%bmi)
	addi $sp, $sp, -8    # allocate space
	sw $t0, ($sp)        # for bool
	sw $v0, 4($sp)       # for syscall
	sw $a0, 8($sp)       # for syscall
	
	slti $t0, %bmi, 18
	beq $t0, 1, u
	
	sgtu $t0, %bmi, 24
	beq $t0, 1, o
	
	beq $t0, 0, else
		
	u:	
		li $v0, 4
		la $a0, under
		syscall
		j endPrint
		
	o:
		li $v0, 4
		la $a0, over
		syscall
		j endPrint
		
	else:
		li $v0, 1
		la $a0, (%bmi)
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
	
	endPrint:
	lw $a0, 8($sp)         # pop
	lw $v0, 4($sp)
	lw $t0, ($sp)
	addi $sp, $sp, 8	
.end_macro

.data 
	under: .asciiz "underweight\n"
	over: .asciiz "overweight\n"
	newLine: .asciiz "\n"
.text

j main

bmi:
	addi $sp, $sp, -8     # allocate space
	sw $t0, ($sp)
	sw $t1, 4($sp)
	
	mul $t0, $a1, 10000
	mul $t1, $a0, $a0
	div $v0, $t0, $t1
	
	lw $t1, 4($sp)        # pop
	lw $t0, ($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
main:
	scanf($s0)
	move $a0, $s0     # s0 = height
	beq $s0, -1, end
	
	scanf($s1)
	move $a1, $s1     # s1 = weight
	
	jal bmi 
	move $s2, $v0     # s2 = bmi
	
	print($s2)
	
	j main
		
end:
	li $v0,10
	syscall