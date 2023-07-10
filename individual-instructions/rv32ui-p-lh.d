# set up the data memory for the test
#     B1 B0
# 04: 00 ff
# 06: ff 00
# 08: 0f f0
# 0a: f0 0f

# start
0000000:        lui x1,0
0000004:        addi x1,x0,4
0000008:        addi x30,x0,255
000000c:        sw x30,0(x1)
0000014:        addi x30,x0,0
0000014:        lui x30,16
0000018:        addi x30,x30,3840
000001c:        sh x30,2(x1)
0000020:        lui x30,983281
0000024:        addi x30, x30,4080
0000028:        sw x30,4(x1)
000002c:        add x0,x0,x0

# test_1: ff0 
0000030:        lui x1,0
0000034:        addi x1,x0,4
0000038:        lh x30,4(x1)
000003c:        lui x29,1
0000040:        addi x29,x29,-16
0000044:        addi x3,x0,4
0000048:        bne x30,x29,548

# test_2: fffff00f
000004c:       lui x1,0
0000050:       addi x1,x0,4
0000054:       lh x30,6(x1)
0000058:       lui x29,1048575
000005c:       addi x29,x29,15
0000060:       addi x3,x0,5
0000064:       bne x30,x29,520

# test_3: ff
0000068:    lui x1,0
000006c:    addi x1,x0,10
0000070:    lh x30,-6(x1)
0000074:    addi x29,x0,255
0000078:    addi x3,x0,6
000007c:    bne x30,x29,496

# test_4
0000080:    lui x1,0
0000084:    addi x1,x0,10
0000088:    lh x30,-4(x1)
000008c:    addi x29,x0,-256
0000090:    addi x3,x0,7
0000094:    bne x30,x29,472

# test_5: ff0
0000098:    lui x1,0
000009c:    addi x1,x0,10
00000a0:    lh x30,-2(x1)
00000a4:    lui x29,1
00000a8:    addi x29,x29,-16
00000ac:    addi x3,x0,8
00000b0:    bne x30,x29,444

# test_6: fffff00f 
00000b4:    lui x1,0
00000b8:    addi x1,x0,10
00000bc:    lh x30,0(x1)
00000c0:    lui x29,1048575
00000c4:    addi x29,x29,15
00000c8:    addi x3,x0,9
00000cc:    bne x30,x29,416

# test_7
00000d0:    lui x1,0
00000d4:    addi x1,x0,4
00000d8:    addi x1,x1,-32
00000dc:    lh x5,32(x1)
00000e0:    addi x29,x0,255
00000e4:    addi x3,x0,10
00000e8:    bne x5,x29,388

# test_8
00000ec:    lui x1,0
00000f0:    addi x1,x0,4
00000f4:    addi x1,x1,-5
00000f8:    lh x5,7(x1)
00000fc:    addi x29,x0,-256
0000100:    addi x3,x0,11
0000104:    bne x5,x29,360

# test_9
0000108:    addi x3,x0,12
000010c:    addi x4,x0,0
0000110:    lui x1,0
0000114:    addi x1,x0,6
0000118:    lh x30,2(x1)
000011c:    addi x6,x30,0
0000120:    lui x29,1
0000124:    addi x29,x29,-16
0000128:    bne x6,x29,324
000012c:    addi x4,x4,1
0000130:    addi x5,x0,2
0000134:    bne x4,x5,-36

# test_10: fffff00f
0000138:    addi x3,x0,13
000013c:    addi x4,x0,0
0000140:    lui x1,0
0000144:    addi x1,x0,8
0000148:    lh x30,2(x1)
000014c:    addi x0,x0,0
0000150:    addi x6,x30,0
0000154:    lui x29,1048575
0000158:    addi x29,x29,15
000015c:    bne x6,x29,272
0000160:    addi x4,x4,1
0000164:    addi x5,x0,2
0000168:    bne x4,x5,-40

# test_11
000016c:    addi x3,x0,14
0000170:    addi x4,x0,0
0000174:    lui x1,0
0000178:    addi x1,x0,4
000017c:    lh x30,2(x1)
0000180:    addi x0,x0,0
0000184:    addi x0,x0,0
0000188:    addi x6,x30,0
000018c:    addi x29,x0,-256
0000190:    bne x6,x29,220
0000194:    addi x4,x4,1
0000198:    addi x5,x0,2
000019c:    bne x4,x5,-40

# test_12: ff0
00001a0:    addi x3,x0,15
00001a4:    addi x4,x0,0
00001a8:    lui x1,0
00001ac:    addi x1,x0,6
00001b0:    lh x30,2(x1)
00001b4:    lui x29,1
00001b8:    addi x29,x29,-16
00001bc:    bne x30,x29,176
00001c0:    addi x4,x4,1
00001c4:    addi x5,x0,2
00001c8:    bne x4,x5,-32

# test_13: fffff00f
00001cc:    addi x3,x0,16
00001d0:    addi x4,x0,0
00001d4:    lui x1,0
00001d8:    addi x1,x0,8
00001dc:    addi x0,x0,0
00001e0:    lh x30,2(x1)
00001e4:    lui x29,1048575
00001e8:    addi x29,x29,15
00001ec:    bne x30,x29,128
00001f0:    addi x4,x4,1
00001f4:    addi x5,x0,2
00001f8:    bne x4,x5,-36

# test_14: 
00001fc:    addi x3,x0,17
0000200:    addi x4,x0,0
0000204:    lui x1,0
0000208:    addi x1,x0,4
000020c:    addi x0,x0,0
0000210:    addi x0,x0,0
0000214:    lh x30,2(x1)
0000218:    addi x29,x0,-256
000021c:    bne x30,x29,80
0000220:    addi x4,x4,1
0000224:    addi x5,x0,2
0000228:    bne x4,x5,-36

# test_15
000022c:    lui x5,0
0000230:    addi x5,x0,4
0000234:    lh x2,0(x5)
0000238:    addi x2,x0,2
000023c:    addi x29,x0,2
0000240:    addi x3,x0,18
0000244:    bne x2,x29,40

# test_16:
0000248:    lui x5,0
000024c:    addi x5,x0,4
0000250:    lh x2,0(x5)
0000254:    addi x0,x0,0
0000258:    addi x2,x0,2
000025c:    addi x29,x0,2
0000260:    addi x3,x0,19
0000264:    bne x2,x29,8
0000268:    bne x0,x3,16

# fail:
000026c:        addi x11, x0, 10
0000270:        add x0, x0, x0
0000274:        beq x0, x0, -4

# pass:
0000278:        addi x11, x0, 12
000027c:        add x0, x0, x0
0000280:        beq x0, x0, -4