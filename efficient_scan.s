##################################################
# lab3_3.s #
##################################################
.text
.globl __start
.set noreorder
__start:
#MAXIMUMS IN S1, MINIMUMS IN S2, ZEROES COUNT IN S3, EVEN IN S4, ODD IN S5, MOD3 IN S6, MOD5 IN S7

#list size in t4
	ori $t4,$zero, 500  #list size
	ori $t9, $zero, 4 #we use ori instead of li when possible to win cpu cycles =)
#set start and end point for the loop (index)	
	li $t1,0x10000004 #start-point used as index for loop
	addi $t8, $t4, -1
#initialise numbers that are used for divisions!
	ori $t7, $zero, 1
	ori $t6, $zero, 2	
	mul $t5, $t8, $t9
	lw $t3, -4($t1)
	#find endpoint
	ori $a1, $zero, 5
	add $t2, $t1, $t5
	#initialise numbers that are used for divisions!
	ori $a0, $zero, 3
	#is the first even
	first_even:
	sll $t0, $t3, 31

	
#check if 1st is zero
	beq $t3, $zero, zer_on
 
#continue even check
	beq $t0, $zero, even_on


#if first divid by 3
	div3_first: 
	div $t3, $a0
	mfhi $t5
#initialize min,max
	add $s1, $zero, $t3 #for max
	add $s2, $zero, $t3 #for min
#continue div3 check
	beq $t5, $zero, div3_on


#if first divid by 5
	div5_first: 
	div $t3, $a1
	mfhi $t5
	beq $t5, $zero, div5_on

	
	begin_loop:
	#the loop examines second upto last element
	while: beq $t1, $t2, exit
		lw $t3, 0($t1) #t3 will have the current number
		addi $t1, $t1, 4 #incr counter
		#to find maximum in $s1
		slt $t9, $s1, $t3
		#to find min in $s2
		slt $t8, $t3, $s2
		#division for even check later =)
		sll $t5, $t3, 31
		
		#branch cases for even check!
		bne $t9, $zero, set_new_max
		bne $t8, $zero, set_new_min
		
		zero_check:
		#check if zero is the remainder of previous division, zero count in #s3
		beq $zero, $t3, incr_zer
		
		even_check:
		#continue the even checking..
		beq $t5, $zero, incr_even
		
		div3_check:
		#check if div_by_3
		div $t3, $a0
		mfhi $t5
		#divide by 5 as well, to save cycles!!
		div $t3, $a1
		mfhi $t0 #mod5 in t0!! 
		beq $t5, $zero, incr_div3
		
		div5_check:
		#check if div_by_5
		beq $t0, $zero, incr_div5

		end_loop:
	j while # repeat while loop
	
	exit:
	#calculate odds
	sub $s5, $t4, $s4
	ori $v0,$zero,10 # exit
	syscall
	

	set_new_max:
	add $s1, $t3, $zero
	j zero_check #if new maximum, then it is not new minimum
	
	set_new_min:
	add $s2, $t3, $zero
	j zero_check

	zer_on:
	add $s3, $t7, $zero
	j first_even
	
	even_on:
	add $s4, $t7, $zero
	j div3_first
	
	div3_on:
	add $s6, $t7, $zero
	j div5_first

	div5_on:
	add $s7, $t7, $zero
	j begin_loop

	incr_zer:
	add $s3, $t7, $s3
	j even_check
	
	incr_even:
	add $s4, $t7, $s4
	j div3_check
	
	incr_div3:
	add $s6, $t7, $s6
	j div5_check
	
	incr_div5:
	add $s7, $t7, $s7
	j end_loop

	

.end _start
	
.data
	.org	0x10000000
	nums: .word 9,69,60,36,87,18,8,98,72,43,78,7,88,78,57,62,22,85,46,80,96,82,68,68,53,10,21,84,47,94,61,8,63,73,45,2,92,53,0,16,48,31,75,36,9,32,50,84,17,49,64,65,31,84,86,36,94,7,73,93,53,34,2,16,7,99,70,51,52,23,19,1,54,94,89,15,78,92,99,47,41,16,13,24,52,99,60,99,58,85,92,11,19,46,79,79,45,49,82,98,72,2,51,78,48,40,46,27,84,97,74,25,13,39,1,18,90,14,17,48,99,9,11,71,8,90,50,53,92,84,3,16,38,54,95,87,47,93,66,31,90,92,9,56,84,10,74,74,24,91,75,24,52,86,95,12,77,97,66,21,33,69,37,72,76,32,11,23,25,29,54,68,21,63,24,5,74,50,32,50,93,7,74,97,93,21,10,22,18,76,43,4,97,33,76,73,17,39,96,43,68,3,63,89,18,39,47,92,89,31,43,82,38,69,79,83,91,41,58,61,17,53,65,67,86,93,40,4,32,89,99,0,92,62,42,10,1,41,55,42,72,50,24,10,71,55,45,14,49,3,76,18,57,93,85,95,39,26,99,71,67,98,24,59,12,18,21,65,59,28,7,83,78,83,45,50,91,90,64,40,46,92,58,55,38,44,50,77,22,50,0,41,0,76,0,65,94,73,30,5,2,90,88,80,25,33,82,16,76,99,8,22,43,67,77,81,63,27,10,37,29,63,78,82,39,30,99,86,3,29,91,5,71,32,38,97,17,72,65,93,71,74,15,15,41,44,48,56,72,59,93,53,74,23,87,13,53,86,51,8,68,43,14,39,27,4,88,44,76,54,38,48,28,5,15,21,50,63,77,74,74,22,27,48,45,15,14,50,1,65,58,69,60,72,61,87,76,49,32,53,3,22,53,83,27,68,4,77,31,81,51,58,3,31,6,0,46,72,50,99,38,9,21,50,33,34,38,62,83,22,15,39,44,20,22,23,88,27,1,71,60,4,81,64,35,40,16,33,12,67,85,2,76,6,53,61,40,43,23,75,65,90,66,61,10,41,84,50,20,37,74,80,42,55,96,77,95,13,11,8,80,96,10,8,54,15,69,46,58,45,73,75,35,40,36,46,33,73,48,53
#################################################
	#end of program
#################################################