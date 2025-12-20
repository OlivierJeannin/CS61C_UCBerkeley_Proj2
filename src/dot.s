.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    li t0, 36
    bge zero, a2, exception_exit

    li t0, 37
    bge zero, a3, exception_exit
    bge zero, a4, exception_exit

    li t0, 0  # dot_prod = 0
    li t1, 0  # int i = 0

loop_start:
    bge t1, a2, loop_end

    lw t3, 0(a0)  # load *arr0
    lw t4, 0(a1)  # load *arr1
    mul t2, t3, t4  # prod = (*arr0) * (*arr1)

    add t0, t0, t2  # dot_prod += prod

    # arr0 += stride0
    slli t3, a3, 2
    add a0, a0, t3

    # arr1 += stride1
    slli t4, a4, 2
    add a1, a1, t4

    addi t1, t1, 1  # i++

    j loop_start

loop_end:
    # Epilogue
    addi a0, t0, 0

    jr ra

exception_exit:
    mv a0, t0
    j exit
