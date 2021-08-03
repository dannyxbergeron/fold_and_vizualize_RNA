import sys
import os
import pandas as pd

sys.stderr = open(snakemake.log[0], "w")
from snakemake.shell import shell

input_file = snakemake.input.coords
chr_dir = snakemake.params.chr_dir
twoBitToFa = snakemake.params.twoBitToFa_script
rev_complement = snakemake.params.rev_complement_script
current_fa_seq = snakemake.params.already_fa_seq


coords = pd.read_csv(input_file, sep='\t')

for i in coords.index:
    sample = coords.at[i, 'sample']
    unit = coords.at[i, 'unit']
    coord = coords.at[i, 'coordinates']

    chr, bps, strand = coord.split(':')
    start, end = bps.split('-')

    chr = chr.replace('chr', '')

    # gtf to bed conversion
    start = int(start) - 1

    # To reverse the fasta if needed
    rev = '_reverse' if strand == '-' else ''

    chrom_file = os.path.join(chr_dir, f'{chr}.2bit')

    name = f'{sample}_{unit}{rev}.fa'
    cmd = '{} {}:{}:{}-{} results/fasta/{}'.format(twoBitToFa,
                                                   chrom_file,
                                                   chr,
                                                   start,
                                                   end,
                                                   name)
    shell(cmd)

    if rev == '_reverse':
        new_name = f'{sample}_{unit}.fa'
        new_cmd = f'python {rev_complement} results/fasta/{name} > results/fasta/{new_name}'
        shell(new_cmd)
        shell('rm results/fasta/{name}')

# Copy the current fasta to simplify the rest of the pipeline
for i in current_fa_seq.index:
    fa_path = current_fa_seq.at[i, 'fasta']
    sample = current_fa_seq.at[i, 'sample']
    unit = current_fa_seq.at[i, 'unit']
    name = f'{sample}_{unit}.fa'
    cp_cmd = f'cp {fa_path} results/fasta/{name}'
    shell(cp_cmd)
