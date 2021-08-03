import sys

reverse_nuc = {'A':'T', 'T':'A', 'G':'C', 'C':'G', 'N':'N'}

with open(sys.argv[1], 'r') as f:
    text = f.read().splitlines()

sequence = ''
for line in text:
    if line.startswith('>'):
        print(line)
    else:
        sequence += line

for n in reversed(sequence):
    print(reverse_nuc[n], end='')
print('')
