# Se da un vector in memorie, sa se afiseze pe ecran elementele lui
.data 
  v:.word 5, 19, 25, 15, 8
  n:.word 5
  sp:.asciiz " "
.text
main:
lw $t0, n 
li $t1, 0 # index
li $t2, 0 # pt loc de acumulare
loop:
beq $t1, $t0, exit
lw $a0, v($t2)
li $v0, 1
syscall
la $a0, sp
li $v0, 4
syscall
add $t1, 1
add $t2, 4
j loop
exit:
li $a0, 10
syscall
