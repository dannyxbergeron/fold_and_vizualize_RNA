# fold_and_vizualize_RNA

### Description
A simple Snakemake workflow to generate 2D folding prediction of a RNA
sequence from either ID of a gene, coordinates, or fasta sequences.

The folding prediction is performed by the tool
<a href="https://github.com/LinearFold/LinearPartition">`LinearPartition`</a>,
and the vizalization is generated using the
<a href="https://github.com/ViennaRNA/forgi">`Forgi`</a>
python package.


### Requirements
- Conda
- Snakemake (version >=6.6.1) --> <a href="https://snakemake.readthedocs.io/en/stable/getting_started/installation.html">Installation</a>

### Usage
1- Add the name of the samples that you want to fold and vizualize in the `config/sample.tsv`
Next complete the `config/units.tsv` file by adding the sample names, unit (it could be
anything, it will be added to the sample name for all the generated files), and either
the id of a gene (ENSEMBL id, starting with ENSG) for a small gene like a snoRNA for example,
the coordinates of a region in the format <chr>:<start>-<end>:<strand>
(ex: chr3:186784796-186784961:+), or simply the path of a fasta file
(ex: data/fasta/SNORD2.fa).

2- Activate your Snakemake environnement:
```bash
conda activate <name_of_your_environnement>
```

3- Do a dry run of the Snakemake from the `workflow` directory:
```bash
snakemake --use-conda --cores <number_of_cores> -np
```

4- Run the snakemake from the `workflow` directory:
```bash
snakemake --use-conda --cores <number_of_cores> -np
```

5- Vizualize the results in `results/svgs` directory
