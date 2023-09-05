# This program writes an overflow threshold into all the counters. And then executes the Wait-For-Overflow instruction until one or more counters overflow.
# In which case, it send the overflowed counters to the core, re-writes the threshold in all counters and polls again.

# Note: The threshold is written into all the counters regardless of whether they are to be polled or not.

# x1  - Specifies counters that are to be polled.
# x2  - Stores the total number of counters.
# x3  - Stores the overflow threshold that will be written to all counters.
#     - The counter is only 30-bit wide and the next bit i.e., the 30th bit is the oveflow bit.
# x4  - Loop variable, stores the number of the counter into which the overflow threshold is being written to (see x3).
# x31 - The output of WFO is written into x31.

# Set up WFO for all counters.
0000000: addi x1, x0, -1

# Specify total number of counters.
0000004: addi x2, x0, 4

# Write threshold 32'd16 (0x3FFF_FFEF).
0000008: lui x3, 262144
000000c: addi x3, x3, -17

# Intialize loop variable.
0000010: add x4, x0, x0

# Loop.
0000014: cnt.wr x4, x3
0000018: addi x4, x4, 1
000001c: bne x4, x2, -8

# Start WFO with `x31` as the output register.
0000020: cnt.wfo x31, x1

# Incase of overflow, reset `x31` and re-update all counters
0000024: add x31, x0, x0
0000028: beq x0, x0, -24

