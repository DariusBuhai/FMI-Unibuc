.data
n:.space 4
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
add $t2, $t2, $t1
addi $t1 $t1, 1
j loop
exit:
move $a0, $t2
li $v0, 1
syscall
li $v0, 10
syscall
