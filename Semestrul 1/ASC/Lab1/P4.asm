.data
n:.space 4
sep:.asciiz "."
.text
main:
li $v0, 5
syscall
move $t0, $v0
sw $v0, n
li $t1, 0
li $t2, 0
loop:
beq $t1, $t0, exit
li $v0, 5
syscall
move $t3, $v0
add $t2, $t2, $t3
addi $t1, $t1, 1
j loop
exit:
li $v0, 1
div $t4, $t2, $t0
rem $t5, $t2, $t0
move $a0, $t4
syscall
li $v0, 4
la $a0, sep
syscall
li $v0, 1
move $a0, $t5
syscall
li $v0, 10
syscall
