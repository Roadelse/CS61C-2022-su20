.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, exitP2
    blt a2, t0, exitP2
    blt a4, t0, exitP3
    blt a5, t0, exitP3
    bne a2, a4, exitP4

    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)


    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6


    li t0, 0  # t0 : loop row of md
    li t1, 0  # t1 : loop col of md 

    mv t2, s0  # t2 : point to m0
    mv t3, s1  # t3 : point to m1
    mv t4, s6  # t4 : point to md

outer_loop_start:
    # li a1 'o'
    # jal print_char
    mv t3, s3
    li t1, 0
inner_loop_start:
    # li a1 'i'
    # jal print_char

    mv a2, s2
    li a3, 1
    mv a4, a5
    mv a0, t2
    mv a1, t3
    
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    
    jal ra dot
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    addi sp, sp, 20


    sw a0, 0(t4)
    addi t4, t4, 4


inner_loop_end:
    addi t3, t3, 4
    addi t1, t1, 1

    blt t1, s5, inner_loop_start

outer_loop_end:
    li t3, 4
    mul t3, t3, s2
    add t2, t2, t3
    addi t0, t0, 1

    blt t0, s1, outer_loop_start

    # li a1 'b'
    # jal print_char
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    ret

exitP2:
    li a1, 2
    jal ra exit2

exitP3:
    li a1, 3
    jal ra exit2

exitP4:
    li a1, 4
    jal ra exit2