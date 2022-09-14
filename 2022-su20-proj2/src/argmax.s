.globl argmax


.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)

    mv s0, a0
    mv s1, a1

    beq s1, x0, exitP7


    # mv s0, a1 # s0 : size
    li t0, 0 # t0 : count
    mv t1, s0 # t1 : pointer

    li t3, 0 # save max values
    li t4, 0 # save max value index

loop_start:
    lw t2, 0(t1)

    bge t3, t2, loop_continue
    mv t3, t2
    mv t4, t0

loop_continue:
    addi t0, t0, 1
    addi t1, t1, 4
    beq t0, s1, loop_end
    j loop_start


loop_end:
    mv a0, t4

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret


exitP7:
    addi a1, x0, 7
    addi a0, x0, 17
    ecall