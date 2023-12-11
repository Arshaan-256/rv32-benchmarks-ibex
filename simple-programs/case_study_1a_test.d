# D     = Total acceptable delay.
# delta = Delay allowed per core.
#
# Read hit, read miss, write hit, write miss
#   alp_rh,    alp_rm,    alp_wh,     alp_rm
#
# Every P clock cycle, read the read and write request latencies  of the CUA.
# Check if the delta / # of requests <=  alp_xh k_LLCh + alp_xm k_LLCm,
#                                        k_LLCh, k_LLCm are hits and miss -made by the interfering cores.
#
# x31 - Number of cores. (CUA is core 0.)
# x30 - Address of the data SPM.
# x29 - Address of Debug Module.
# x28 - Average latency threshold                           @ DSPM_BASE + 0x0
# x27 - Acceptable delay allowed per request per core.      @ DSPM_BASE + 0x4
# x23 - Read-hit delay on CUA from the interfering cores.   @ DSPM_BASE + 0x8
# x24 - Read-miss delay on CUA from the interfering cores.  @ DSPM_BASE + 0xc
# x25 - Write-hit delay on CUA from the interfering cores.  @ DSPM_BASE + 0x10
# x26 - Write-miss delay on CUA from the interfering cores. @ DSPM_BASE + 0x14
#
# x1 - Stores 1.
#
# x2 - Loop variable.
# x3 - Counter number that is being accessed.
#
# x4  - Total read requests to the LLC (LLC accesses) from CUA.
#       Total LLC hits from CUA.  
# x5  - Total write requests to the LLC (LLC accesses) from CUA.
# x7  - Total read response latency.
#       Total response latency.
# x8  - Total write response latency.
#       
# x9  - Multiply (average latency threshold, x28 * number of requests, x4).
#       Regulation variable, 1 if (x8 > x9).
#
# x10 - Read requests to the LLC (LLC read accesses) from non-CUA.
#       LLC read hits.
# x11 - Read requests to the memory (LLC read misses) from non-CUA.
# x12 - Write requests to the LLC (LLC write accesses) from non-CUA.
#       LLC write hits.
# x13 - Write requests to the memory (LLC write misses) from non-CUA.
# x14 - Temporary variable to hold multiply output.
# x15 - Worst-case delayed caused.
#       x14 = llc_rh * alp_rh + llc_rm * alp_rm + 
#             llc_wh * alp_wh + llc_wm * alp_wm
# x16 - Acceptable delay.
# x17 - Is acceptable delay < delayed caused? (1 if yes)
#
# x19 - Mask.
# x20 - Bit vector holding the status of halted / resumed cores.
# x21 - Is the core halted? (1 if yes.)
#
# x22 - Halt core
#       Resume core
#
# ****
# DSPM
# ****
# 0x00: Average latency threshold.
# 0x04: Acceptable delay allowed per core.
# 0x08: Read-hit delay on CUA from the interfering cores.
# 0x0c: Read-miss delay on CUA from the interfering cores.
# 0x10: Write-hit delay on CUA from the interfering cores.
# 0x14: Write-miss delay on CUA from the interfering cores.
# 0x18: Store upper bits of total latency.
# 0x1c: Store lower bits of total latency.
# 0x20: Write core status here for debugging.
# 0x24: Program over.
#
# *******************************************************************
# Init.
# *******************************************************************
# Load number of cores
0x00000000:         addi x31,x0,4
# Load DSPM base address into x30.
0x00000004:         lui x30,0
0x00000008:         addi x30,x30,0
# Load Debug Module base address into x30.
0x0000000c:         lui x29,0
0x00000010:         addi x29,x29,512
# Store x1 = 1.
0x00000014:         addi x1,x0,1
# x28 is the average latency threshold.
0x00000018:         lw x28,0(x30)
# x27 is the acceptable delay allowed per request per core (delta).
0x0000001c:         lw x27,4(x30)
# Load the parameters.
0x00000020:         lw x23,8(x30)
0x00000024:         lw x24,12(x30)
0x00000028:         lw x25,16(x30)
0x0000002c:         lw x26,20(x30)
0x00000030:         addi x1,x0,1
#
# *******************************************************************
# OuterLoop: Program starts.
# *******************************************************************
$OUTER_LOOP:        0x00000034
# x2 = 0
0x00000034:         addi x2,x0,0
# x3 = 0, x4 = cnt[x3], LLC read accesses
0x00000038:         addi x3,x0,0
0x0000003c:         cnt.rd x4,x3
# x3 = 1, x6 = cnt[x3], LLC write accesses
0x00000040:         addi x3,x3,1
0x00000044:         cnt.rd x5,x3
# x4 = total LLC accesses
0x00000048:         add x4,x4,x5
# x3 = 2, x7 = cnt[x3], total read response latency ; then reset counter
0x0000004c:         addi x3,x3,1
0x00000050:         cnt.rd x7,x3
0x00000054:         cnt.wr x3,x0
# x3 = 3, x8 = cnt[x3], total write response latency ; then reset counter
0x00000058:         addi x3,x3,1
0x0000005c:         cnt.rd x8,x3
0x00000060:         cnt.wr x3,x0
# x7 = x7 + x8, total response latency
0x00000064:         add x7,x7,x8
# Load old total latency from DSPM.
# x9 = Upper bits of total latency
# x8 = Lower bits of total latency
0x00000068:         lw x9,24(x30)
0x0000006c:         lw x8,28(x30)
# Add up to get new total latency
0x00000070:         add x8,x7,x8
# x8 = x7 + x8, if x8 < x7 then there as a carry; if x7 <= x8 then there was no carry.
0x00000074:         bgeu x8,x7,$NO_CARRY_CUA
# If there was a carry increment the upper 32 bits.
0x00000078:         addi x9,x9,1
# Store new total latency to DSPM.
0x00000068:         sw x9,24(x30)
0x0000006c:         sw x8,28(x30)
#
# Calculate total latency threshold.
# x10 - Lower bits of total latency thershold.
# x11 - Upper bits of total latency thershold.
$NO_CARRY_CUA:      0x0000007c
0x0000007c:         mul x10,x28,x4
0x00000080:         mulhu x11,x28,x4
# Calculate acceptable delay for non-CUA cores.
# x16 - Lower bits of acceptable delay.
# x17 - Upper bits of acceptable delay.
0x00000084:         mul x16,x27,x4
0x00000088:         mulhu x17,x27,x4
# Compare total latency against threshold.
# If Uthres <  Utotal => Regulate ; else continue
# If Uthres != Utotal => Don't regulate ; else continue
# If Lthres <  Ltotal => Regulate ; else don't regulate
# Latency threshold: {x11,x10} and total delay: {x9,x8}
0x0000008c:         bltu x11,x9,$REGULATE
0x00000090:         bne x11,x9,$NO_REGULATE
0x00000094:         bltu x10,x8,$REGULATE
$NO_REGULATE:       0x00000098
0x00000098:         addi x9,x0,0
0x0000009c:         beq x0,x0,$INNER_LOOP
$REGULATE:          0x000000a0
0x000000a0:         addi x9,x0,1
# At this point, the only important register is x1, x2, x3 and x9.
# Load 1 into x1.
#
# *******************************************************************
# InnerLoop: Access the non-CUA cores' counters.
# *******************************************************************
# Load loop variable.
$INNER_LOOP:        0x000000a4
0x000000a4:         addi x2,x2,1
# x3 = x3+1, x10 = cnt[x3], LLC read accesses by non-CUA
0x000000a8:         addi x3,x3,1
0x000000ac:         cnt.rd x10,x3
# x3 = x3+1, x11 = cnt[x3], LLC read misses by non-CUA
0x000000b0:         addi x3,x3,1
0x000000b4:         cnt.rd x11,x3
# x3 = x3+1, x12 = cnt[x3], LLC write accesses
0x000000b8:         addi x3,x3,1
0x000000bc:         cnt.rd x12,x3
# x3 = x3+1, x13 = cnt[x3], LLC write misses
0x000000c0:         addi x3,x3,1
0x000000c4:         cnt.rd x13,x3
# x10 = x10 - x11, LLC read hits by non-CUA
0x000000c8:         sub x10,x10,x11
# x12 = x12 - x13, LLC write hits by non-CUA
0x000000cc:         sub x12,x12,x13
#
#
# Calculate worst-case delay caused.
# Read Hits (x10, x23)
# x4 = LowerBits(x10 * x23)
# x5 = UpperBits(x10 * x23)
0x000000d0:         mul x4,x10,x23
0x000000d4:         mulhu x5,x10,x23
# Read Misses (x11, x24)
# x7, x6  = x11 * x24
0x000000d8:         mul x6,x11,x24
0x000000dc:         mulhu x7,x11,x24
# x5 = x5 + x7 ; x4 = x4 + x6
0x000000e0:         add x5,x5,x7
0x000000e4:         add x4,x4,x6
# Check carry logic: Dest <= Dest + Src, if Dest < Src then there was carry OR if Dest >= Src then there was no carry.
0x000000e8:         bgeu x4,x6,$NO_CARRY_RM
0x000000ec:         addi x5,x5,1
#
# Check if WC_Delay > Acceptable Delay.
# If Uaccept <  Uwc => Halt core ; else continue
# If Uaccept != Uwc => Don't halt core ; else continue
# If Laccept <  Lwc => Halt core ; else continue
# Accept_delay = {x17,x16} and WC_delay = {x5,x4}
$NO_CARRY_RM:       0x000000f0
0x000000f0:         bltu x17,x5,$HALT_DECISION
0x000000f4:         bne x17,x5,$CONTINUE_WH
0x000000f8:         bltu x16,x4,$HALT_DECISION
#
#
# Write Hits (x12, x25)
# x7, x6  = x12 * x25
$CONTINUE_WH:       0x000000fc
0x000000fc:         mul x6,x12,x25
0x00000100:         mulhu x7,x12,x25
# x5 = x5 + x7 ; x4 = x4 + x6
0x00000104:         add x5,x5,x7
0x00000108:         add x4,x4,x6
# Check carry logic: Dest <= Dest + Src, if Dest < Src then there was carry OR if Dest >= Src then there was no carry.
0x0000010c:         bgeu x4,x6,$NO_CARRY_WH
0x00000110:         addi x5,x5,1
#
# Check if WC_Delay > Acceptable Delay.
# If Uaccept <  Uwc => Halt core ; else continue
# If Uaccept != Uwc => Don't halt core ; else continue
# If Laccept <  Lwc => Halt core ; else continue
# Accept_delay = {x17,x16} and WC_delay = {x5,x4}
$NO_CARRY_WH:       0x00000114
0x00000114:         bltu x17,x5,$HALT_DECISION
0x00000118:         bne x17,x5,$CONTINUE_WM
0x0000011c:         bltu x16,x4,$HALT_DECISION
#
#
# Write Misses (x13, x26)
# x7, x6  = x13 * x26
$CONTINUE_WM:       0x00000120
0x00000120:         mul x6,x13,x26
0x00000124:         mulhu x7,x13,x26
# x5 = x5 + x7 ; x4 = x4 + x6
0x00000128:         add x5,x5,x7
0x0000012c:         add x4,x4,x6
# Check carry logic: Dest <= Dest + Src, if Dest < Src then there was carry OR if Dest >= Src then there was no carry.
0x00000130:         bgeu x4,x6,$NO_CARRY_WM
0x00000134:         addi x5,x5,1
#
# Check if WC_Delay > Acceptable Delay.
# If Uaccept <  Uwc => Halt core ; else continue
# If Uaccept != Uwc => Don't halt core ; else continue
# If Laccept <  Lwc => Halt core ; else continue
# Accept_delay = {x17,x16} and WC_delay = {x5,x4}
$NO_CARRY_WM:       0x00000138
0x00000138:         bltu x17,x5,$HALT_DECISION
0x0000013c:         bne x17,x5,$NO_HALT_DECISION
0x00000140:         bltu x16,x4,$HALT_DECISION
#
#
# x5 (Reuse) = 1, if acceptable-delay < WC-delay else 0.
$NO_HALT_DECISION:  0x00000144
0x00000144:         addi x5,x0,0
0x00000148:         beq x0,x0,$STATUS
$HALT_DECISION:     0x0000014c
0x0000014c:         addi x5,x0,1
#
$STATUS:            0x00000150
# Mask = 1 << Core Number
# x21  = x1 << x2
0x00000150:         sll x19,x1,x2
# x21 = (x20 & x19) (BitVector & Mask)
0x00000154:         and x21,x20,x19
# x21 = x21 >> x2
# CoreHalted = (BitVector & Mask) >> Core Number
0x00000158:         srl x21,x21,x2
#
# Resume core = CoreHalted & (WC-delay =< acceptable-delay)
# x22         = x21        & x6 (=!x5) (Reuse) 
# If 1, go to Resume Function.
0x0000015c:         xori x6,x5,1
0x00000160:         and x22,x21,x6
0x00000164:         beq x22,x1,$RESUME_CORE
#
# Halt core = Regulate & !CoreHalted & (acceptable-delay < WC-delay)
# x22       = x9       & !x21        & x5   
# x21[0] = !x21[0]
# If 1, go to Halt Function. (000000ec)
0x00000168:         xori x21,x21,1
0x0000016c:         and x22,x9,x21
0x00000170:         and x22,x22,x5
0x00000174:         beq x22,x1,$HALT_CORE
#
# ****************************************
# Update: Loop Variable and run next epoch
# ****************************************
# If x2 < x31: go to InnerLoop. (00000068)
$UPDATE:            0x00000178
0x00000178:         blt x2,x31,$INNER_LOOP
# Go to OuterLoop. (00000030)
# This is reset by CVA6.
0x0000017c:         sw x1,36(x30)
0x00000180:         beq x0,x0,$OUTER_LOOP
#
# *************
# Halt Function
# *************
# 00000000: sw x2,0(x29)
$HALT_CORE:         0x00000184
0x00000184:         or x20,x20,x19
0x00000188:         add x0,x0,x0
# Store core_status at DSPM_BASE_ADDR + 0x20
0x0000018c:         sw x20,32(x30)
0x00000190:         add x0,x0,x0
0x00000194:         add x0,x0,x0
# Go to Update Function. (000000e0)
0x00000198:         beq x0,x0,$UPDATE
# ***************
# Resume Function
# ***************
# 00000000: sw x2,8(x29)
$RESUME_CORE:       0x0000019c
0x0000019c:         xori x19,x19,-1
0x000001a0:         and x20,x20,x19
# Store core_status at DSPM_BASE_ADDR + 0x20
0x000001a4:         sw x20,32(x30)
# Go to Update Function. (000000e0)
0x000001a8:         beq x0,x0,$UPDATE
