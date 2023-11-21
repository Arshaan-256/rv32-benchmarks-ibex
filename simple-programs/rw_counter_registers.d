# Test PMU core writes to counter bundles in the PMU.
# At the end of the program, it will write 1 to the `DSPM_BASE_ADDR`.
# x1 - Stores PMU base address (`BASE_ADDR`).
#
# x2 - Number of counters (`NUM_COUNTER`).
#
# X3 - Size of `COUNTER_BUNDLE`. This will be 4kB if the counters are 4kB aligned. Otherwise it is 16 bytes.
#
# x4 - Loop variable.
#      It loops from `0` to `NUM_COUNTER-1`, exits at `NUM_COUNTER`.
#      Each counter bundle only has 4 32-bit registers.
# x5 - Loop variable as well. The address of the register currently being written to. 
#      Every new loop iteration, `x6 = x6 + COUNTER_BUNDLE`.
#
# x6 - Value written into every register, `x6 = x6 + x9`.
#
# x7 - Stores DSPM base address (`DSPM_BASE_ADDR`).
#
# x8 - Stores `32'd101` that will be written into `x7` at end of the program.
#
# x9 - Stores `32'd271`. Its multiples will written added to every register.
#      >> Why 271? 
#         Any value with the format XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_0000_XXXX will work. 
#         The bits from 4-7 are event_id_val in EventSelCfg. If they are non-zero then 
#         the counters will start counting.

# <start>
# The first and second instructions must be updated to store PMU counter base address in x1.
80000000:       lui x1,66564
80000004:       addi x1,x1,20
# The third and fourth instructions must be updated to store PMU DSPM address in x7.
80000008:       lui x7,66566
8000000c:       addi x7,x7,0
# The fifth instruction must be updated to store `NUM_COUNTER`.
80000010:       addi x2,x0,4
# The sixth and seventh instruction must be updated to store the size of `COUNTER_BUNDLE` in bytes.
80000014:       lui  x3,0
80000018:       addi x3,x0,16
# The eightth instruction contains the incremental value that is written to each register.
# Set up loop variables. Skip the `PMU_BUNDLE`.
8000001c:       add x4,x0,x0
80000020:       add x5,x1,x0
80000024:       addi x6,x0,271
# Loop starts.
80000028:       sw x6,0(x5)
8000002c:       addi x6,x6,271
80000030:       sw x6,4(x5)
80000034:       addi x6,x6,271
80000038:       sw x6,8(x5)
8000003c:       addi x6,x6,271
80000040:       sw x6,12(x5)
80000044:       addi x6,x6,271
# Update loop variables.
80000048:       addi x4,x4,1
8000004c:       add x5,x5,x3
# Check if `x4 == x2` (`NUM_COUNTER`). If yes, go to end of program. Otherwise, go to <start+0x1c>.
80000050:       bne x4,x2,-40
# Program ends by writing a 101 to the PMU DSPM (`x7`) and then loop forever.
80000054:       addi x8,x0,101
80000058:       sw x8,0(x7)
8000005c:       add x0,x0,x0
80000060:       beq x0,x0,-4