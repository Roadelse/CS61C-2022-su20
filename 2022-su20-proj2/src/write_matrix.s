.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)


    mv s0, a0  	# s0 : file path
    mv s1, a1   # s1 : matrix
    mv s2, a2   # s2 : row
    mv s3, a3	# s3 : col

    li a0, 4
    jal malloc
    mv t2, a0

    li a0, 4
    jal malloc
    mv t3, a0
    sw s2, 0(t2)
    sw s3, 0(t3)


    # >>>>>>>>>>>>> open file
    mv a1, s0
    li a2, 1
    jal fopen
    blt a0, x0, exitP53
    mv s0, a0  # s0 : file desc



    # >>>>>>>>>>>>> write row and col
    li t0, 1
    mv a1, s0
    mv a2, t2
    li a3, 1
    li a4, 4
    jal fwrite

    blt a0, t0, exitP54

    mv a2, t3
    jal fwrite
    blt a0, t0, exitP54


    # >>>>>>>>>>>>> write matrix
    mv a2, s1
    mul t0, s2, s3
    mv a3, t0
    jal fwrite
    blt a0, t0, exitP54

    # >>>>>>>>>>>>> close f
    mv a1, s0
    jal fclose
    blt a0, x0, exitP55


    # >>>>>>>>>>>>> free t2 & t3
    mv a0, t2
    jal free
    mv a0, t3
    jal free


    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20


    ret

exitP53:
    li a1, 53
    jal exit2

exitP54:
    li a1, 54
    jal exit2

exitP55:
    li a1, 55
    jal exit2