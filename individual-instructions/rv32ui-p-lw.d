# set up the data memory for the test
#     B3 B2 B1 B0
# 04: 00 ff 00 ff
# 08: ff 00 ff 00
# 0c: 0f f0 0f f0
# 10: f0 0f f0 0f

# start
0000000:        lui x1,66566
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
0000044:        add x0,x0,x0
0000048:        add x0,x0,x0
000004c:        add x0,x0,x0
0000050:        add x0,x0,x0

# test_1: f00ff00f
0000054:        lui x1,66566
0000058:        addi x1,x1,4
000005c:        lw x30,12(x1)
0000060:        lui x29,983295
0000064:        addi x29,x29,15
0000068:        addi x3,x0,5
000006c:        bne x30,x29,+544

# test_2: 00ff00ff
0000070:        lui x1,66566
0000074:        addi x1,x1,16
0000078:        lw x30,-12(x1)
000007c:        lui x29,4080
0000080:        addi x29,x29,255
0000084:        addi x3,x0,6
0000088:        bne x30,x29,+516

# test_3: ff00ff00
000008c:        lui x1,66566
0000090:        addi x1,x1,16
0000094:        lw x30,-8(x1)
0000098:        lui x29,1044496
000009c:        addi x29,x29,-256
00000a0:        addi x3,x0,7
00000a4:        bne x30,x29,+488

# test_4: ff00ff0
00000a8:        lui x1,66566
00000ac:        addi x1,x1,16
00000b0:        lw x30,-4(x1)
00000b4:        lui x29,65281
00000b8:        addi x29,x29,-16
00000bc:        addi x3,x0,8
00000c0:        bne x30,x29,+460

# test_5: f00ff00f
00000c4:        lui x1,66566
00000c8:        addi x1,x1,16
00000cc:        lw x30,0(x1)
00000d0:        lui x29,983295
00000d4:        addi x29,x29,15
00000d8:        addi x3,x0,9
00000dc:        bne x30,x29,+432

# test_6: ff00ff
00000e0:        lui x1,66566
00000e4:        addi x1,x1,4
00000e8:        addi x1,x1,-32
00000ec:        lw x5,32(x1)
00000f0:        lui x29,4080
00000f4:        addi x29,x29,255
00000f8:        addi x3,x0,10
00000fc:        bne x5,x29,+400

# test_7: ff00ff00 
0000100:        lui x1,66566
0000104:        addi x1,x1,4
0000108:        addi x1,x1,-3
000010c:        lw x5,7(x1)
0000110:        lui x29,1044496
0000114:        addi x29,x29,-256
0000118:        addi x3,x0,11
000011c:        bne x5,x29,+368

# test_8: ff00ff0
0000120:        addi x3,x0,12
0000124:        addi x4,x0,0
0000128:        lui x1,66566
000012c:        addi x1,x1,8
0000130:        lw x30,4(x1)
0000134:        addi x6,x30,0
0000138:        lui x29,65281
000013c:        addi x29,x29,-16
0000140:        bne x6,x29,332
0000144:        addi x4,x4,1
0000148:        addi x5,x0,2
000014c:        bne x4,x5,-36

# test_9: f00ff00f
0000150:        addi x3,x0,13
0000154:        addi x4,x0,0
0000158:        lui x1,66566
000015c:        addi x1,x1,12
0000160:        lw x30,4(x1)
0000164:        addi x0,x0,0
0000168:        addi x6,x30,0
000016c:        lui x29,983295
0000170:        addi x29,x29,15
0000174:        bne x6,x29,280
0000178:        addi x4,x4,1
000017c:        addi x5,x0,2
0000180:        bne x4,x5,-40

# test_10: ff00ff00
0000184:        addi x3,x0,14
0000188:        addi x4,x0,0
000018c:        lui x1,66566
0000190:        addi x1,x1,4
0000194:        lw x30,4(x1)
0000198:        addi x0,x0,0
000019c:        addi x0,x0,0
00001a0:        addi x6,x30,0
00001a4:        lui x29,1044496
00001a8:        addi x29,x29,-256
00001ac:        bne x6,x29,224
00001b0:        addi x4,x4,1
00001b4:        addi x5,x0,2
00001b8:        bne x4,x5,-44

# test_11: ff00ff0
00001bc:        addi x3,x0,15
00001c0:        addi x4,x0,0
00001c4:        lui x1,66566
00001c8:        addi x1,x1,8
00001cc:        lw x30,4(x1)
00001d0:        lui x29,65281
00001d4:        addi x29,x29,-16
00001d8:        bne x30,x29,180
00001dc:        addi x4,x4,1
00001e0:        addi x5,x0,2
00001e4:        bne x4,x5,-32

# test_12: f00ff00f
00001e8:        addi x3,x0,16
00001ec:        addi x4,x0,0
00001f0:        lui x1,66566
00001f4:        addi x1,x1,12
00001f8:        addi x0,x0,0
00001fc:        lw x30,4(x1)
0000200:        lui x29,983295
0000204:        addi x29,x29,15
0000208:        bne x30,x29,132
000020c:        addi x4,x4,1
0000210:        addi x5,x0,2
0000214:        bne x4,x5,-36

# test_13: ff00ff00
0000218:        addi x3,x0,17
000021c:        addi x4,x0,0
0000220:        lui x1,66566
0000224:        addi x1,x1,4
0000228:        addi x0,x0,0
000022c:        addi x0,x0,0
0000230:        lw x30,4(x1)
0000234:        lui x29,1044496
0000238:        addi x29,x29,-256
000023c:        bne x30,x29,80
0000240:        addi x4,x4,1
0000244:        addi x5,x0,2
0000248:        bne x4,x5,-40

# test_14: 
000024c:        lui x5,66566
0000250:        addi x5,x5,4
0000254:        lw x2,0(x5)
0000258:        addi x2,x0,2
000025c:        addi x29,x0,2
0000260:        addi x3,x0,18
0000264:        bne x2,x29,+40

# test_15:
0000268:        lui x5,66566
000026c:        addi x5,x5,4
0000270:        lw x2,0(x5)
0000274:        addi x0,x0,0
0000278:        addi x2,x0,2
000027c:        addi x29,x0,2
0000280:        addi x3,x0,19
0000284:        bne x2,x29,+8
0000288:        bne x0,x3,+16

# fail:
000028c:        addi x11, x0, 10
0000290:        add x0, x0, x0
0000294:        beq x0, x0, -4

# pass:
0000298:        addi x11, x0, 12
000029c:        add x0, x0, x0
00002a0:        beq x0, x0, -4
