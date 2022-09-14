.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)


    mv s0, a0  # s0 : filename pointer
    mv s1, a1  # s1 : row pointer
    mv s2, a2  # s2 : col pointer

    li a2, 0
    mv a1, s0
    jal fopen
    blt a0, x0, exitP50
    mv s3, a0  # s3 : file descriptor


    # >>>>>>>>>>>>> read row in s1
    mv a1, s3
    li a3, 4
    mv a2, s1
    jal fread
    blt a0, x0, exitP51


    # >>>>>>>>>>>>> read col in s2
    mv a2, s2
    jal fread    
    blt a0, x0, exitP51

    # >>>>>>>>>>>>> calculate number
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul a0, t1, t2  # total number
    slli a0, a0, 2

    mv a3, a0   # this a3 is prepared for fread
    jal malloc
    blt a0, x0, exitP48
    mv s4, a0

    # >>>>>>>>>>>>> read matrix
    mv a1, s3
    mv a2, s4
    jal fread
    blt a0, x0, exitP51


    # >>>>>>>>>>>>> close matrix
    mv a1, s3
    jal fclose

    blt a0, x0, exitP52

    mv a0, s4

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    ret

exitP48:
    li a1, 48
    jal exit2

exitP50:
    li a1, 50
    jal exit2

exitP51:
    li a1, 51
    jal exit2

exitP52:
    li a1, 52
    jal exit2