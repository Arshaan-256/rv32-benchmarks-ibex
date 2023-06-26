# set up the data memory for the test
# 00: B0 B1 B2 B3
# 04: ff 00 ff 00 
# 08: 00 ff 00 ff
# 0c: f0 0f f0 0f
# 10: 0f f0 0f f0
0000000:        auipc x1,0
0000004:        addi x1,x1,4
0000008:        lui x30,4080
000000c:        addi x30,x30,255
0000010:        sw x30,0(x1)
0000014:        lui x30,16
0000018:        addi x30,x30,-256
000001c:        sh x30,4(x1)
0000020:        sh x30,6(x1)
0000024:        lui x30, 1
0000028:        addi x30, x30, -16
000002c:        sh x30,8(x1)
0000030:        sh x30,10(x1)
0000034:        lui x30,983295
0000038:        addi x30,x30,15
000003c:        sw x30, 12(x1)
0000040:        add x0,x0,x0
0000044:        beq x0,x0,-4
0000048:        add x0,x0,x0
000004c:        add x0,x0,x0
0000050:        add x0,x0,x0

