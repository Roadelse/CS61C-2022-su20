.globl classify

.data
str1 : .asciiz "cp1"
str2 : .asciiz "cp2"
str3 : .asciiz "cp3"
str4 : .asciiz "cp4"
cksi : .string "checksum for mi"
sumH : .string "sum is "
.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t1, 5
    bne a0, t1, exitP49
    lw s0, 4(a1)    # s0 : m0 path
    lw s1, 8(a1)    # s1 : m1 path
    lw s2, 12(a1)    # s2 : input path
    lw s3, 16(a1)   # s3 : outpath
    mv s9, a2


    # >>> check path
    # li a1, '\n'
    # jal print_char
    # mv a1, s3
    # jal print_str
    # li a1, '\n'
    # jal print_char


	# =====================================
    # LOAD MATRICES
    # =====================================
    # >>> Load pretrained m0
    li a0, 4
    jal malloc
    mv t1, a0  # holder row
    
    li a0, 4
    jal malloc
    mv t2, a0  # holder col
    
    mv a0, s0
    mv a1, t1
    mv a2, t2

    jal swts
    jal read_matrix
    jal lwts
    mv s4, a0     # s4 : pointer for m0

    # >>> check shape of m0    
    # li a1, 'm'
    # jal print_char
    # li a1, '0'
    # jal print_char
    # li a1, ':'
    # jal print_char
    # lw a1, 0(t1)
    # jal print_int
    # li a1, 'x'
    # jal print_char
    # lw a1, 0(t2)
    # jal print_int
    # li a1, '\n'
    # jal print_char


    # >>> Load pretrained m1
    li a0, 4
    jal malloc
    mv t3, a0  # holder row
    
    li a0, 4
    jal malloc
    mv t4, a0  # holder col
    
    mv a0, s1
    mv a1, t3
    mv a2, t4

    jal swts
    jal read_matrix
    jal lwts

    mv s5, a0     # s5 : pointer for m1


    # >>> check shape of m1
    # li a1, 'm'
    # jal print_char
    # li a1, '1'
    # jal print_char
    # li a1, ':'
    # jal print_char
    # lw a1, 0(t3)
    # jal print_int
    # li a1, 'x'
    # jal print_char
    # lw a1, 0(t4)
    # jal print_int
    # li a1, '\n'
    # jal print_char

    # >>> Load input matrix
    li a0, 4
    jal malloc
    mv t5, a0  # holder row
    
    li a0, 4
    jal malloc
    mv t6, a0  # holder col
    
    mv a0, s2
    mv a1, t5
    mv a2, t6


    jal swts
    jal read_matrix
    jal lwts

    mv s6, a0     # s6 : pointer for mi

    # >>> check shape of mi
    # li a1, 'm'
    # jal print_char
    # li a1, 'i'
    # jal print_char
    # li a1, ':'
    # jal print_char
    # lw a1, 0(t5)
    # jal print_int
    # li a1, 'x'
    # jal print_char
    # lw a1, 0(t6)
    # jal print_int
    # li a1, '\n'
    # jal print_char


    # >>> check sum
    # la a1, cksi
    # jal print_str
    # li a1, '\n'
    # jal print_char

    # jal swts
    # mv a0, s6
    # lw a1, 0(t5)
    # lw a2, 0(t6)
    # jal sum_int_array
    # mv t0, a0
    # jal lwts

    # la a1, sumH
    # jal print_str
    # mv a1, t0
    # jal print_int
    # li a1, '\n'
    # jal print_char


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # >>>>>>>>>>>>>>>>>>>>>>> 1. m0 * input
    lw t0, 0(t1)
    lw a1, 0(t6)
    mul a1, t0, a1  # a1 : the number of values in matrix m0 * input
    slli a0, a1, 2  # a1 : bytes
    jal malloc
    mv s7, a0 # s7 : pointer to matrix m0*input

    mv a0, s4
    lw a1, 0(t1)
    lw a2, 0(t2)
    mv a3, s6
    lw a4, 0(t5)
    lw a5, 0(t6)
    mv a6, s7

    jal swts
    jal matmul
    jal lwts

    # >>> 2. relu(...)
    mv a0, s7
    lw a1, 0(t1)
    lw t0, 0(t6)
    mul a1, a1, t0

    jal swts
    jal relu
    jal lwts


    # >>> 3. m1 * relu(...)
    lw t0, 0(t3)
    lw a1, 0(t6)
    mul a1, t0, a1  # a1 : the number of values in matrix m0 * input
    slli a0, a1, 2  # a1 : bytes
    jal malloc
    mv s8, a0 # s8 : pointer to matrix m1 * relu(...)

    mv a0, s5
    lw a1, 0(t3)
    lw a2, 0(t4)
    mv a3, s7
    lw a4, 0(t1)
    lw a5, 0(t6)
    mv a6, s8

    jal swts
    jal matmul
    jal lwts


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # >>> Write output matrix
    # mv a1, s3
    # jal print_str
    # li a1, '\n'
    # jal print_char


    mv a0, s3
    mv a1, s8
    lw a2, 0(t3)
    lw a3, 0(t6)  

    jal swts
    jal write_matrix
    jal lwts



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # >>> Call argmax
    lw a1, 0(t3)
    lw t0, 0(t6)
    mul a1, a1, t0
    mv a0, s8

    jal swts
    jal argmax
    jal lwts



    bne s9, x0, exitP # if command-a2 is not 0, just exit
    # >>> Print classification
    mv a1, a0
    jal print_int


    # >>> Print newline afterwards for clarity
    li a1, '\n'
    jal print_char


    # >>> print mat-s8, i.e., result array
    # jal swts
    # mv a0, s8
    # lw a1, 0(t3)
    # lw a2, 0(t6)
    # jal print_int_array
    # jal lwts

exitP:
    # >>> free heap blocks from malloc
    jal freeAll

    # >>> exit directly
    j exit


freeAll:
    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, t1
    jal free
    mv a0, t2
    jal free
    mv a0, t3
    jal free
    mv a0, t4
    jal free
    mv a0, t5
    jal free
    mv a0, t6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

exitP49:
    li a1, 49
    jal exit2


lwts:
    lw t1, 0(sp)
    lw t2, 4(sp)
    lw t3, 8(sp)
    lw t4, 12(sp)
    lw t5, 16(sp)
    lw t6, 20(sp)
    addi sp, sp, 24

    ret

swts:
    addi sp, sp, -24
    sw t1, 0(sp)
    sw t2, 4(sp)
    sw t3, 8(sp)
    sw t4, 12(sp)
    sw t5, 16(sp)
    sw t6, 20(sp)

    ret