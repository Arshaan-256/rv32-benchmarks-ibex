# D     = Total acceptable delay.
# delta = Delay allowed per core.

# Read hit, read miss, write hit, write miss
#   alp_rh,    alp_rm,    alp_wh,     alp_rm

# Every P clock cycle, read the read and write request latencies  of the CUA.
# Check if the delta / # of requests <=  alp_xh k_LLCh + alp_xm k_LLCm,
#                                        k_LLCh, k_LLCm are hits and miss -made by the interfering cores.

# x31 - Number of cores. (CUA is core 0.)
# x30 - Address of the data SPM.
# x29 - Address of Debug Module.
# x28 - Average latency threshold                           @ DSPM_BASE + 0x0
# x27 - Acceptable delay allowed per request per core.      @ DSPM_BASE + 0x4
# x23 - Read-hit delay on CUA from the interfering cores.   @ DSPM_BASE + 0x8
# x24 - Read-miss delay on CUA from the interfering cores.  @ DSPM_BASE + 0xc
# x25 - Write-hit delay on CUA from the interfering cores.  @ DSPM_BASE + 0x10
# x26 - Write-miss delay on CUA from the interfering cores. @ DSPM_BASE + 0x14

# x1 - Stores 1.

# x2 - Loop variable.
# x3 - Counter number that is being accessed.

# x4  - Total read requests to the LLC (LLC accesses) from CUA.
#       Total LLC hits from CUA.  
# x5  - Total write requests to the LLC (LLC accesses) from CUA.
# x7  - Total read response latency.
# x8  - Total write response latency.
#       Total response latency.

# x9  - Multiply (average latency threshold, x28 * number of requests, x4).
#       Regulation variable, 1 if (x8 > x9).


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

# x19 - Mask.
# x20 - Bit vector holding the status of halted / resumed cores.
# x21 - Is the core halted? (1 if yes.)

# x22 - Halt core
#       Resume core

# DSPM
# 00: Average latency threshold.
# 04: Acceptable delay allowed per core.
# 08: Read-hit delay on CUA from the interfering cores.
# 0c: Read-miss delay on CUA from the interfering cores.
# 10: Write-hit delay on CUA from the interfering cores.
# 14: Write-miss delay on CUA from the interfering cores.
# 18: Target Address
# 

# *******************************************************************
# Init.
# *******************************************************************
# Load number of cores
00000000: addi x31,x0,4
# Load DSPM base address into x30.
00000004: lui x30,0
00000008: addi x30,x30,0
# Load Debug Module base address into x30.
0000000c: lui x29,0
00000010: addi x29,x29,512
# Store x1 = 1.
00000014: addi x1,x0,1
# x28 is the acceptable delay allowed per request per core (delta).
00000018: lw x28,0(x30)
# x27 is the acceptable delay allowed per request per core (delta).
0000001c: lw x27,4(x30)
# Load the parameters.
00000020: lw x23,8(x30)
00000024: lw x24,12(x30)
00000028: lw x25,16(x30)
0000002c: lw x26,20(x30)
#
# *******************************************************************
# OuterLoop: Program starts.
# *******************************************************************
# x2 = 0
00000030: addi x2,x0,0
# x3 = 0, x4 = cnt[x3], LLC read accesses
00000034: addi x3,x0,0
00000038: cnt.rd x4,x3
# x3 = 1, x6 = cnt[x3], LLC write accesses
0000003c: addi x3,x3,1
00000040: cnt.rd x5,x3
# x4 = Total LLC accesses
00000044: add x4,x4,x5
# x3 = 2, x7 = cnt[x3], total read response latency
00000048: addi x3,x3,1
0000004c: cnt.rd x7,x3
# x3 = 3, x8 = cnt[x3], total write response latency
00000050: addi x3,x3,1
00000054: cnt.rd x8,x3
# x8 = x7 + x8, total response latency
00000058: add x8,x7,x8
# x9 = x8 / x4, total latency / total requests
0000005c: divu x9,x8,x4
# x9 = 1 if x28 < x9
00000060: sltu x9,x28,x9
# Load 1 into x1.
00000064: addi x1,x0,1
#
# *******************************************************************
# InnerLoop: Access the non-CUA cores' counters.
# *******************************************************************
# Load loop variable.
00000068: addi x2,x2,1
# x3 = x3+1, x10 = cnt[x3], LLC read accesses by non-CUA
0000006c: addi x3,x3,1
00000070: cnt.rd x10,x3
# x3 = x3+1, x11 = cnt[x3], LLC read misses by non-CUA
00000074: addi x3,x3,1
00000078: cnt.rd x11,x3
# x3 = x3+1, x12 = cnt[x3], LLC write accesses
0000007c: addi x3,x3,1
00000080: cnt.rd x12,x3
# x3 = x3+1, x13 = cnt[x3], LLC write misses
00000084: addi x3,x3,1
00000088: cnt.rd x13,x3
# x10 = x10 - x11, LLC read hits by non-CUA
0000008c: sub x10,x10,x11
# x12 = x12 - x13, LLC write hits by non-CUA
00000090: sub x12,x12,x13
#
# Calculate worst-case delay caused.
# x15 = x10 * x23
00000094: mul x15,x10,x23
# x14 = x11 * x24, x15 = x15 + x14
00000098: mul x14,x11,x24
0000009c: add x15,x15,x14
# x14 = x12 * x25, x15 = x15 + x14
000000a0: mul x14,x12,x25
000000a4: add x15,x15,x14
# x14 = x13 * x26, x15 = x15 + x14
000000a8: mul x14,x13,x26
000000ac: add x15,x15,x14
#
# Calculate acceptable delay
000000b0: mul x16,x27,x4
000000b4: sltu x17,x16,x15 
#
# Mask = 1 << Core Number# x6  - 
# x21  = x1 << x2
000000b8: sll x19,x1,x2
# x21 = (x20 & x19) (BitVector & Mask)
000000bc: and x21,x20,x19
# x21 = x21 >> x2
# CoreHalted = (BitVector & Mask) >> Core Number
000000c0: srl x21,x21,x2
#
# Resume core = CoreHalted & (acceptable-delay < WC-delay)
# x22         = x21        & x17
# If 1, go to Resume Function.
000000c4: and x22,x21,x17
000000c8: beq x22,x1,44
#
# Halt core = Regulate & !CoreHalted & (acceptable-delay < WC-delay)
# x22       = x9       & !x21        & x17   
# x21[0] = !x21[0]
# If 1, go to Halt Function. (000000ec)
000000cc: xori x21,x21,1
000000d0: and x22,x9,x21
000000d4: and x22,x22,x17
000000d8: beq x22,x1,20
#
# ****************************************
# Update: Loop Variable and run next epoch
# ****************************************
# If x2 < x31: go to InnerLoop. (00000068)
000000dc: blt x2,x31,-116
000000e0: add x0,x0,x0
# Go to OuterLoop. (00000030)
# This is reset by CVA6. 
000000e4: sw x1,28(x30)
000000e8: beq x0,x0,-184
#
# *************
# Halt Function
# *************
# 00000000: sw x2,0(x29)
000000ec: lw x6,24(x30)
000000f0: or x6,x19,x6
000000f4: sw x6,24(x30)
000000f8: add x0,x0,x0
000000fc: or x20,x20,x19
# Go to Update Function. (000000dc)
00000100: beq x0,x0,-36
# ***************
# Resume Function
# ***************
# 00000000: sw x2,8(x29)
00000104: add x0,x0,x0
00000108: xori x19,x19,-1
0000010c: and x20,x20,x19
# Go to Update Function. (000000dc)
00000110: beq x0,x0,-52
