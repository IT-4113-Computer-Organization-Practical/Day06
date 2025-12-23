#; Function call with more that 5 arguments

    .text
    .globl main

main:

    li $a0, 100
    li $a1, 101
    li $a2, 102
    li $a3, 103

    addi $sp, $sp, -4
    li $t0, 104
    sw $t0, 0($sp)

    jal addition

    addi $sp, $sp 4

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall

addition:
    addi $sp, $sp, -8
    sw $ra, 4($sp)

    lw $t0, 8($sp)

    add $t1, $a0, $a1
    add $t1, $t1, $a2
    add $t1, $t1, $a3
    add $v0, $t1, $t0

    lw $ra, 4($sp)

    addi $sp, $sp, 8

    jr $ra