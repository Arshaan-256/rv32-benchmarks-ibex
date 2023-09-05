# This program reads from a counter, checks if the counter value is greater than a threshold.
# If no, then it reads the next counter and then the next, eventually, looping back to counter 0.
# If yes, then it writes a reset value to that counter and resumes polling the rest.

# x1  - Loop variable, stores the number of the counter which is to be read and compared in this iteration.
# x2  - Stores the total number of counters.
# x3  - Stores the threshold of all counters.
#     - The counter is only 30-bit wide and the next bit i.e., the 30th bit is the oveflow bit.
# x4  - The reset value that is written into a counter when it exceeds its threshold
# x5  - Stores the counter value that is read.
# x31 - The output of offending counter is written into x31. It is only over-written when another counter exceeds its threshold

# Specify total number of counter
0000000: addi x2, x0, 4

# Specify threshold for all counters.
0000004: addi x3, x0, 32

# Specify the reset value for the counters.
0000008: addi x4, x0, 7

# Reset output register.
000000c: add x31, x0, x0

# Loop.
0000010: addi x1, x0, 0
# Read counter `x1` value into `x5`.
0000014: cnt.rd x5, x1
# If counter value `x5` > threshold `x2`, reset counter and update output register.
0000018: bge x5, x3, 16
000001c: addi x1, x1, 1
0000020: bne x1, x2, -12
0000024: beq x0, x0, -20

# Reset counter.
0000028: cnt.wr x1, x4
# Update output register.
000002c: add x31, x1, x0
0000030: beq x0, x0, -20
