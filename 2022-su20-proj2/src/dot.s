.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Prologue
    li t0, 1
    blt a2, t0, exitP5
    blt a3, t0, exitP6
    blt a4, t0, exitP6

    li t0, 0  # t0 : count

    li t3, 0  # results

    mv t5, a0
    mv t6, a1


loop_start:
    lw t1, 0(t5)  # t1 : values in v0
    lw t2, 0(t6)  # t2 : values in v1

    mul t4, t1, t2 # t4 : temp value
    add t3, t3, t4 

    addi t0, t0, 1
    beq t0, a2, loop_end

    li t4, 4
    mul t1, a3, t4  # t1 : v0, stride bytes
    mul t2, a4, t4  # t2 : v1, stride bytes

    add t5, t5, t1
    add t6, t6, t2

    j loop_start


loop_end:
    mv a0, t3

    # Epilogue
    lw ra, 0(sp)
    addi, sp, sp, 4
    
    ret

exitP5:
    li a0, 17
    li a1, 5
    ecall

exitP6:
    li a0, 17
    li a1, 6
    ecall
