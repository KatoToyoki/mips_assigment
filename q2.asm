.macro printStr(%str)
	addi $sp, $sp, -8 # allocate space ( 2 for a0, v0)
	sw $a0, 0($sp)    # save original value
	sw $v0, 4($sp)	  # save original value
	li $v0, 4         # for syscall
	la $a0, %str
	syscall
	lw $v0, 4($sp)    # take original value out
	lw $a0, 0($sp)    # take original value out
	addi $sp, $sp,8   # pop
.end_macro

.macro printInt(%x)
	addi $sp, $sp, -8 # allocate space ( 2 for a0, v0)
	sw $a0, 0($sp)    # save original value
	sw $v0, 4($sp)    # save original value

	move $a0,%x       # for syscall
	li $v0,1
	syscall           # print int
	printline()       # print \n
	
	lw $v0, 4($sp)    # take original value out
	lw $a0, 0($sp)    # take original value out
	addi $sp, $sp,8   # pop
.end_macro

.macro printline()
	printStr(newLine)
.end_macro

.macro readInt(%x)   
	addi $sp, $sp, -4 # allocate space ( 1 for v0)
	sw $v0, 0($sp)    # save original value

	li $v0,5          # for syscall
	syscall
	move %x,$v0       # %x = v0 (get input

	lw $v0, 0($sp)    # take original value out
	addi $sp, $sp,4   # pop space
.end_macro

.macro init(%array,%size)
	addi $sp, $sp, -16       # allocate space
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)

	li $t0,0                 # counter to check if it's 800 or not
	li $t1,%size             # 800

	la $t2,%array            # t2 the base of the array

	loop:
		beq $t0,$t1,out  # counter = 800, end it
		addi $t0,$t0,4   # equals to i+=1
		add $t3,$t2,$t0  # t3 current moving address
		sw $zero,($t3)   # save 0 in current position (t3)

		j loop
	out:

	lw $t3, 12($sp)          # take original value out
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp,16         # pop
.end_macro


.data
	data: .space 805        # give more space for '\0'
	newLine: .asciiz "\n"   

.text

j main

fib:
	fibStart:
		addi $sp, $sp, -20  # allocate space
		sw $ra, 0($sp)      # store return address
		sw $a0, 4($sp)      # current index (1~n)
		sw $t0, 8($sp)      # dp [1~n]
		sw $t1, 12($sp)
		sw $t2, 16($sp)     

		add $t2,$a1,$zero   # t2 = dp[0]
		sll $t0,$a0,2       # t0 = i (i*4 to get the address)
		add $t2,$t2,$t0     # t2 = dp[1~n] address

		lw $t0,($t2)        # t0 = dp[1~n] value

		bne $t0,$zero,Existed # if t0!=0 (dp[1~n] has value
		
		# if t0 is 0

		li $t0,1            # t0 =1
		beq $a0,$t0,OneTwo  # if (1~n)=1
		li $t0,2            # t0 =2
		beq $a0,$t0,OneTwo  # if (1~n)=2

		j else

	Existed:
		lw $v0,($t2)        # v0 is the value
		printInt($v0)       # print this out 
		j fibEnd            # return

	OneTwo:
		li $v0,1
		sw $v0,($t2)        # first two are 1
		j fibEnd            # return

	else:
		addi $a0,$a0,-1
		jal fib
		move $t0,$v0
		addi $a0,$a0,1

		addi $a0,$a0,-2
		jal fib
		move $t1,$v0
		addi $a0,$a0,2

	 	add $v0,$t0,$t1

		sw $v0,($t2)

		li $t0,3
		div $v0,$t0
		mfhi $t0

		beq $t0,$zero,mod3
		j fibEnd            # return

	mod3:
		printInt($v0)
		j fibEnd

	fibEnd:
		lw $t2, 16($sp)
		lw $t1, 12($sp)
		lw $t0, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp,20

		jr $ra

main:
	init(data,800)
	readInt($a0)     # a0 = int n 
	la $a1,data      # a1 = dp[0]
	jal fib
	move $s0,$v0
	printInt($s0)
	j end
	
end:
	li $v0,10
	syscall
