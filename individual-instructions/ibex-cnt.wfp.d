# set up wfp for all counters
0000000: addi x1, x0, -1

# start wfp
0000004: cnt.wfp x31, x1

# <incase of overflow>
0000008: or x31, x0, x1
000000c: beq x0, x0, -8

