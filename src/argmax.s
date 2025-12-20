.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    blt zero, a1, loop_start	# (0 < len) aka (len >= 1)
    li a0, 36
    j exit

loop_start:
    li t0, 0			# int i = 0
    li t1, 0			# largest_index = 0
    lw t2, 0(a0)		# largest_val = *arr

loop_continue:
    addi t0, t0, 1		# i++
    addi a0, a0, 4		# arr++

    bge t0, a1, loop_end	# i >= len
    lw t3, 0(a0)		# load *arr

    bge t2, t3, loop_continue	# largest_val >= *arr

    addi t1, t0, 0		# largest_index = i
    addi t2, t3, 0		# largest_val = *arr
    j loop_continue

loop_end:
    # Epilogue
    addi a0, t1, 0		# return largest_index

    jr ra
