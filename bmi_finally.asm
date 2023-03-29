.data
	under: .asciiz "underweight\n"
	over: .asciiz "overweight\n"
	newLine: .asciiz "\n"

.text
main:
	j scanf
	
scanf:
	# store height
	li $v0, 5
	syscall
	move $s0, $v0
	
	beq $s0, -1, end
	
	# store weight
	li $v0, 5
	syscall
	move $s1,$v0
	
	#set the parameters
	add $a0, $s0, $0
	add $a1, $s1, $0
	
	#go to the function
	jal bmi
	
	#get the return value
	add $s0, $v0, $0
	
	#print it out
	jal print
	
	#kurikaeshi
	j scanf
	
bmi:
	add $s0, $a0, $0
	add $s1, $a1, $0
	mul $s1, $s1, 10000
	mul $s0, $s0, $s0
	div $v0, $s1, $s0
	
	jr $ra

print:
	add $s0, $v0, $0
	blt $s0, 18, isunder
	bgt $s0, 24, isover
	j neither
	
isunder:
	la $a0, under
	li $v0, 4
	syscall
	
	jr $ra

isover:
	la $a0, over
	li $v0, 4
	syscall
	jr $ra
	
neither:
	#print the number
	move $a0, $s0
	li $v0, 1
	syscall
	
	#print the '\n'
	la $a0, newLine
	li $v0, 4
	syscall
	
	jr $ra
		
end:
	li $v0, 10
	syscall
