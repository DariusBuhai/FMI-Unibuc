.data
n:.space 4
sp:.asciiz " "
.text
main:
la $v0, 5
syscall
move $t0, $v0
sw $t0, n
li $t1, 0
loop: 
beq $t1, $t0, exit
move $a0, $t1
li $v0, 1
syscall
la $a0, sp
li $v0, 4
syscall
addi $t1, $t1, 1
j loop
exit:
li $v0, 10
syscall
