### Data Declaration Section ###

.data

primes:		.space  1000            # reserves a block of 1000 bytes in application memory
err_msg:	.asciiz "Invalid input! Expected integer n, where 1 < n < 1001.\n"

### Executable Code Section ###

.text

main:
    # get input
    li      $v0 5                   # set system call code to "read integer"
    syscall                         # read integer from standard input stream to $v0
    
    # validate input
    li 	    $t0 1001                 # $t0 = 1001
    slt	    $t1 $v0 $t0		      # $t1 = input < 1001
    beq     $t1 $zero invalid_input # if !(input < 1001), jump to invalid_input
    nop
    li	    $t0 1                    # $t0 = 1
    slt     $t1 $t0 $v0	      # $t1 = 1 < input
    beq     $t1 $zero invalid_input # if !(1 < input), jump to invalid_input
    nop
    
    move $s0 $v0 # save valid input in $s0
    
    # initialise primes array
    la	    $t1 primes              # $t1 = address of the first element in the array
    li 	    $t2 2
    li 	    $t3 999
    
    init_loop:
        sb	 $t2 ($t1)             # primes[i] = 1
        addi    $t1 $t1 4             # increment pointer by size of an integer
        addi    $t2 $t2 1             # increment counter
        bne	 $t2 $t3 init_loop     # loop if counter != 999
    
    li	$t2 2 # int i = 2
    sieve_loop:
        la $t1 primes # $t1 = address of the first element in the array
        
        mul $t3 $t2 4 	# int 4i = 4 * i
        add $t1 $t1 $t3	 # $t1 += 4i
        addi $t1 $t1 -8 # $t1 += -8 (-2 * 4)
	
        move $t4 $t2 # int j = i
        
        # remove every number divisible by i
        remove_loop:
            add $t1 $t1 $t3 # $t1 += 4i (increment pointer in steps of 4i)
            sb $0 ($t1) # set value at pointer to 0
            add $t4 $t4 $t2 # j = j + i (increment j in steps of i)
            blt $t4 $s0 remove_loop # loop while j < input value
        
        addi $t2 $t2 1	# i++
        
        bne $t2 $s0 sieve_loop # loop while i < input value

    la $t1 primes # $t1 = address of the first element in the array
    li $t2 1 # int i = 1	
    
    # print every prime
    print_loop:
        lw $a0 ($t1) # int p = primes[i]

        beq $0 $a0 skip # do not print if number has been removed (set to 0)
        
        # print integer p from $a0	
        li $v0 1
        syscall
        
        # print the 'space' char (32)
        li $a0 32 
        li $v0 11
        syscall
        
        skip:
        
        addi $t1 $t1 4 # pointer += 4
        addi $t2 $t2 1 # i++
        
        bne $t2 $s0 print_loop # loop through entire array
    
    # exit program
    j exit_program

invalid_input:
    # print error message
    li      $v0 4                  # set system call code "print string"
    la      $a0 err_msg            # load address of string err_msg into the system call argument registry
    syscall                         # print the message to standard output stream

exit_program:
    # exit program
    li $v0 10                      # set system call code to "terminate program"
    syscall                         # exit program