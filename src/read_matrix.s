.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
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
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue

    addi sp sp -36
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)

    # some values to be used through out the function
    mv x0 a0  # no need to save a0 since it has no use after fopen()
    mv s0 a1  # address of row number
    mv s1 a2  # address of col number
    li s2 -1  # function return value on error
    li s3 4   # number of bytes to read for each fread()


    # Open file
    li a1 0

    call fopen
    beq a0 s2 fopen_error

    mv s4 a0  # file descriptor


    # Read row number
    mv a0 s4
    mv a1 s0
    mv a2 s3
    call fread
    bne a0 s3 fread_error


    # Read col number
    mv a0 s4
    mv a1 s1
    mv a2 s3
    call fread
    bne a0 s3 fread_error


    # Allocate space for the matrix
    lw t0 0(s0)   # row number
    lw t1 0(s1)   # col number
    mul s5 t0 t1  # total number of elements in matrix

    slli a0 s5 2
    call malloc
    beq a0 x0 malloc_error

    mv s6 a0  # address of allocated array


    # Read the matrix

    li s7 0  # i = 0
loop_start:
ebreak
    bge s7 s5 loop_end

    mv a0 s4
    mv a1 s6
    mv a2 s3
    call fread
    bne a0 s3 fread_error
ebreak
    add s6 s6 s3  # arr += 4
    addi s7 s7 1  # i++

    j loop_start

loop_end:


    # Close the file
    mv a0 s4
    call fclose
    beq a0 s2 fclose_error


    # Return value
    slli s5 s5 2
    sub a0 s6 s5  # arr -= total_num_elements * 4


    # Epilogue

    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    addi sp sp 36

    jr ra

malloc_error:
    li a0 26
    j exit

fopen_error:
    li a0 27
    j exit

fclose_error:
    li a0 28
    j exit

fread_error:
    li a0 29
    j exit
