# start: 0xaa00aa
0000000:        auipc x1,0
0000004:        addi x1,x0,0
0000008:        lui x2,2720
000000c:        addi x2,x2,170
0000010:        sw x2,0(x1)
0000014:        lw x30,0(x1)
0000018:        lui x29,2720
000001c:        addi x29,x29,170
0000020:        addi x3,x0,2
0000024:        bne x30,x29,1120

# test_1: 0xaa00aa00
0000028:        auipc x1,0
000002c:        addi x1,x0,4
0000030:        lui x2,696331
0000034:        addi x2,x2,-1536
0000038:        sw x2,4(x1)
000003c:        lw x30,4(x1)
0000040:        lui x29,696331
0000044:        addi x29,x29,-1536
0000048:        addi x3,x0,3
000004c:        bne x30,x29,1080

# test_2: 0xaa00aa0
0000050:        auipc x1,0
0000054:        addi x1,x0,2
0000058:        lui x2,43521
000005c:        addi x2,x2,-1376
0000060:        sw x2,8(x1)
0000064:        lw x30,8(x1)
0000068:        lui x29,43521
000006c:        addi x29,x29,-1376
0000070:        addi x3,x0,4
0000074:        bne x30,x29,1040

# test_3: 0xa00aa00a
0000078:        auipc x1,0
000007c:        addi x1,x0,0
0000080:        lui x2,655530
0000084:        addi x2,x2,10
0000088:        sw x2,12(x1)
000008c:        lw x30,12(x1)
0000090:        lui x29,655530
0000094:        addi x29,x29,10
0000098:        addi x3,x0,5
000009c:        bne x30,x29,1000

# test_4: 0xaa00aa
00000a0:        auipc x1,0
00000a4:        addi x1,x0,16
00000a8:        lui x2,2720
00000ac:        addi x2,x2,170
00000b0:        sw x2,-12(x1)
00000b4:        lw x30,-12(x1)
00000b8:        lui x29,2720
00000bc:        addi x29,x29,170
00000c0:        addi x3,x0,6
00000c4:        bne x30,x29,960

# test_5: 0xaa00aa00
00000c8:        auipc x1,0
00000cc:        addi x1,x0,12 
00000d0:        lui x2,696331
00000d4:        addi x2,x2,-1536
00000d8:        sw x2,-8(x1)
00000dc:        lw x30,-8(x1)
00000e0:        lui x29,696331
00000e4:        addi x29,x29,-1536
00000e8:        addi x3,x0,7
00000ec:        bne x30,x29,920

# test_6: 0xaa00aa0
00000f0:        auipc x1,0
00000f4:        addi x1,x0,8
00000f8:        lui x2,43521
00000fc:        addi x2,x2,-1376
0000100:        sw x2,-4(x1)
0000104:        lw x30,-4(x1)
0000108:        lui x29,43521
000010c:        addi x29,x29,-1376
0000110:        addi x3,x0,8
0000114:        bne x30,x29,880

# test_7: 0xa00aa00a
0000118:        auipc x1,0
000011c:        addi x1,x0,4
0000120:        lui x2,655530
0000124:        addi x2,x2,10
0000128:        sw x2,0(x1)
000012c:        lw x30,0(x1)
0000130:        lui x29,655530
0000134:        addi x29,x29,10
0000138:        addi x3,x0,9
000013c:        bne x30,x29,840

# test_8: 0x12345678
0000140:        auipc x1,0
0000144:        addi x1,x0,32
0000148:        lui x2,74565
000014c:        addi x2,x2,1656
0000150:        addi x4,x1,-32
0000154:        sw x2,32(x4)
0000158:        lw x5,0(x1)
000015c:        lui x29,74565
0000160:        addi x29,x29,1656
0000164:        addi x3,x0,10
0000168:        bne x5,x29,796

# test_9: 
000016c:        auipc x1,0
0000170:        addi x1,x0,8
0000174:        lui x2,360979
0000178:        addi x2,x2,152
000017c:        addi x1,x1,-3
0000180:        sw x2,7(x1)
0000184:        auipc x4,0
0000188:        addi x4,x0,12
000018c:        lw x5,0(x4)
0000190:        lui x29,360979
0000194:        addi x29,x29,152
0000198:        addi x3,x0,11
000019c:        bne x5,x29,744

# test_10: 0xaabbccdd
00001a0:        addi x3,x0,12
00001a4:        addi x4,x0,0
00001a8:        lui x1,699325
00001ac:        addi x1,x1,-803
00001b0:        auipc x2,0
00001b4:        addi x2,x0,0
00001b8:        sw x1,0(x2)
00001bc:        lw x30,0(x2)
00001c0:        lui x29,699325
00001c4:        addi x29,x29,-803
00001c8:        bne x30,x29,700
00001cc:        addi x4,x4,1
00001d0:        addi x5,x0,2
00001d4:        bne x4,x5,-44

# test_11: 0xdaabbccd
00001d8:        addi x3,x0,13
00001dc:        addi x4,x0,0
00001e0:        lui x1,895676
00001e4:        addi x1,x1,-819
00001e8:        auipc x2,0
00001ec:        addi x2,x0,0
00001f0:        addi x0,x0,0
00001f4:        sw x1,4(x2)
00001f8:        lw x30,4(x2)
00001fc:        lui x29,895676
0000200:        addi x29,x29,-819
0000204:        bne x30,x29,640
0000208:        addi x4,x4,1
000020c:        addi x5,x0,2
0000210:        bne x4,x5,-48

# test_12: 0xddaabbcc
0000214:        addi x3,x0,14
0000218:        addi x4,x0,0
000021c:        lui x1,907948
0000220:        addi x1,x1,-1076
0000224:        auipc x2,0
0000228:        addi x2,x0,4
000022c:        addi x0,x0,0
0000230:        addi x0,x0,0
0000234:        sw x1,8(x2)
0000238:        lw x30,8(x2)
000023c:        lui x29,907948
0000240:        addi x29,x29,-1076
0000244:        bne x30,x29,576
0000248:        addi x4,x4,1
000024c:        addi x5,x0,2
0000250:        bne x4,x5,-52

# test_13: 0xcddaabbc
0000254:        addi x3,x0,15
0000258:        addi x4,x0,0
000025c:        lui x1,843179
0000260:        addi x1,x1,-1092
0000264:        addi x0,x0,0
0000268:        auipc x2,0
000026c:        addi x2,x0,4
0000270:        sw x1,12(x2)
0000274:        lw x30,12(x2)
0000278:        lui x29,843179
000027c:        addi x29,x29,-1092
0000280:        bne x30,x29,516
0000284:        addi x4,x4,1
0000288:        addi x5,x0,2
000028c:        bne x4,x5,-48

# test_14: 0xccddaabb
0000290:        addi x3,x0,16
0000294:        addi x4,x0,0
0000298:        lui x1,839131
000029c:        addi x1,x1,-1349
00002a0:        addi x0,x0,0
00002a4:        auipc x2,0
00002a8:        addi x2,x0,2
00002ac:        addi x0,x0,0
00002b0:        sw x1,16(x2)
00002b4:        lw x30,16(x2)
00002b8:        lui x29,839131
00002bc:        addi x29,x29,-1349
00002c0:        bne x30,x29,452
00002c4:        addi x4,x4,1
00002c8:        addi x5,x0,2
00002cc:        bne x4,x5,-52

# test_15: 0xbccddaab
00002d0:        addi x3,x0,17
00002d4:        addi x4,x0,0
00002d8:        lui x1,773342
00002dc:        addi x1,x1,-1365
00002e0:        addi x0,x0,0
00002e4:        addi x0,x0,0
00002e8:        auipc x2,0
00002ec:        addi x2,x0,0
00002f0:        sw x1,20(x2)
00002f4:        lw x30,20(x2)
00002f8:        lui x29,773342
00002fc:        addi x29,x29,-1365
0000300:        bne x30,x29,388
0000304:        addi x4,x4,1
0000308:        addi x5,x0,2
000030c:        bne x4,x5,-52

# test_16: 0x112233
0000310:        addi x3,x0,18
0000314:        addi x4,x0,0
0000318:        auipc x2,0
000031c:        addi x2,x0,8
0000320:        lui x1,274
0000324:        addi x1,x1,563
0000328:        sw x1,0(x2)
000032c:        lw x30,0(x2)
0000330:        lui x29,274
0000334:        addi x29,x29,563
0000338:        bne x30,x29,332
000033c:        addi x4,x4,1
0000340:        addi x5,x0,2
0000344:        bne x4,x5,-44

# test_17: 0x30011223
0000348:        addi x3,x0,19
000034c:        addi x4,x0,0
0000350:        auipc x2,0
0000354:        addi x2,x0,2
0000358:        lui x1,196625
000035c:        addi x1,x1,547
0000360:        addi x0,x0,0
0000364:        sw x1,4(x2)
0000368:        lw x30,4(x2)
000036c:        lui x29,196625
0000370:        addi x29,x29,547
0000374:        bne x30,x29,272
0000378:        addi x4,x4,1
000037c:        addi x5,x0,2
0000380:        bne x4,x5,-48

# test_18: 0x33001122
0000384:        addi x3,x0,20
0000388:        addi x4,x0,0
000038c:        auipc x2,0
0000390:        addi x2,x0,4
0000394:        lui x1,208897
0000398:        addi x1,x1,290
000039c:        addi x0,x0,0
00003a0:        addi x0,x0,0
00003a4:        sw x1,8(x2)
00003a8:        lw x30,8(x2)
00003ac:        lui x29,208897
00003b0:        addi x29,x29,290
00003b4:        bne x30,x29,208
00003b8:        addi x4,x4,1
00003bc:        addi x5,x0,2
00003c0:        bne x4,x5,-52

# test_19: 0x23300112
00003c4:        addi x3,x0,21
00003c8:        addi x4,x0,0
00003cc:        auipc x2,0
00003d0:        addi x2,x0,0
00003d4:        addi x0,x0,0
00003d8:        lui x1,144128
00003dc:        addi x1,x1,274
00003e0:        sw x1,12(x2)
00003e4:        lw x30,12(x2)
00003e8:        lui x29,144128
00003ec:        addi x29,x29,274
00003f0:        bne x30,x29,148
00003f4:        addi x4,x4,1
00003f8:        addi x5,x0,2
00003fc:        bne x4,x5,-48

# test_20: 0x22330011
0000400:        addi x3,x0,22
0000404:        addi x4,x0,0
0000408:        auipc x2,0
000040c:        addi x2,x0,0
0000410:        addi x0,x0,0
0000414:        lui x1,140080
0000418:        addi x1,x1,17
000041c:        addi x0,x0,0
0000420:        sw x1,16(x2)
0000424:        lw x30,16(x2)
0000428:        lui x29,140080
000042c:        addi x29,x29,17
0000430:        bne x30,x29,84
0000434:        addi x4,x4,1
0000438:        addi x5,x0,2
000043c:        bne x4,x5,-52

# test_21: 0x12233001
0000440:        addi x3,x0,23
0000444:        addi x4,x0,0
0000448:        auipc x2,0
000044c:        addi x2,x0,0
0000450:        addi x0,x0,0
0000454:        addi x0,x0,0
0000458:        lui x1,74291
000045c:        addi x1,x1,1
0000460:        sw x1,20(x2)
0000464:        lw x30,20(x2)
0000468:        lui x29,74291
000046c:        addi x29,x29,1
0000470:        bne x30,x29,20
0000474:        addi x4,x4,1
0000478:        addi x5,x0,2
000047c:        bne x4,x5,-52
0000480:        bne x0,x3,16

# fail:
0000484:        addi x11, x0, 10
0000488:        add x0, x0, x0
000048c:        beq x0, x0, -4

# pass:
0000490:        addi x11, x0, 12
0000494:        add x0, x0, x0
0000498:        beq x0, x0, -4