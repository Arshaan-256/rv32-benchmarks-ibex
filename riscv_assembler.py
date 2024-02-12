import os, sys
import argparse
from assembler import Assembler

'''
    This function removes any whitespace, tabs from the start of a string.
    It also removes any trailing newlines at the end of a string.
'''
def clean_string(line):
    line_o = line.lstrip(' ')
    line_o = line.lstrip('\t')
    line_o = line.replace('\n', '')
    line_o = line.rstrip('\n')

    return line_o

def first_pass(file_data):
    dict_lbl = dict()
    # This line is a label.
    # .LABEL:
    for idx, line in enumerate(file_data):
        line = clean_string(line)
        # This line is a empty.
        if (len(line) == 0):
            pass
        # This line is a comment.
        elif (line[0] == '#'):
            pass
        # This line is a label.
        elif ((line.find(':') != -1) and (line[0] == '.')):    
            line_str = str(line).split(':')
            dict_lbl[line_str[0]] = line_str[1]
    return dict_lbl

# for u-type, imm[31:20] = offset and imm[19:0] = 0
# for b/j-type, imm[12:0] = offset ==> user needs to make sure that the offsets are multiples of 2
if __name__ == '__main__':
    # Create ArgumentParser object
    parser = argparse.ArgumentParser(description='Description of your script')

    # Define command-line arguments
    parser.add_argument('--mode', help='What mode are you running in: fix or assemble?')

    # Define command-line arguments
    parser.add_argument('--file', help='What is the filename?')

    # Parse the command-line arguments
    args = parser.parse_args()
    mode = args.mode

    # File path
    cur_path = os.getcwd()
    # filename = 'individual-instructions/ibex-cnt.wfo.d'
    filename = 'program.s'
    filepath_read = os.path.join(cur_path, filename)    
    f_read = open(filepath_read, 'r')
    file_data = f_read.readlines()

    if (mode == 'FIX'):
        # Fix addressing in code file.
        # file_data = fix_addressing_in_gcc_output(file_data)
        file_data = Assembler.zero_pass(file_data)

        # Save new code file.
        filename_write = f'{filename}.new'
        filepath_write = os.path.join(cur_path, filename_write)
        print(f'Writing {filename_write}')
        f_write = open(filepath_write, 'w')
        for idx in range(len(file_data)):
            f_write.write(f'{file_data[idx]}\n')
    elif (mode == 'ASSEMBLE'):
        # Assemble code.
        # Run first pass to isolate labels.
        dict_lbl = first_pass(file_data)        
        
        print("Symbol Table:")
        for key in dict_lbl:
            print(f"{key}: {dict_lbl[key]}")

        print("Machine Code:")
        code_mem = []
        map_mem = []
        for line in file_data:
            if (line != '\n') and (line[0] != '#') and (line[0] != '.'):
                line = line.replace('\n', '')
                line_str = str(line).split(':')
                out = Assembler.assemble(addr=line_str[0],instr=line_str[1],sym_table=dict_lbl)                
                s = f'{line}:   \t{out}'
                print(f"{s}")

                code_mem.append(out)
                map_mem.append(s)            
            else:
                line = line[:-1]
                print(f"{line}")
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
