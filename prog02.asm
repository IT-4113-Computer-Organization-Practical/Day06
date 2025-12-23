#; Another code for add 5 numbers using a function

    .text

main:

    sub $sp, $sp, 8

    sw $ra, 0($sp)

    li $t0, 100
    li $t1, 101
    li $t2, 102
    li $t3, 103
    li $t4, 104

    move $a0, $t0
    move $a1, $t1
    move $a2, $t2
    move $a3, $t3

    sw $t4, 4($sp)

    jal add5
    
    move $a0, $v0

    li $v0, 1
    syscall

    lw $ra, 0($sp)

    addi $sp, $sp, 8

    jr $ra

add5:
    lw $t0, 4($sp)

    add $v0, $a0, $a1
    add $v0, $v0, $a2
    add $v0, $v0, $a3
    add $v0, $v0, $t0

    jr $ra