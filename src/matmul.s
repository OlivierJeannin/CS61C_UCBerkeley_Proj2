.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, error_exit
    blt a2, t0, error_exit
    blt a4, t0, error_exit
    blt a5, t0, error_exit
    bne a2, a4, error_exit

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    li t0, 0  # i = 0

outer_loop_start:

    bge t0, a1, outer_loop_end

    li t1, 0  # j = 0

inner_loop_start:

    bge t1, a5, inner_loop_end

    # prepare arguments for dot()
    mv t2, a0  # arr0 = m0

    slli t3, t1, 2
    add t3, t3, a3  # arr1 = m1 + j; points to the next column

    mv t4, a2  # n = col0
    li t5, 1   # stride0 = 1
    mv t6, a5  # stride1 = col1

    # save valuable info
    addi sp, sp, -36
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw t0, 28(sp)
    sw t1, 32(sp)

    # move dot() arguments to 'a' regs
    mv a0, t2
    mv a1, t3
    mv a2, t4
    mv a3, t5
    mv a4, t6

    jal ra, dot  # call dot()

    mv t2, a0  # t2 <- return value; make room for a0

    # restore valuable info
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw t0, 28(sp)
    lw t1, 32(sp)
    addi sp, sp, 36

    # write dot product to the result array
    sw t2, 0(a6)    # *d <- dot()

    addi a6, a6, 4  # d++; points to the next element
    addi t1, t1, 1  # j++
    j inner_loop_start

inner_loop_end:

    slli t2, a2, 2
    add a0, a0, t2  # m0 += c0; points to the next row
    addi t0, t0, 1  # i++
    j outer_loop_start

outer_loop_end:

    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4

    jr ra

error_exit:
    li a0, 38
    j exit
