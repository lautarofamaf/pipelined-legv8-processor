Instr_Dic = {
    "lsl": {
        "opcode" : "11010011011"
    },
    "lsr": {
        "opcode" : "11010011010"
    },
    "LSL": {
        "opcode" : "11010011011"
    },
    "LSR": {
        "opcode" : "11010011010"
    }
}

def main():
    list_instr = []
    try:
        with open("shift.s","r") as file:
            for new_line in file:
                if not new_line.strip():
                    continue
                line = new_line.replace(","," ")
                line = line.split()
                print(line)

                instr = line[0]
                rm_line = 31
                shamt_line = line[3]
                rn_line = register_number(line[2])
                rd_line = register_number(line[1])

                opcode = Instr_Dic[instr]["opcode"]
                rm = format(int(rm_line),"05b")
                shamt = format(int(shamt_line), "06b")
                rn = format(int(rn_line), "05b")
                rd = format(int(rd_line), "05b")

                instr_binary = opcode + rm + shamt + rn + rd
                instr_assemble = format(int(instr_binary,2),"x")
                list_instr.append(instr_assemble)
        for instr in list_instr:
            print("32'h" + instr + ",")
    except FileNotFoundError:
        print("Error: shift.s not found.")
    except Exception as e:
        print(f"An error occurred: {e}")


def register_number(reg):
    return int(reg[1:])

if __name__ == "__main__":
    main()
