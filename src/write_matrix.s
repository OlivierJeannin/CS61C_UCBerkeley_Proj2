.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
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
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)

    # Some values to use throught out the function
    mv x0 a0  # no need to save a0 since it has no use after fopen()
    mv s0 a1  # address of matrix array
    mv s1 a2  # number of rows
    mv s2 a3  # number of cols
    li s3 0   # file descriptor
    li s4 0   # number of elements in matrix array


    # Open file
    li a1 1

    call fopen

    li t0 -1
    beq a0 t0 fopen_error

    mv s3 a0  # file descriptor


    # Write numbers of rows and cols to file
    addi sp sp -8
    sw s1 0(sp)  # number of rows
    sw s2 4(sp)  # number of cols

    mv a0 s3
    mv a1 sp
    li a2 2
    li a3 4

    call fwrite

    li t0 2
    bne a0 t0 fwrite_error

    addi sp sp 8


    # Write matrix array to file
    mul s4 s1 s2  # number of array elements

    mv a0 s3
    mv a1 s0
    mv a2 s4
    li a3 4

    call fwrite

    bne a0 s4 fwrite_error


    # Close file
    mv a0 s3

    call fclose

    li t0 -1
    beq a0 t0 fclose_error


    # Epilogue

    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    addi sp sp 24

    jr ra

fopen_error:
    li a0 27
    j exit

fclose_error:
    li a0 28
    j exit

fwrite_error:
    li a0 30
    j exit
