.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    beq a1, x0, exitP8

    mv t2, a0
    li t0, 0  # count
    li t1, 0  # value 

loop_start:
    beq t0, a1, loop_end  # break loop

    lw t1, 0(t2)

    
    bge t1, x0, loop_continue

    li t1, 0

loop_continue:
    sw t1, 0(t2)

    addi t2, t2, 4
    addi t0, t0, 1
    j loop_start    


loop_end:
    

    # Epilogue

    
	ret

exitP8:

    addi a1, x0, 8
    addi a0, x0, 17
    ecall