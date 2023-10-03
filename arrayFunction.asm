# arrayFunction.asm
       .data 
array: .word 8, 2, 1, 6, 9, 7, 3, 5, 0, 4
newl:  .asciiz "\n"

       .text
main:
	# Print the original content of array
	# setup the parameter(s)
	la $a0, array # a0 --> addr array (checked)
	li $a1, 10 # a1 --> num element (checked)

	# call the printArray function
	jal printArray # (checked)

	# Ask the user for two indices
	li   $v0, 5         	# System call code for read_int
	syscall           
	addi $t0, $v0, 0    	# first user input in $t0
 
	li   $v0, 5         	# System call code for read_int
	syscall           
	addi $t1, $v0, 0    	# second user input in $t1

	# Call the findMin function
	# setup the parameter(s)
	sll $t0, $t0, 2 # t0 * 4 (checked)
	sll $t1, $t1, 2 # t1 * 4 (checked)

	la $t8, array # t8 --> addr of array (checked)
	add $a0, $t8, $t0 # a0 --> start addr (checked)
	add $a1, $t8, $t1 # a1 --> end addr (checked)	

	# call the function
	jal findMin # (checked)				
				
	# Print the min item
	# place the min item in $t3	for printing
	lw $t3, 0($v0)

	# Print an integer followed by a newline
	li   $v0, 1   		# system call code for print_int
    addi $a0, $t3, 0    # print $t3
    syscall       		# make system call

	li   $v0, 4   		# system call code for print_string
    la   $a0, newl    	# 
    syscall       		# print newline

	# Calculate and print the index of min item
	# Place the min index in $t3 for printing	
	la $t8, array
	sub $t3, $t4, $t8
	srl $t3, $t3, 2 #t3 --> t3 / 2 

	# Print the min index
	# Print an integer followed by a newline
	li   $v0, 1   		# system call code for print_int
    addi $a0, $t3, 0    # print $t3
    syscall       		# make system call
	
	li   $v0, 4   		# system call code for print_string
    la   $a0, newl    	# 
    syscall       		# print newline
	
	# End of main, make a syscall to "exit"
	li   $v0, 10   		# system call code for exit
	syscall	       	# terminate program
	

#######################################################################
###   Function printArray   ### 
#Input: Array Address in $a0, Number of elements in $a1
#Output: None
#Purpose: Print array elements
#Registers used: $t0, $t1, $t2, $t3
#Assumption: Array element is word size (4-byte)
printArray:
	addi $t1, $a0, 0	#$t1 is the pointer to the item
	sll  $t2, $a1, 2	#$t2 is the offset beyond the last item
	add  $t2, $a0, $t2 	#$t2 is pointing beyond the last item
l1:	
	beq  $t1, $t2, e1
	lw   $t3, 0($t1)	#$t3 is the current item
	li   $v0, 1   		# system call code for print_int
     	addi $a0, $t3, 0    	# integer to print
     	syscall       		# print it
	addi $t1, $t1, 4
	j l1			# Another iteration
e1:
	li   $v0, 4   		# system call code for print_string
     	la   $a0, newl    	# 
     	syscall       		# print newline
	jr $ra			# return from this function

#######################################################################
###   Student Function findMin   ### 
#Input: Lower Array Pointer in $a0, Higher Array Pointer in $a1
#Output: $v0 contains the address of min item 
#Purpose: Find and return the minimum item 
#              between $a0 and $a1 (inclusive)
#Registers used: $t3, $t4, $t5, $t6, $t7
#Assumption: Array element is word size (4-byte), $a0 <= $a1
findMin:
	#initializing
	add $t4, $a0, $zero #pointer to the min element 
	add $t5, $a0, $zero #pointer to the current element
	lw $t6, 0($a0) # t6 --> current min

	loop:	slt $s1, $a1, $t5
		bne $s1, $zero, exit
		lw $t7, 0($t5) # t7 -> current element
		slt $s2, $t7, $t6 # current element less than current min?
		beq $s2, $zero, incr
		add $t6, $t7, $zero # t6 -> updated min. Transferred from t7		
		add $t4, $t5, $zero # t4 -> pointer to current minimum
	incr:	addi $t5, $t5, 4 # t5 -> increment pointer 
		j loop
	exit:	
	add $t3, $t6, $zero # transfer min from t6 to t3
	la $v0, 0($t4) # v0 --> address of min item
	jr $ra			# return from this function