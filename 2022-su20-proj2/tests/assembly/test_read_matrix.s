.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
# file_path: .asciiz "inputs/test_read_matrix/test_input.bin"
file_path: .asciiz "tests/inputs/simple0/bin/m0.bin"
# file_path: .asciiz "test_input.bin"

.text
main:
    # Read matrix into memory
    la s0, file_path

    li a1, 4
    jal sbrk
    mv s1, a0

    li a1, 4
    jal sbrk
    mv s2, a0

    mv a1, s1
    mv a2, s2
    mv a0, s0
    jal read_matrix
    # mv s0, a0
    # mv s1, a1
    # mv s2, a2



    # Print out elements of matrix
    lw a1, 0(s1)
    lw a2, 0(s2)
    jal print_int_array


    # Terminate the program
    jal exit