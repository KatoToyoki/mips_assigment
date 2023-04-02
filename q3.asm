.macro scanf(%n)
	addi $sp, $sp, -16    # allocate space
	sw $v0, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	
	li $t0, 0
	addi $t1, $a1, 0
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

.macro print(%num)
	addi $sp, $sp, -8    # allocate space
	sw $v0, ($sp)
	sw $a0, 4($sp)
	
	la $a0, (%num)
	li $v0, 1
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	lw $a0, 4($sp)        # pop
	lw $v0, ($sp)
	addi $sp, $sp, 8
.end_macro

.data
	data: .space 20
	newLine: .asciiz "\n"

.text

j main

insertionSort:
	addi $sp, $sp, -20           # allocate space
	sw $t0, ($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	
	li $t0, 1                    # t0 = i
	
	forLoop:
		addi $t1, $t0, -1    # t1 = j
		sll $t2, $t0, 2
		add $t2, $t2, $a0
		lw $t2, ($t2)        # t2 = current
		
		j whileLoop
		
		whileDone:
		addi $t1, $t1, 1
		print($t1)
		
		sll $t1, $t1, 2
		add $t1, $t1, $a0    # t1 = array[j+1] address
		sw $t2, ($t1)
		
		addi $t0, $t0, 1
		
		bne $t0, $a1, forLoop
		j forDone
		
		whileLoop:
			sgt $t3, $t1, -1    # t3 = j>=0 bool
			sll $t4, $t1, 2
			add $t4, $t4, $a0
			lw $t4, ($t4)       # t4 = array[j]
			sgt $t4, $t4, $t2   # t4 = array[j] > current bool
			and $t3, $t3, $t4   # t3 = && bool
			bne $t3, 1, whileDone
			
			sll $t3, $t1, 2
			add $t3, $t3, $a0
			lw $t3, ($t3)       # t3 = array[j] value
			
			addi $t4, $t1, 1
			sll $t4, $t4, 2
			add $t4, $t4, $a0   # t4 = array[j+1] address
			sw $t3, ($t4)
			
			addi $t1, $t1, -1
			j whileLoop
	forDone:
	lw $t4, 16($sp)                     # pop
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, ($sp)
	addi $sp, $sp, 20
	jr $ra

main:
	la $s0, data       # s0 = array[] head address
	la $a0, ($s0)
	li $a1, 5
	
	scanf($a0)
	
	jal insertionSort
	
	li $t0, 0
	la $t1, ($a0)
	
	pLoop:
		lw $t2, ($t1)
		print($t2)
		addi $t1, $t1, 4
		addi $t0, $t0, 1
		bne $t0, $a1, pLoop
	j end
		
end:
	li $v0, 10
	syscall