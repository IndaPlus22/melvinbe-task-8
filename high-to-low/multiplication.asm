main:	
    # store first input in $a0
    li $v0 5
    syscall
    move $a0 $v0
    
    # store second input in $a0
    li $v0 5
    syscall
    move $a1 $v0
    
    # call faculty function
    jal multiply	
    
    # print return value
    move $a0 $v0
    li $v0 1
    syscall
	
    # exit program
    li $v0, 10
    syscall   

# takes $a0 and $a1 as arguments and returns their product to $v0
multiply:
    # int a = $a0
    # int b = $a1
    li $s1 0 # int sum = 0
    li $s0 0 # int i = 0
    
    mul_loop:
        add $s1 $s1 $a1   # sum = sum + b
        addi $s0 $s0 1    # i = i + 1
        
        bne $s0 $a0 mul_loop # if (i != a) {goto mul_loop}
        
    move $v0 $s1 # return sum
    jr $ra # jump back to function call address

# takes $a0 as argument and returns its factorial to $v0
faculty:
    move $s0 $a0 # int i = $a0
    li $s1 1 # int product = 1
    
    fac_loop:
        # product = product * i
        move $a0 $s1 # set first argument as product
        move $a1 $s0 # set second argument as i
        move $s2 $ra # save faculty function call address
        jal multiply
        move $ra $s2
        move $s1 $v0 # set product to return value
		
        addi $s0 $s0 -1 # i = i + -1
        	
        bne $s0 1 fac_loop # if (i != 1) {goto fac_loop}
		
    move $v0 $s1 # return product
    jr $ra # jump back to function call address
