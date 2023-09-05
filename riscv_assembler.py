import os, sys

'''
    pad_binary('010_1111',12) 
    => '0b0000_0010_1111'

    Output a binary string of length using padding. 
    The output need to slice '0b' out.
'''
def pad_binary(num, length):
    return format(int(num, 2), '#0{}b'.format(length + 2))

def twos_complement (value, bitWidth=32):
    if value >= 2**bitWidth:
        # This catches when someone tries to give a value that is out of range
        raise ValueError('Value: {} out of range of {}-bit value.'.format(value, bitWidth))
    return (2**bitWidth-1) - value + 1

'''
    write_reverse_bin('00000010', 3, 6, '1101') 
    => '01101010'

    Write bin_val into bin. 
    The bits are written in range of the [start_bit, end_bit] (both inclusive). 
    The bit ordering is opposite of Python.

              76543210      
    bin     = 00000010 
    bin_val = 1101

    start   = 3
    end     = 6

              76543210
    op_bin  = 01101010
'''
def write_reverse_bin(bin, start_bit, end_bit, bin_val):
    rbin = list(bin[::-1])
    rbin_val = list(bin_val)[::-1]
    
    i = 0
    for id, bit in enumerate(rbin):
        if (id >= start_bit and id <= end_bit):
            if i < len(rbin_val):    
                rbin[id] = rbin_val[i]
            else:
                rbin[id] = '0'
            i = i+1
    
    nbin = ''.join(rbin[::-1])
    return nbin


def decode(instr, DEBUG=1):
    bin32 = '00000000000000000000000000000000'
    dict_opcodes = {
        'lui':      '0110111',
        'auipc':    '0010111',
        'jal':      '1101111',
        'jalr':     '1100111',
        'beq':      '1100011',
        'bne':      '1100011',
        'blt':      '1100011',
        'bge':      '1100011',
        'bltu':     '1100011',
        'bgeu':     '1100011',
        'lb':       '0000011',
        'lh':       '0000011',
        'lw':       '0000011',
        'lbu':      '0000011',
        'lhu':      '0000011',
        'sb':       '0100011',
        'sh':       '0100011',
        'sw':       '0100011',
        'addi':     '0010011',
        'slti':     '0010011',
        'sltiu':    '0010011',
        'xori':     '0010011',
        'ori':      '0010011',
        'andi':     '0010011',
        'slli':     '0010011',
        'srli':     '0010011',
        'srai':     '0010011',
        'add':      '0110011',
        'sub':      '0110011',
        'sll':      '0110011',
        'slt':      '0110011',
        'sltu':     '0110011',
        'xor':      '0110011',
        'srl':      '0110011',
        'sra':      '0110011',
        'or':       '0110011',
        'and':      '0110011',
        'cnt.rd':   '0000111',
        'cnt.wr':   '0000111',
        'cnt.wfp':  '0000111',
        'cnt.wfo':  '0000111'
    }

    r_funct3 = {
        'add':      '000',
        'sub':      '000',
        'sll':      '001',
        'slt':      '010',
        'sltu':     '011',
        'xor':      '100',
        'srl':      '101',
        'sra':      '101',
        'or':       '110',
        'and':      '111',
        'cnt.wfp':  '010',
        'cnt.wfo':  '010'
    }

    r_funct7 = {
        'add':      '0000000',
        'sub':      '0100000',
        'sll':      '0000000',
        'slt':      '0000000',
        'sltu':     '0000000',
        'xor':      '0000000',
        'srl':      '0000000',
        'sra':      '0100000',
        'or':       '0000000',
        'and':      '0000000',
        'cnt.wfp':  '0000000',
        'cnt.wfo':  '0000001'
    }

    i_funct3 = {
        'addi':      '000',
        'slti':      '010',
        'sltiu':     '011',
        'xori':      '100',
        'ori':       '110',
        'andi':      '111',
        'slli':      '001',
        'srli':      '101',
        'srai':      '101',
        'lb':        '000',
        'lh':        '001',
        'lw':        '010',
        'lbu':       '100',
        'lhu':       '101',
        'cnt.rd':    '000',
        'cnt.wr':    '001'
    }

    i_funct7 = {
        'slli':     '0000000',
        'srli':     '0000000',
        'srai':     '0100000'
    }

    s_funct3 = {
        'sb': '000',
        'sh': '001',
        'sw': '010'
    }

    b_funct3 = {
        'beq':  '000',
        'bne':  '001',
        'blt':  '100',
        'bge':  '101',
        'bltu': '110',
        'bgeu': '111',
    }

    instr_t = {
        'r': ['add', 'sub', 'sll', 'slt', 'sltu', 'xor', 'srl', 'sra', 'or', 'and'],
        'i': ['addi', 'slti', 'sltiu', 'xori', 'ori', 'andi', 'slli', 'srli', 'srai', 
              'lb', 'lh', 'lw', 'lbu', 'lhu', 'jalr', 'cnt.rd', 'cnt.wr'],
        's': ['sb', 'sh', 'sw'],
        'b': ['beq', 'bne', 'blt', 'bge', 'bltu', 'bgeu'],
        'u': ['lui', 'auipc'],
        'j': ['jal']
    }

    XLEN = 32
    instr = instr.lstrip(' ')

    # split out the instruction from the remaining body
    # add x1, x3, x29 ==> ['add', 'x1, x3, x29']
    i_type = str(instr.split(' ', 1)[0])
    i_body = str(instr.split(' ', 1)[1])

    opcode = dict_opcodes[i_type]
    bin32 = write_reverse_bin(bin32, 0, 6, dict_opcodes[i_type])

    # r-type instructions
    if (i_type in instr_t['r']):
        tmp = i_body.split(',')

        rd = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')
        rs2 = str(tmp[2]).replace(' ','')

        rd_int = int(rd[1:])
        rs1_int = int(rs1[1:])
        rs2_int = int(rs2[1:])

        bin32 = write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])

        bin32 = write_reverse_bin(bin32, 12, 14, r_funct3[i_type])
        bin32 = write_reverse_bin(bin32, 25, 31, r_funct7[i_type])

    # load instructions are decoded separately
    elif (i_type in ['lb', 'lh', 'lw', 'lbu', 'lhu']):
        # lw rd, offset(rs1)
        tmp = i_body.split(',')
        rd = str(tmp[0]).replace(' ','')

        tmp = tmp[1].split('(')
        offset = str(tmp[0]).replace(' ','')

        rs1 = str(tmp[1]).replace(' ','')
        rs1 = str(rs1).replace(')','')

        rs1_int = int(rs1[1:])
        rd_int = int(rd[1:])

        if offset[0] in ['+', '-']:
            imm_sign = offset[0]
            imm = int(offset[1:])
            if imm_sign == '-':
                imm = twos_complement(imm)
        else:
            imm = int(offset)

        imm = bin(int(imm))[2:]
        pad_imm = pad_binary(imm, 12)[2:]

        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]

        bin32 = write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = write_reverse_bin(bin32, 12, 14, i_funct3[i_type])
        bin32 = write_reverse_bin(bin32, 20, 31, rpad_imm[::-1])

    # counter read instruction
    elif (i_type in ['cnt.rd']):
        # cnt.ld rd, rs1
        # rd = cnt[rs1]
        # cnt.ld instruction is an I-type instructions where imm[11:0], funct3 = 0
        tmp = i_body.split(',')

        rd = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')
                
        rd_int = int(rd[1:])
        rs1_int = int(rs1[1:])

        imm = '0'
        pad_imm = pad_binary(imm, 12)[2:]

        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]

        bin32 = write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = write_reverse_bin(bin32, 12, 14, i_funct3[i_type])
        bin32 = write_reverse_bin(bin32, 20, 31, rpad_imm[::-1])

    # counter write instruction
    elif (i_type in ['cnt.wr']):
        # cnt.wr rs1, rs2
        # counter[rs1] = rs2
        # cnt.wr instruction is an S-type instruction where imm[11:0] = 0, funct3 = 1
        tmp = i_body.split(',')

        rs1 = str(tmp[0]).replace(' ','')
        rs2 = str(tmp[1]).replace(' ','')
        
        rs1_int = int(rs1[1:])
        rs2_int = int(rs2[1:])        

        imm = '0'
        pad_imm = pad_binary(imm, 12)[2:]

        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]

        bin32 = write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])
        bin32 = write_reverse_bin(bin32, 12, 14, i_funct3[i_type])
        bin32 = write_reverse_bin(bin32, 7, 11, rpad_imm[0:5][::-1])
        bin32 = write_reverse_bin(bin32, 25, 31, rpad_imm[5:12][::-1])

    # counter wfp instruction
    elif (i_type in ['cnt.wfp', 'cnt.wfo']):
        # cnt.wfx rd, rs1, where x = p or o
        # poll the pending / overflow bit of the counters set in rs1
        # cnt.wfp instruction is an R-type instruction where funct7 = 0
        # cnt.wfo instruction is an R-type instruction where funct7 = 1
        tmp = i_body.split(',')

        rd = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')

        rd_int = int(rd[1:])
        rs1_int = int(rs1[1:])
        rs2_int = 00000

        bin32 = write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])

        bin32 = write_reverse_bin(bin32, 12, 14, r_funct3[i_type])
        bin32 = write_reverse_bin(bin32, 25, 31, r_funct7[i_type])

    # all i-type instructions except loads
    elif (i_type in instr_t['i']):
        tmp = i_body.split(',')
        
        rd = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')

        rd_int = int(rd[1:])
        rs1_int = int(rs1[1:])

        bin32 = write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = write_reverse_bin(bin32, 12, 14, i_funct3[i_type])
        
        if i_type in ['slli', 'srli', 'srai']:
            shamt = str(tmp[2]).replace(' ','')
            shamt_int = int(shamt)
            bin32 = write_reverse_bin(bin32, 20, 24, bin(shamt_int)[2:])
            bin32 = write_reverse_bin(bin32, 25, 31, i_funct7[i_type])
        else:
            imm = str(tmp[2]).replace(' ','')
            if imm[0] in ['+', '-']:
                imm_sign = imm[0]
                imm = int(imm[1:])
                if imm_sign == '-':
                    imm = twos_complement(imm)
            imm_int = int(imm)
            bin32 = write_reverse_bin(bin32, 20, 31, bin(imm_int)[2:])

    elif (i_type in instr_t['s']):
        # sw rs2, offset(rs1)
        tmp = i_body.split(',')
        rs2 = str(tmp[0]).replace(' ','')
        tmp = tmp[1].split('(')
        offset = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')
        rs1 = str(rs1).replace(')','')

        rs1_int = int(rs1[1:])
        rs2_int = int(rs2[1:])

        if offset[0] in ['+', '-']:
            imm_sign = offset[0]
            imm = int(offset[1:])
            if imm_sign == '-':
                imm = twos_complement(imm)
        else:
            imm = int(offset)

        imm = bin(int(imm))[2:]
        pad_imm = pad_binary(imm, 12)[2:]
        # immediates bits are reversed to select the correct
        # subset of bits for different sub-fields
        rpad_imm = pad_imm[::-1]

        bin32 = write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])
        bin32 = write_reverse_bin(bin32, 12, 14, s_funct3[i_type])
        # re-reverse the selected subset because the function will 
        # reverse them again
        bin32 = write_reverse_bin(bin32, 7, 11, rpad_imm[0:5][::-1])
        bin32 = write_reverse_bin(bin32, 25, 31, rpad_imm[5:12][::-1])

        if DEBUG:
            print(f"rs1: {rs1} :: rs2: {rs2} :: offset: {offset} :: imm'b: {pad_imm} ({len(pad_imm)}) :: rev_imm'b: {rpad_imm}")

    elif (i_type in instr_t['b']):
        tmp = i_body.split(',')
        rs1 = str(tmp[0]).replace(' ','')
        rs2 = str(tmp[1]).replace(' ','')
        offset = str(tmp[2]).replace(' ', '')

        rs1_int = int(rs1[1:])
        rs2_int = int(rs2[1:])

        if offset[0] in ['+', '-']:
            imm_sign = offset[0]
            imm = int(offset[1:])
            if imm_sign == '-':
                imm = twos_complement(imm)
        else:
            imm = int(offset)

        imm = bin(int(imm))[2:]
        pad_imm = pad_binary(imm, 32)[2:]
        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]

        if DEBUG:
            print(f"rs1: {rs1} :: rs2: {rs2} :: offset: {offset} :: imm'b: {pad_imm} ({len(pad_imm)}) :: rev_imm'b: {rpad_imm}")

        bin32 = write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])
        bin32 = write_reverse_bin(bin32, 12, 14, b_funct3[i_type])

        bin32 = write_reverse_bin(bin32, 7, 7, rpad_imm[11])
        bin32 = write_reverse_bin(bin32, 8, 11, rpad_imm[1:5][::-1])
        bin32 = write_reverse_bin(bin32, 25, 30, rpad_imm[5:11][::-1])
        bin32 = write_reverse_bin(bin32, 31, 31, rpad_imm[12])

    elif (i_type in instr_t['u']):
        tmp = i_body.split(',')
        rd = str(tmp[0]).replace(' ','')
        offset = str(tmp[1]).replace(' ', '')

        rd_int = int(rd[1:])

        if offset[0] in ['+', '-']:
            imm_sign = offset[0]
            imm = int(offset[1:])
            if imm_sign == '-':
                imm = twos_complement(imm)
        else:
            imm = int(offset)
        
        imm = bin(int(imm))[2:]
        pad_imm = pad_binary(imm, 20)[2:]
        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]

        bin32 = write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = write_reverse_bin(bin32, 12, 31, rpad_imm[::-1])

        if DEBUG:
            print(f"rd: {rd} :: offset: {offset} :: imm'b: {pad_imm} ({len(pad_imm)}) :: rev_imm'b: {rpad_imm}")

    elif (i_type in instr_t['j']):
        tmp = i_body.split(',')
        rd = str(tmp[0]).replace(' ','')
        offset = str(tmp[1]).replace(' ', '')

        rd_int = int(rd[1:])

        if offset[0] in ['+', '-']:
            imm_sign = offset[0]
            imm = int(offset[1:])
            if imm_sign == '-':
                imm = twos_complement(imm)
        else:
            imm = int(offset)

        imm = bin(int(imm))[2:]
        pad_imm = pad_binary(imm, 32)[2:]
        # immediates bits are reversed to select the correct
        # subset of bits for different sub-fields
        rpad_imm = pad_imm[::-1]

        bin32 = write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = write_reverse_bin(bin32, 12, 19, rpad_imm[12:20][::-1])
        bin32 = write_reverse_bin(bin32, 20, 20, rpad_imm[11][::-1])
        bin32 = write_reverse_bin(bin32, 21, 30, rpad_imm[1:11][::-1])
        bin32 = write_reverse_bin(bin32, 31, 31, rpad_imm[20][::-1])

        if DEBUG:
            print(f"rd: {rd} :: offset: {offset} :: imm'b: {pad_imm} ({len(pad_imm)}) :: rev_imm'b: {rpad_imm}")

    hex4 = hex(int(bin32, 2))
    return hex4

# for u-type, imm[31:20] = offset and imm[19:0] = 0
# for b/j-type, imm[12:0] = offset ==> user needs to make sure that the offsets are multiples of 2
if __name__ == '__main__':
    cur_path = os.getcwd()
#    filename = 'individual-instructions/ibex-cnt.wfo.d'
    filename = 'individual-instructions/ibex-cnt.wfo.d'

    filepath_read = os.path.join(cur_path, filename)
    
    f_read = open(filepath_read, 'r')
    file_data = f_read.readlines()

    code_mem = []
    map_mem = []
    for line in file_data:
        if (line != '\n') and (line[0] != '#'):
            line_str = str(line).split(':')
            out = decode(line_str[1], DEBUG=False)
            s = f'{line[:-1]}:   \t{out}'            
            print(s)

            code_mem.append(out)
            map_mem.append(s)

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
            f_write.write(',\n')
