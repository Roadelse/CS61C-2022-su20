.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    # addi s0, x0, 2
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    # res = 1; while a0 >1 , res = res * a0; a0 -= 1
    addi s0, x0, 1
    add t1, x0, a0
loop:
    mul s0, s0, t1
    addi t1, t1, -1
    bgt t1, x0, loop
    add a0, x0, s0
    jr ra 