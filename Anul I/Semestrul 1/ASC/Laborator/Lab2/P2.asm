# Se se citeasca un vector cu n elemente
.data
v:.space 28 # 7 el pe 4 by
n:.word 7
.text
main:
lw $t0, n
li $t1, 0
li $t2, 0
loop:
beq $t1, $t0, exit
li $v0, 5
syscall
sw $v0, v($t2)
add $t1, 1
add $t2, 4
j loop
exit:
li $v0, 10
syscall
