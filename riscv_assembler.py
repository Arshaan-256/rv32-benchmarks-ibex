import os, sys
import argparse
from assembler import Assembler

'''
    This function will update the code with correct addressing.
'''
def fix_addr_in_code(file_data):
    addr = -4
    for idx, line in enumerate(file_data):
        if (line != '\n') and (line[0] != '#'):
            line_str = str(line).split(':')
            
            # This line is a label.
            # $LABEL: 0x00000000
            if (line[0] == '$'):
                # Remove the `0x` from the HEX conversion and zfill it to 8 digits. 
                line_str[1] = hex(addr+4)[2:].zfill(8)
                file_data[idx] = f"{line_str[0]}: {line_str[1]}\n"
            else:
                addr = addr + 4
                # Remove the `0x` from the HEX conversion and zfill it to 8 digits. 
                line_str[0] = hex(addr)[2:].zfill(8)
                file_data[idx] = f"0x{line_str[0]}: {line_str[1]}"

    return file_data

# for u-type, imm[31:20] = offset and imm[19:0] = 0
# for b/j-type, imm[12:0] = offset ==> user needs to make sure that the offsets are multiples of 2
if __name__ == '__main__':
    # Create ArgumentParser object
    parser = argparse.ArgumentParser(description='Description of your script')

    # Define command-line arguments
    parser.add_argument('--mode', help='Fix code addressing or build it?')

    # Parse the command-line arguments
    args = parser.parse_args()
    mode = args.mode

    # File path
    cur_path = os.getcwd()
    # filename = 'individual-instructions/ibex-cnt.wfo.d'
    filename = 'simple-programs/case_study_1a_test.d'
    filepath_read = os.path.join(cur_path, filename)    
    f_read = open(filepath_read, 'r')
    file_data = f_read.readlines()

    if (mode == 'FIX'):
        # Fix addressing in code file.
        file_data = fix_addr_in_code(file_data)

        # Save new code file.
        filename_write = f'{filename[:-1]}new'
        filepath_write = os.path.join(cur_path, filename_write)
        print(f'Writing {filename_write}')
        f_write = open(filepath_write, 'w')
        for idx in range(len(file_data)):
            f_write.write(f'{file_data[idx]}')

    

    
    

    # for key in dict_lbl:
    #     print(f"{key}: {dict_lbl[key]}")

    

    # code_mem = []
    # map_mem = []
    # for line in file_data:
    #     if (line != '\n') and (line[0] != '#'):
    #         line_str = str(line).split(':')
    #         out = Assembler.assemble(line_str[1])
    #         s = f'{line[:-1]}:   \t{out}'            
    #         print(s)

    #         code_mem.append(out)
    #         map_mem.append(s)
    #     else:
    #         line = line[:-1]
    #         print(line)
    #         map_mem.append(line)

    # # Save binary encoding
    # filename_write = f'{filename[:-1]}x'
    # filepath_write = os.path.join(cur_path, filename_write)
    # print(f'{filename_write}')
    # f_write = open(filepath_write, 'w')

    # for idx in range(len(code_mem)):
    #     f_write.write(f'{code_mem[idx]}')
    #     if idx != len(code_mem)-1:
    #         f_write.write(',\n')

    # # Save code to binary mapping
    # filename_write = f'{filename[:-1]}map'
    # filepath_write = os.path.join(cur_path, filename_write)
    # print(f'{filename_write}')
    # f_write = open(filepath_write, 'w')

    # for idx in range(len(map_mem)):
    #     f_write.write(f'{map_mem[idx]}')
    #     if idx != len(map_mem)-1:
    #         f_write.write('\n')
