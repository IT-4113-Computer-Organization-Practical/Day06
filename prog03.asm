#; Reading and printing an array of chars (string)

    .text

main:

    li $v0, 8
    la $a0, string1
    li $a1, 100
    syscall

    li $v0, 4
    la $a0, string1
    syscall

    move $t0, $a0

loop:
    lb $t1, 0($t0)
    beq $t1, $zero, done

    li $v0, 11
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    add $t0, $t0, 1

    j loop

done:
    jr $ra

    .data
string1:    .space 100
newline:    .asciiz "\n"

