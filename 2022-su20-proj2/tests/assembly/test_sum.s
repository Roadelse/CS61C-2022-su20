.import ../../src/relu.s
.import ../../src/utils.s

# Set vector values for testing
.data
m0: .word 1 -2 3 -4 5 -6 7 -8 9 # MAKE CHANGES HERE


.text
# main function for testing
main:
    # Load address of m0
    la s0 m0

    # Set dimensions of m0
    li s1 3 # MAKE CHANGES HERE
    li s2 3 # MAKE CHANGES HERE

    # Print m0 before running relu
    mv a0 s0
    mv a1 s1
    mv a2 s2
    jal print_int_array

    mv a0 s0
    mv a1 s1
    mv a2 s2
    jal sum_int_array

    mv s0, a0

    # Print newline
    li a1 '\n'
    jal print_char


    mv a1, s0
    jal print_int

    # Exit
    jal exit
