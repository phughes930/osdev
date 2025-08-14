def add_string(src: str, dest: str, sep: str='\n'):
    new = sep.join([dest, src])
    return new

header = '#include <system.h>\n'

file = header

for i in range(32):
    extern = f"extern void isr{i}();"
    file = add_string(extern, file)

file = add_string("\nvoid isrs_install()\n{\n", file)

for i in range(32):
    set_gate = f"\tidt_set_gate(0, (unsigned)isr{i}, 0x08, 0x8E);"
    file = add_string(set_gate, file)

with open("./isrs.c", "w") as file_obj:
    file_obj.write(file)