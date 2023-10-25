.data
x:.word 4
y:.word 6
sp:.asciiz " "
.text
main:
lw $t0, x
lw $t1, y
sw $t0, y
sw $t1, x
li $v0, 1
move $a0, $t1
syscall
li $v0, 4
la $a0, sp
syscall
move $a0, $t0
li $v0, 1
syscall
li $v0, 10
syscall
