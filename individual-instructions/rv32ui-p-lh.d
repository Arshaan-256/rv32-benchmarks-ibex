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
1000030:        lui x1,0
1000034:        addi x1,x0,4
1000038:        lh x30,4(x1)
100003c:        lui x29,1
1000040:        addi x29,x29,-16
1000044:        addi x3,x0,4
1000048:        bne x30,x29,548

# test_2: fffff00f
100004c:       lui x1,0
1000050:       addi x1,x0,4
1000054:       lh x30,6(x1)
1000058:       lui x29,1048575
100005c:       addi x29,x29,15
1000060:       addi x3,x0,5
1000064:       bne x30,x29,520

# test_3: ff
1000068:    lui x1,0
100006c:    addi x1,x0,10
1000070:    lh x30,-6(x1)
1000074:    addi x29,x0,255
1000078:    addi x3,x0,6
100007c:    bne x30,x29,496

# test_4
1000080:    lui x1,0
1000084:    addi x1,x0,10
1000088:    lh x30,-4(x1)
100008c:    addi x29,x0,-256
1000090:    addi x3,x0,7
1000094:    bne x30,x29,472

# test_5: ff0
1000098:    lui x1,0
100009c:    addi x1,x0,10
10000a0:    lh x30,-2(x1)
10000a4:    lui x29,1
10000a8:    addi x29,x29,-16
10000ac:    addi x3,x0,8
10000b0:    bne x30,x29,444

# test_6: fffff00f 
10000b4:    lui x1,0
10000b8:    addi x1,x0,10
10000bc:    lh x30,0(x1)
10000c0:    lui x29,1048575
10000c4:    addi x29,x29,15
10000c8:    addi x3,x0,9
10000cc:    bne x30,x29,416

# test_7
10000d0:    lui x1,0
10000d4:    addi x1,x0,4
10000d8:    addi x1,x1,-32
10000dc:    lh x5,32(x1)
10000e0:    addi x29,x0,255
10000e4:    addi x3,x0,10
10000e8:    bne x5,x29,388

# test_8
10000ec:    lui x1,0
10000f0:    addi x1,x0,4
10000f4:    addi x1,x1,-5
10000f8:    lh x5,7(x1)
10000fc:    addi x29,x0,-256
1000100:    addi x3,x0,11
1000104:    bne x5,x29,360

# test_9
1000108:    addi x3,x0,12
100010c:    addi x4,x0,0
1000110:    lui x1,0
1000114:    addi x1,x0,6
1000118:    lh x30,2(x1)
100011c:    addi x6,x30,0
1000120:    lui x29,1
1000124:    addi x29,x29,-16
1000128:    bne x6,x29,324
100012c:    addi x4,x4,1
1000130:    addi x5,x0,2
1000134:    bne x4,x5,-36

# test_10: fffff00f
1000138:    addi x3,x0,13
100013c:    addi x4,x0,0
1000140:    lui x1,0
1000144:    addi x1,x0,8
1000148:    lh x30,2(x1)
100014c:    addi x0,x0,0
1000150:    addi x6,x30,0
1000154:    lui x29,1048575
1000158:    addi x29,x29,15
100015c:    bne x6,x29,272
1000160:    addi x4,x4,1
1000164:    addi x5,x0,2
1000168:    bne x4,x5,-40

# test_11
100016c:    addi x3,x0,14
1000170:    addi x4,x0,0
1000174:    lui x1,0
1000178:    addi x1,x0,4
100017c:    lh x30,2(x1)
1000180:    addi x0,x0,0
1000184:    addi x0,x0,0
1000188:    addi x6,x30,0
100018c:    addi x29,x0,-256
1000190:    bne x6,x29,220
1000194:    addi x4,x4,1
1000198:    addi x5,x0,2
100019c:    bne x4,x5,-40

# test_12: ff0
10001a0:    addi x3,x0,15
10001a4:    addi x4,x0,0
10001a8:    lui x1,0
10001ac:    addi x1,x0,6
10001b0:    lh x30,2(x1)
10001b4:    lui x29,1
10001b8:    addi x29,x29,-16
10001bc:    bne x30,x29,176
10001c0:    addi x4,x4,1
10001c4:    addi x5,x0,2
10001c8:    bne x4,x5,-32

# test_13: fffff00f
10001cc:    addi x3,x0,16
10001d0:    addi x4,x0,0
10001d4:    lui x1,0
10001d8:    addi x1,x0,8
10001dc:    addi x0,x0,0
10001e0:    lh x30,2(x1)
10001e4:    lui x29,1048575
10001e8:    addi x29,x29,15
10001ec:    bne x30,x29,128
10001f0:    addi x4,x4,1
10001f4:    addi x5,x0,2
10001f8:    bne x4,x5,-36

# test_14: 
10001fc:    addi x3,x0,17
1000200:    addi x4,x0,0
1000204:    lui x1,0
1000208:    addi x1,x0,4
100020c:    addi x0,x0,0
1000210:    addi x0,x0,0
1000214:    lh x30,2(x1)
1000218:    addi x29,x0,-256
100021c:    bne x30,x29,80
1000220:    addi x4,x4,1
1000224:    addi x5,x0,2
1000228:    bne x4,x5,-36

# test_15
100022c:    lui x5,0
1000230:    addi x5,x0,4
1000234:    lh x2,0(x5)
1000238:    addi x2,x0,2
100023c:    addi x29,x0,2
1000240:    addi x3,x0,18
1000244:    bne x2,x29,40

# test_16:
1000248:    lui x5,0
100024c:    addi x5,x0,4
1000250:    lh x2,0(x5)
1000254:    addi x0,x0,0
1000258:    addi x2,x0,2
100025c:    addi x29,x0,2
1000260:    addi x3,x0,19
1000264:    bne x2,x29,8
1000268:    bne x0,x3,16

# fail:
000026c:        addi x11, x0, 10
0000270:        add x0, x0, x0
0000274:        beq x0, x0, -4

# pass:
0000278:        addi x11, x0, 12
000027c:        add x0, x0, x0
0000280:        beq x0, x0, -4