.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    li t0, 0  # int i = 0

    blt zero, a1, loop_start
    li a0, 36
    j exit

loop_start:
    bge t0, a1, loop_end

    lw t1, 0(a0)  # load *a0
    bge t1, zero, loop_continue
    sw zero, 0(a0)  # *a0 = 0

loop_continue:
    addi a0, a0, 4  # a0++
    addi t0, t0, 1  # i++
    j loop_start

loop_end:
    # Epilogue


    jr ra
