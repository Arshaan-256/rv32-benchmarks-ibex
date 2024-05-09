# To do: add support for hex offset, right now all offsets must be input as decimal.
# Add support for function calls. Function calls have labels as FUNCT_LABEL and not .FUNCT_LABEL.
# The assembler cannot work with that as of now.
class Assembler:
    DEBUG = False

    reg_name = {
        'zero': 'x0',
        'ra':   'x1',
        'sp':   'x2',
        'gp':   'x3',
        'tp':   'x4',
        't0':   'x5',
        't1':   'x6',
        't2':   'x7',
        's0':   'x8',
        'fp':   'x8',
        's1':   'x9',
        'a0':   'x10',
        'a1':   'x11',
        'a2':   'x12',
        'a3':   'x13',
        'a4':   'x14',
        'a5':   'x15',
        'a6':   'x16',
        'a7':   'x17',
        's2':   'x18',
        's3':   'x19',
        's4':   'x20',
        's5':   'x21',
        's6':   'x22',
        's7':   'x23',
        's8':   'x24',
        's9':   'x25',
        's10':  'x26',
        's11':  'x27',
        't3':   'x28',
        't4':   'x29',
        't5':   'x30',
        't6':   'x31'
    }

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
        # multiply
        'mul':      '0110011',
        'mulhu':    '0110011',
        'mulhsu':   '0110011',
        'div':      '0110011',
        'divu':     '0110011',
        'rem':      '0110011',
        'remu':     '0110011',        
        # counter-operations
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
        # mulitply
        'mul':      '000',
        'mulhu':    '011',
        'mulhsu':   '010',
        'div':      '100',
        'divu':     '101',
        'rem':      '110',
        'remu':     '111',
        # counter-operations
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
        # mulitply
        'mul':      '0000001',
        'mulhu':    '0000001',
        'mulhsu':   '0000001',
        'div':      '0000001',
        'divu':     '0000001',
        'rem':      '0000001',
        'remu':     '0000001',
        # counter-operations
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
        'r': ['add', 'sub', 'sll', 'slt', 'sltu', 'xor', 'srl', 'sra', 'or', 'and', 
              'mul', 'mulhu', 'mulhsu', 'div', 'divu', 'rem', 'remu'],
        'i': ['addi', 'slti', 'sltiu', 'xori', 'ori', 'andi', 'slli', 'srli', 'srai', 
              'lb', 'lh', 'lw', 'lbu', 'lhu', 'jalr', 'cnt.rd', 'cnt.wr', 'cnt.wfp', 'cnt.wfo'],
        's': ['sb', 'sh', 'sw'],
        'b': ['beq', 'bne', 'blt', 'bge', 'bltu', 'bgeu'],
        'u': ['lui', 'auipc'],
        'j': ['jal'],
        'pseudo': ['li', 'mv', 'ble', 'bgt', 'bgtu', 'bleu', 'seqz', 'sgtu', 'j']
    }

    XLEN = 32

    def __init__(self):
        return

    '''
        This function removes any whitespace, tabs from the start of a string.
        It also removes any trailing newlines at the end of a string.
    '''
    @classmethod
    def clean_string(cls, line):
        line = line.lstrip(' ')
        line = line.lstrip('\t')
        line = line.lstrip('\n')
        line = line.rstrip('\n')

        return line

    '''
        Split out the instruction from the remaining body.
        E.g. add x1,x3,x29 ==> ['add', 'x1,x3,x29']

        This function does not verify the correctness of the instruction.
    '''
    @classmethod
    def split_instr(cls, instr):
        instr_type = str(instr.split(' ', 1)[0])
        instr_type = cls.clean_string(instr_type)

        instr_body = str(instr.split(' ', 1)[1])
        instr_body = cls.clean_string(instr_body)

        return [instr_type, instr_body]

    '''
        pad_binary('010_1111',12) 
        => '0b0000_0010_1111'

        Output a binary string of length using padding. 
        The output need to slice '0b' out.
    '''
    @classmethod
    def pad_binary(cls, num, length):
        return format(int(num, 2), '#0{}b'.format(length + 2))

    @classmethod
    def twos_complement (cls, value, bitWidth=32):
        if value >= 2**bitWidth:
            # This catches when someone tries to give a value that is out of range
            raise ValueError('Value: {} out of range of {}-bit value.'.format(value, bitWidth))
        return (2**bitWidth-1) - value + 1

    '''
        write_reverse_bin('00000010', 3, 6, '1101') 
        => '01101010'

        Write bin_val into bin. 
        The bits are written in range of the [start_bit, end_bit] (both inclusive). 
        
        The bit ordering is opposite of Python. Python represents binary as string, and binary is
        indexed left-to-right, with the 0th index bit representing the MSB. Binary encoding is indexed 
        right-to-left, with the 0th index bit representing the LSB.

        The RISC-V instruction format uses the binary encoding, so when it says bits 0-6 are opcode bits,
        it means the lowest 7 bits are opcode bits. But according to Python, 0-6 bits are the upper 7 bits.
        This is why this function is needed.

        Example 1.
        bits      76543210      
        bin     = 00000010 
        bin_val = 1101

        start   = 3
        end     = 6

                  76543210
        out_bin = 01101010

        Example 2.
        bits      76543210      
        bin     = 00000000 
        bin_val = 1011

        start   = 3
        end     = 6

                  76543210
        out_bin = 01011000
    '''
    @classmethod
    def write_reverse_bin(cls, bin, start_bit, end_bit, bin_val):
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

    '''
        This method returns the decimal offset after parsing them.
        If the offset was negative then it returns its decimal two's complement.
    '''
    @classmethod
    def parse_offset(cls, offset):
        # Check if the number has an explicit sign, + or -.        
        if (offset[0] in ['+', '-']):
            imm_sign = offset[0]
            imm      = int(offset[1:])
            # If the offset is negative get two's complement.
            if imm_sign == '-':
                imm = cls.twos_complement(imm)
        else:
            imm = int(offset)

        return imm


    @classmethod
    def r_type(cls, instr_type, instr_body, bin32):
        tmp = instr_body.split(',')

        rd  = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')
        rs2 = str(tmp[2]).replace(' ','')

        if rd[0] != 'x':
            rd  = cls.reg_name[rd]
        
        if rs1[0] != 'x':
            rs1 = cls.reg_name[rs1]

        if rs2[0] != 'x':
            rs2 = cls.reg_name[rs2]

        rd_int  = int(rd[1:])
        rs1_int = int(rs1[1:])
        rs2_int = int(rs2[1:])

        bin32 = cls.write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])

        bin32 = cls.write_reverse_bin(bin32, 12, 14, cls.r_funct3[instr_type])
        bin32 = cls.write_reverse_bin(bin32, 25, 31, cls.r_funct7[instr_type])
        return bin32

    @classmethod
    def i_type_load(cls, instr_type, instr_body, bin32):
        # lw rd, offset(rs1)
        tmp = instr_body.split(',')
        rd  = str(tmp[0]).replace(' ','')

        tmp    = tmp[1].split('(')
        offset = str(tmp[0]).replace(' ','')

        rs1 = str(tmp[1]).replace(' ','')
        rs1 = str(rs1).replace(')','')

        if rd[0] != 'x':
            rd  = cls.reg_name[rd]
        
        if rs1[0] != 'x':
            rs1 = cls.reg_name[rs1]

        rd_int  = int(rd[1:])
        rs1_int = int(rs1[1:])

        imm_int = cls.parse_offset(offset)
        imm_bin = bin(int(imm_int))[2:]
        pad_imm = cls.pad_binary(imm_bin, 12)[2:]

        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again.
        rpad_imm = pad_imm[::-1]

        bin32 = cls.write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 14, cls.i_funct3[instr_type])
        bin32 = cls.write_reverse_bin(bin32, 20, 31, rpad_imm[::-1])
        return bin32

    # counter read instruction
    @classmethod
    def i_type_cnt_rd(cls, instr_type, instr_body, bin32):
        # cnt.ld rd, rs1
        # rd = cnt[rs1]
        # cnt.ld instruction is an I-type instructions where imm[11:0], funct3 = 0
        tmp = instr_body.split(',')        

        rd = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')
                
        if rd[0] != 'x':            
            print(f"{rd}: {cls.reg_name[rd]}")
            rd  = cls.reg_name[rd]            
        
        if rs1[0] != 'x':
            rs1 = cls.reg_name[rs1]
        
        rd_int = int(rd[1:])
        rs1_int = int(rs1[1:])

        imm = '0'
        pad_imm = cls.pad_binary(imm, 12)[2:]

        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]

        bin32 = cls.write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 14, cls.i_funct3[instr_type])
        bin32 = cls.write_reverse_bin(bin32, 20, 31, rpad_imm[::-1])
        return bin32

    # counter write instruction
    @classmethod
    def i_type_cnt_wr(cls, instr_type, instr_body, bin32):
        # cnt.wr rs1, rs2
        # counter[rs1] = rs2
        # cnt.wr instruction is an S-type instruction where imm[11:0] = 0, funct3 = 1
        tmp = instr_body.split(',')

        rs1 = str(tmp[0]).replace(' ','')
        rs2 = str(tmp[1]).replace(' ','')

        if rs1[0] != 'x':
            rs1 = cls.reg_name[rs1]

        if rs2[0] != 'x':
            rs2 = cls.reg_name[rs2]
        
        rs1_int = int(rs1[1:])
        rs2_int = int(rs2[1:])

        imm = '0'
        pad_imm = cls.pad_binary(imm, 12)[2:]

        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]

        bin32 = cls.write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 14, cls.i_funct3[instr_type])
        bin32 = cls.write_reverse_bin(bin32, 7, 11, rpad_imm[0:5][::-1])
        bin32 = cls.write_reverse_bin(bin32, 25, 31, rpad_imm[5:12][::-1])
        return bin32

    # counter wfx instruction
    @classmethod
    def i_type_cnt_wfx(cls, instr_type, instr_body, bin32):
        # cnt.wfx rd, rs1, where x = p or o
        # poll the pending / overflow bit of the counters set in rs1
        # cnt.wfp instruction is an R-type instruction where funct7 = 0
        # cnt.wfo instruction is an R-type instruction where funct7 = 1
        tmp = instr_body.split(',')

        rd  = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')

        if rd[0] != 'x':
            rd  = cls.reg_name[rd]
        
        if rs1[0] != 'x':
            rs1 = cls.reg_name[rs1]

        rd_int  = int(rd[1:])
        rs1_int = int(rs1[1:])
        rs2_int = 00000

        bin32 = cls.write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 14, cls.r_funct3[instr_type])
        bin32 = cls.write_reverse_bin(bin32, 25, 31, cls.r_funct7[instr_type])
        return bin32

    # `jalr`, `addi`, `slti`, `sltiu`, `ori`, `andi`, `slli`, `srli`, `srai`.
    @classmethod
    def i_type_all_else(cls, instr_type, instr_body, bin32):
        tmp = instr_body.split(',')
        
        rd  = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')
        
        if rd[0] != 'x':
            rd  = cls.reg_name[rd]
        
        if rs1[0] != 'x':
            rs1 = cls.reg_name[rs1]

        rd_int = int(rd[1:])
        rs1_int = int(rs1[1:])

        bin32 = cls.write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 14, cls.i_funct3[instr_type])
        
        if instr_type in ['slli', 'srli', 'srai']:
            shamt     = str(tmp[2]).replace(' ','')
            shamt_int = int(shamt)
            bin32 = cls.write_reverse_bin(bin32, 20, 24, bin(shamt_int)[2:])
            bin32 = cls.write_reverse_bin(bin32, 25, 31, cls.i_funct7[instr_type])
        else:
            offset  = str(tmp[2]).replace(' ','')
            imm_int = cls.parse_offset(offset)
            imm_bin = bin(imm_int)[2:]
            bin32   = cls.write_reverse_bin(bin32, 20, 31, imm_bin)
        return bin32

    @classmethod 
    def i_type(cls, instr_type, instr_body, bin32):
        if (instr_type in ['lb', 'lh', 'lw', 'lbu', 'lhu']):
            bin32 = cls.i_type_load(instr_type, instr_body, bin32)
        # counter read instruction
        elif (instr_type in ['cnt.rd']):
            bin32 = cls.i_type_cnt_rd(instr_type, instr_body, bin32)
        # counter write instructionQ
        elif (instr_type in ['cnt.wr']):
            bin32 = cls.i_type_cnt_wr(instr_type, instr_body, bin32)
        # counter wfp instruction
        elif (instr_type in ['cnt.wfp', 'cnt.wfo']):
            bin32 = cls.i_type_cnt_wfx(instr_type, instr_body, bin32)
        # all i-type instructions except loads and pmu-specific ones
        elif (instr_type in cls.instr_t['i']):
            bin32 = cls.i_type_all_else(instr_type, instr_body, bin32)        
        return bin32

    @classmethod
    def s_type(cls, instr_type, instr_body, bin32):
        # sw rs2, offset(rs1)
        tmp = instr_body.split(',')
        rs2 = str(tmp[0]).replace(' ','')
        tmp = tmp[1].split('(')
        offset = str(tmp[0]).replace(' ','')
        rs1 = str(tmp[1]).replace(' ','')
        rs1 = str(rs1).replace(')','')

        if rs1[0] != 'x':
            rs1 = cls.reg_name[rs1]

        if rs2[0] != 'x':
            rs2 = cls.reg_name[rs2]

        rs1_int = int(rs1[1:])
        rs2_int = int(rs2[1:])

        imm_int = cls.parse_offset(offset)
        imm_bin = bin(int(imm_int))[2:]
        pad_imm = cls.pad_binary(imm_bin, 12)[2:]
        
        # immediates bits are reversed to select the correct
        # subset of bits for different sub-fields
        rpad_imm = pad_imm[::-1]

        bin32 = cls.write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 14, cls.s_funct3[instr_type])
        # re-reverse the selected subset because the function will 
        # reverse them again
        bin32 = cls.write_reverse_bin(bin32, 7, 11, rpad_imm[0:5][::-1])
        bin32 = cls.write_reverse_bin(bin32, 25, 31, rpad_imm[5:12][::-1])

        if cls.DEBUG:
            print(f"rs1: {rs1} :: rs2: {rs2} :: offset: {offset} :: imm'b: {pad_imm} ({len(pad_imm)}) :: rev_imm'b: {rpad_imm}")
        return bin32

    @classmethod
    def b_type(cls, addr, instr_type, instr_body, bin32, sym_table):
        tmp = instr_body.split(',')
        rs1 = str(tmp[0]).replace(' ','')
        rs2 = str(tmp[1]).replace(' ','')
        offset = str(tmp[2]).replace(' ', '')

        if rs1[0] != 'x':
            rs1 = cls.reg_name[rs1]

        if rs2[0] != 'x':
            rs2 = cls.reg_name[rs2]

        rs1_int = int(rs1[1:])
        rs2_int = int(rs2[1:])

        # If this is a .LABEL then use `sym_table`.
        if (offset[0] in '.'):
            # Remove .LABEL:
            target_addr = sym_table[offset][2:]
            offset = int(target_addr,16) - int(addr[2:],16)                    
            if offset < 0:
                imm_int = cls.twos_complement(offset*-1)
            else:
                imm_int = int(offset)
        # Otherwise, the offset is specified as `34`, `+12`, or `-20`.
        else:
            imm_int = cls.parse_offset(offset)

        imm_bin = bin(int(imm_int))[2:]
        # The offsets are 13-bit values with the 0th bit being always set to 0, 
        # 12 bits are explicitly written in the machine code, the one bit (the 0th bit)
        # is ommitted. All branch offsets are multiple of 2.
        pad_imm = cls.pad_binary(imm_bin, 12+1)[2:]
        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]
        print(rpad_imm)

        if cls.DEBUG:
            print(f"rs1: {rs1} :: rs2: {rs2} :: offset: {offset} :: imm'b: {pad_imm} ({len(pad_imm)}) :: rev_imm'b: {rpad_imm}")

        bin32 = cls.write_reverse_bin(bin32, 15, 19, bin(rs1_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 20, 24, bin(rs2_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 14, cls.b_funct3[instr_type])

        bin32 = cls.write_reverse_bin(bin32, 7, 7, rpad_imm[11])
        bin32 = cls.write_reverse_bin(bin32, 8, 11, rpad_imm[1:5][::-1])
        bin32 = cls.write_reverse_bin(bin32, 25, 30, rpad_imm[5:11][::-1])
        bin32 = cls.write_reverse_bin(bin32, 31, 31, rpad_imm[12])
        return bin32

    @classmethod
    def u_type(cls, instr_type, instr_body, bin32):
        tmp = instr_body.split(',')
        rd  = str(tmp[0]).replace(' ','')
        offset = str(tmp[1]).replace(' ', '')

        if rd[0] != 'x':
            rd = cls.reg_name[rd]

        rd_int = int(rd[1:])
    
        imm_int = cls.parse_offset(offset)
        imm_bin = bin(int(imm_int))[2:]
        pad_imm = cls.pad_binary(imm_bin, 20)[2:]

        # immediates bits are reversed to select the correct subset of bits for different sub-fields,
        # after selecting the correct sub-fields, the imm fields are reversed again
        rpad_imm = pad_imm[::-1]

        bin32 = cls.write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 31, rpad_imm[::-1])

        if cls.DEBUG:
            print(f"rd: {rd} :: offset: {offset} :: imm'b: {pad_imm} ({len(pad_imm)}) :: rev_imm'b: {rpad_imm}")
        return bin32

    @classmethod
    def j_type(cls, addr, instr_type, instr_body, bin32, sym_table):
        tmp = instr_body.split(',')
        rd  = str(tmp[0]).replace(' ','')
        offset = str(tmp[1]).replace(' ', '')

        if rd[0] != 'x':
            rd = cls.reg_name[rd]

        rd_int = int(rd[1:])

        # If this is a .LABEL then use `sym_table`.
        if (offset[0] in '.'):
            # Remove .LABEL:
            target_addr = sym_table[offset][2:]
            offset = int(target_addr,16) - int(addr[2:],16)                    
            if offset < 0:
                imm_int = cls.twos_complement(offset*-1)
            else:
                imm_int = int(offset)
        # Otherwise, the offset is specified as `34`, `+12`, or `-20`.
        else:
            imm_int = cls.parse_offset(offset)

        imm_bin = bin(int(imm_int))[2:]
        # The offsets are 21-bit values with the 0th bit being always set to 0, 
        # 20 bits are explicitly written in the machine code, the one bit (the 0th bit)
        # is ommitted. All branch offsets are multiple of 2.
        pad_imm = cls.pad_binary(imm_bin, 21)[2:]

        # immediates bits are reversed to select the correct
        # subset of bits for different sub-fields
        rpad_imm = pad_imm[::-1]

        bin32 = cls.write_reverse_bin(bin32, 7, 11, bin(rd_int)[2:])
        bin32 = cls.write_reverse_bin(bin32, 12, 19, rpad_imm[12:20][::-1])
        bin32 = cls.write_reverse_bin(bin32, 20, 20, rpad_imm[11][::-1])
        bin32 = cls.write_reverse_bin(bin32, 21, 30, rpad_imm[1:11][::-1])
        bin32 = cls.write_reverse_bin(bin32, 31, 31, rpad_imm[20][::-1])

        if cls.DEBUG:
            print(f"rd: {rd} :: offset: {offset} :: imm'b: {pad_imm} ({len(pad_imm)}) :: rev_imm'b: {rpad_imm}")
        return bin32

    @classmethod
    def replace_pseudo(cls, instr):
        instr_type, instr_body = cls.split_instr(instr)

        # li rd, imm        
        if (instr_type == 'li'):
            # Split all components of the instruction.
            tmp     = instr_body.split(',')
            rd      = str(tmp[0]).replace(' ','')
            offset  = str(tmp[1]).replace(' ','')    

            # N-bits can represents any signed number in [-2^{n-1}, 2^{n-1}-1].
            # `addi` can be used to set upto 12 bits of a register.
            # The immediate range is [-2048, 2047].            
            offset = int(offset)

            # Check if offset can be loaded directly using `addi`, 
            # if offset is between [-2048,2047] then yes.
            # x in range(a,b) means a <= x < b.
            if (offset not in range(-2048,2048)):              
                # If no, then use lui and addi combination.
                # lui will load the upper 20-bits, addi will load the lower 12-bits.

                # li-offset = { lui-offset      , addi-offset       }
                #           = { li-offset >> 12 , li=offset & 0xFFF }
                # 32-bits   = { 20-bits         , 12-bits           }

                # If MSB of the addi-offset is 1 then +1 to lui-offset.
                # Else don't.
                lui_offset  = (offset >> 12)
                addi_offset = (offset & 0xFFF)
                if (offset & 0x800 == 0x800):
                    lui_offset = lui_offset + 1       

                instr_type = 'lui'
                instr_body = f"{rd},{lui_offset}"                
                instr_1    = f"{instr_type} {instr_body}"

                # If there is no offset for addi, then skip it.
                if (addi_offset == 0):
                    return [1, instr_1]

                instr_type = 'addi'
                instr_body = f"{rd},x0,{addi_offset}"
                instr_2    = f"{instr_type} {instr_body}"

                return [2, instr_1, instr_2]
            else:
                # 
                instr_type = 'addi'
                instr_body = f"{rd},x0,{offset}"
                instr      = f"{instr_type} {instr_body}"
                return [1, instr]

        # mv rd,rs1
        # Same as: addi rd,rs1,0
        elif (instr_type == 'mv'):
            # Split all components of the instruction.
            tmp = instr_body.split(',')
            rd  = str(tmp[0]).replace(' ','')
            rs1 = str(tmp[1]).replace(' ','')

            instr_type = 'addi'
            instr_body = f'{rd},{rs1},0'
            instr      = f"{instr_type} {instr_body}"
            return [1, instr]

        # ble rs1,rs2,offset
        # Same as: bge rs2,rs1,offset
        elif (instr_type == 'ble'):
            # Split all components of the instruction.
            tmp = instr_body.split(',')
            rs1 = str(tmp[0]).replace(' ','')
            rs2 = str(tmp[1]).replace(' ','')
            offset = str(tmp[2]).replace(' ', '') 

            # ble rs1,rs2,label => if (rs1 =< rs2) then jump
            # bge rs2,rs1,label => if (rs2 >= rs1) then jump
            instr_type = 'bge'
            instr_body = f'{rs2},{rs1},{offset}'
            instr      = f"{instr_type} {instr_body}"
            return [1, instr]

        # bgt rs1,rs2,offset
        # Same as: blt rs2,rs1,offset
        elif (instr_type == 'bgt'):
            # Split all components of the instruction.
            tmp = instr_body.split(',')
            rs1 = str(tmp[0]).replace(' ','')
            rs2 = str(tmp[1]).replace(' ','')
            offset = str(tmp[2]).replace(' ', '')           
            
            instr_type = 'blt'
            instr_body = f'{rs2},{rs1},{offset}'
            instr      = f"{instr_type} {instr_body}"
            return [1, instr]

        # bgtu rs1,rs2,offset
        # Same as: bltu rs2,rs1,offset
        elif (instr_type == 'bgtu'):
            # Split all components of the instruction.
            tmp = instr_body.split(',')
            rs1 = str(tmp[0]).replace(' ','')
            rs2 = str(tmp[1]).replace(' ','')
            offset = str(tmp[2]).replace(' ', '')           
            
            instr_type = 'bltu'
            instr_body = f'{rs2},{rs1},{offset}'
            instr      = f"{instr_type} {instr_body}"
            return [1, instr]

        # bleu rs1,rs2,offset
        # Same as: bgeu rs2,rs1,offset
        elif (instr_type == 'bleu'):
            # Split all components of the instruction.
            tmp = instr_body.split(',')
            rs1 = str(tmp[0]).replace(' ','')
            rs2 = str(tmp[1]).replace(' ','')
            offset = str(tmp[2]).replace(' ', '')           
            
            instr_type = 'bgeu'
            instr_body = f'{rs2},{rs1},{offset}'
            instr      = f"{instr_type} {instr_body}"
            return [1, instr]

        # seqz rd,rs1
        # Same as: sltiu rd,rs,1
        elif (instr_type == 'seqz'):
            # Split all components of the instruction.
            tmp = instr_body.split(',')
            rd = str(tmp[0]).replace(' ','')
            rs1 = str(tmp[1]).replace(' ','')

            instr_type = 'sltiu'
            instr_body = f'{rd},{rs1},1'
            instr      = f"{instr_type} {instr_body}"
            return [1, instr]

        # sgtu rd,rs1,rs2
        # Same as: sltu rd,rs2,rs1
        elif (instr_type == 'sgtu'):
            # Split all components of the instruction.
            tmp = instr_body.split(',')
            rd  = str(tmp[0]).replace(' ','')
            rs1 = str(tmp[1]).replace(' ','')
            rs2 = str(tmp[2]).replace(' ','')

            instr_type = 'sltu'
            instr_body = f'{rd},{rs2},{rs1}'
            instr      = f"{instr_type} {instr_body}"
            return [1, instr]
        
        # j offset        
        elif (instr_type == 'j'):
            # Split all components of the instruction.
            tmp = instr_body.split(',')            
            offset = str(tmp[0]).replace(' ', '')

            instr_type = 'jal'
            instr_body = f'x0,{offset}'
            instr      = f"{instr_type} {instr_body}"
            return [1, instr]
        
        else:
            print("Hey buddy! You know pseudo-instructions have meaning, right?")
            raise Exception(f'What the hell is {instr_type}?')
    
    @classmethod
    # `addr` should be in HEX-format as `0x00000000`.
    def assemble(cls, addr, instr, sym_table):
        bin32 = '00000000000000000000000000000000'

        # Remove all starting and trailing whitespaces, tabs, and newlines.
        instr = cls.clean_string(instr)

        instr_type, instr_body = cls.split_instr(instr)
        opcode = cls.dict_opcodes[instr_type]
        bin32  = cls.write_reverse_bin(bin32, 0, 6, cls.dict_opcodes[instr_type])

        # r-type instructions
        if (instr_type in cls.instr_t['r']):
            bin32 = cls.r_type(instr_type, instr_body, bin32)
        # i-type instructions
        elif (instr_type in cls.instr_t['i']):
            bin32 = cls.i_type(instr_type, instr_body, bin32)
        # s-type (store) instructions
        elif (instr_type in cls.instr_t['s']):
            bin32 = cls.s_type(instr_type, instr_body, bin32)
        # b-type (branch) instructions
        elif (instr_type in cls.instr_t['b']):
            bin32 = cls.b_type(addr, instr_type, instr_body, bin32, sym_table)
        # u-type instructions
        elif (instr_type in cls.instr_t['u']):
            bin32 = cls.u_type(instr_type, instr_body, bin32)
        # j-type instructions
        elif (instr_type in cls.instr_t['j']):
            bin32 = cls.j_type(addr, instr_type, instr_body, bin32, sym_table)
        else:
            print('I see you like inventing new instructions as well.')
            raise Exception(f'What the hell is {instr_type}?')

        # 32-bits are converted into 4-digit Hexadecimal number.
        hex4 = hex(int(bin32, 2))
        return hex4

    '''
        This function will update the code with correct addressing.
        It will also replace all pseudo-instructions with actual RISC-V instructions.
    '''
    @classmethod
    def zero_pass(cls, file_data, DEBUG=0):
        if (file_data[0] == "#ZERO_PASS_COMPLETED\n"):
            raise Exception("Cannot run zero-pass twice!")
        addr = 0
        file_data_o = list()

        # Indicates that the file has already completed zero_pass.
        file_data_o.append("#ZERO_PASS_COMPLETED")
        for idx, line in enumerate(file_data):
            line = cls.clean_string(line)
            if (line == '') or (line[0] == '#'):
                # This line is either empty or a comment.
                out = line
            elif (line[0] != '#'):
                # This line is either a label or a function lable.
                # .LABEL:
                # FUNCT_LABEL:
                if ((line.find(':')) != -1):
                    zfill_addr = hex(addr)[2:].zfill(8)
                    zfill_addr = '0x' + zfill_addr
                    if (line[0] == '.'):
                        # Ignoring the ':' at end of `line`.
                        out = f"\n{line[:-1]}:{zfill_addr}"
                    else:
                        # Ignoring the ':' at end of `line`.
                        out = f"\n.{line[:-1]}:{zfill_addr}"

                # This line is a RISC-V instruction.
                # GCC output has instructions of the format: addi\tx1,x0,x2.
                # Replace tabs with whitespace.
                else:                                    
                    instr      = line.replace('\t',' ')
                    # Now, get rid of all trailing and starting whitespaces, tabs, newlines.
                    instr      = cls.clean_string(instr)                                        
                    instr_type, instr_body = cls.split_instr(instr)
                    
                    # If pseudo-isntruction then replace it with actual RISC-V instruction.
                    # Comment the original pseudo-instruction for debugging.    
                    if (instr_type in cls.instr_t['pseudo']):
                        out = f"# {instr}"
                        tmp = cls.replace_pseudo(instr)

                        for i in range(tmp[0]):
                            zfill_addr = hex(addr)[2:].zfill(8)
                            out       += f"\n0x{zfill_addr}:\t{tmp[i+1]}"
                            addr       = addr + 4

                    else:
                        zfill_addr = hex(addr)[2:].zfill(8)
                        out        = f"0x{zfill_addr}:\t{instr}"
                        addr       = addr + 4

            # if (DEBUG > 1):
            print(out)
            file_data_o.append(out)
        return file_data_o

    '''
        Generate a symbol table by processing over the code.
        This symbol table is used to calculate branch and jump offsets during the second pass.
    '''
    @classmethod
    def first_pass(cls, program):
        dict_lbl = dict()
        # The following line is a label.
        # .LABEL:
        for idx, line in enumerate(program):
            line_o = cls.clean_string(line)
            # This line is a empty.
            if (len(line_o) == 0):
                pass
            # This line is a comment.
            elif (line_o[0] == '#'):
                pass
            # This line is a label.
            elif (line_o[0] == '.'):
                if (line.find(':')):
                    raise Exception("Label found without addressing information.")
                line_str = str(line_o).split(':')
                dict_lbl[line_str[0]] = line_str[1]
        return dict_lbl

    @classmethod 
    def second_pass(cls):
        pass