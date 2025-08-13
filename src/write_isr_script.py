import os


header = '.section .text\n'

def add_string(dest: str, src: str, sep: str='\n'):
    new = sep.join([dest, src])
    return new

out = header

for i in range(32):
    declaration = f".global _isr{i}"
    out = add_string(out, declaration)

    
for i in range(32):
    func = f"_isr{i}:\n\tcli\n\tpushb\t$0\n\tpushb\t${i}\n\tjmp\tisr_common_stub"
    out = add_string(out, func)
    out = add_string(out, '')

with open("./int_desc_python.s", "w") as file:
    file.write(out)

print('file written successfully')