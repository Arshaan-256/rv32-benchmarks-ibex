# Bubble Sort.
# x1 - Base Address of the array.
# x2 - Size of array.
# x3, x4 - Variables to store array elements that are being compared.
# x5 - Swapped.

80000000:   addi x2,x1,1996
80000004:   add x0,x0,x0
80000008:   lui x5,0
8000000c:   lw x4,0(x1)
80000010:   lw x3,4(x1)
80000014:   bge x3,x4,16
80000018:   sw x3,0(x1)
8000001c:   sw x4,4(x1)
80000020:   addi x5,x5,1
80000024:   addi x1,x1,4
80000028:   bne x1,x2,-28
8000002c:   beq x5,x0,8
80000030:   addi x2,x2,-4
80000034:   bne x2,x1,-28
80000038:   add x0,x0,x0
8000003c:   beq x0,x0,-4
