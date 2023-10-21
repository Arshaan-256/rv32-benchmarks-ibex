# Write to the debug mode using PMU core.
# x1 - Number of cores in the module.
# x2 - Halt address in Debug Module, 0x100. 
#      Resume address in Debug Module, 0x108.
# x4 - Value written to the Debug Module.
# x5 - Core loop variable.
# x6 - Wait loop target.
# x7 - Wait loop variable.

# <start>
# Send a halt request to core 0.
80000000:       addi x1,x0,4
# Write wait time in `x6`.
80000004:       addi x6,x0,20
# Write Halt address in `x2`.
80000004:       lui x2,0
80000004:       addi x2,x2,512
# Set up the hart ID of the core that is to be halted in Debug Module.
80000008:       addi x4,x0,0
# Initialize core loop variable.
8000000c:       addi x5,x0,0
# Core loop variable: Halt all CVA6s.
80000010:       sw x4,0(x2)
# Increment by 1 to select the next hart. 
80000014:       addi x4,x4,1
80000018:       addi x5,x5,1
# If not all cores have been halted,
# then go to <start+0xc>.
8000001c:       bne x5,x1,-12
# Initialize wait loop variable.
80000020:       add x7,x0,x0
# Wait loop starts.
80000024:       add x0,x0,x0
80000028:       addi x7,x7,1
8000002c:       bne x7,x6,-8
# To resume a core, write to the 0x208 with the hard ID.
80000030:       addi x4,x0,0
# Initialize core loop variable.
80000034:       addi x5,x0,0
# Core loop variable: Resume all CVA6s.
80000038:       sw x4,8(x2)
# Increment by 1 to select the next hart. 
80000014:       addi x4,x4,1
80000040:       addi x5,x5,1
# If not all cores have resumed,
# then go to <start+0xc>.
80000044:       bne x5,x1,-12
# Program ends.
80000048:       add x0,x0,x0
8000004c:       beq x0,x0,-4
