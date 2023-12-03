import os, sys
from assembler import Assembler

# for u-type, imm[31:20] = offset and imm[19:0] = 0
# for b/j-type, imm[12:0] = offset ==> user needs to make sure that the offsets are multiples of 2
if __name__ == '__main__':
    cur_path = os.getcwd()
#    filename = 'individual-instructions/ibex-cnt.wfo.d'
    filename = 'simple-programs/case_study_1.d'

    filepath_read = os.path.join(cur_path, filename)
    
    f_read = open(filepath_read, 'r')
    file_data = f_read.readlines()

    code_mem = []
    map_mem = []
    for line in file_data:
        if (line != '\n') and (line[0] != '#'):
            line_str = str(line).split(':')
            out = Assembler.assemble(line_str[1])
            s = f'{line[:-1]}:   \t{out}'            
            print(s)

            code_mem.append(out)
            map_mem.append(s)
        else:
            line = line[:-1]
            print(line)
            map_mem.append(line)

    # Save binary encoding
    filename_write = f'{filename[:-1]}x'
    filepath_write = os.path.join(cur_path, filename_write)
    print(f'{filename_write}')
    f_write = open(filepath_write, 'w')

    for idx in range(len(code_mem)):
        f_write.write(f'{code_mem[idx]}')
        if idx != len(code_mem)-1:
            f_write.write(',\n')

    # Save code to binary mapping
    filename_write = f'{filename[:-1]}map'
    filepath_write = os.path.join(cur_path, filename_write)
    print(f'{filename_write}')
    f_write = open(filepath_write, 'w')

    for idx in range(len(map_mem)):
        f_write.write(f'{map_mem[idx]}')
        if idx != len(map_mem)-1:
            f_write.write('\n')
