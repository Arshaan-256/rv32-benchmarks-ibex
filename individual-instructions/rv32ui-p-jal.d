0000000:        addi x3, x0, 2
0000004:        addi x1, x0, 0
0000008:        jal x4, +16

# link_addr:
000000c:        addi x0, x0, 0
0000010:        addi x0, x0, 0
0000014:        jal x0, +64

# target:
0000018:        auipc x2, 0
000001c:        addi x2, x2, -12
0000020:        bne x2, x4, +52

# test:
0000024:        addi x1, x0, 1
0000028:        jal x0, +20
000002c:        addi x1, x1, 1
0000030:        addi x1, x1, 1
0000034:        addi x1, x1, 1
0000038:        addi x1, x1, 1
000003c:        addi x1, x1, 1
0000040:        addi x1, x1, 1
0000044:        addi x29, x0, 3
0000048:        addi x3, x0, 3
000004c:        bne x1, x29, +8
0000050:        bne x0, x3, +16

# fail:
0000054:        addi x11, x0, 10
0000058:        add x0, x0, x0
000005c:        beq x0, x0, -4

# pass:
0000060:        addi x11, x0, 12
0000064:        add x0, x0, x0
0000068:        beq x0, x0, -4
