import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("6.6.1")

report: "../report/workflow.rst"


###### Config file and sample sheets #####
configfile: "../config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")


units = pd.read_table(config["units"], dtype=str).set_index(
    ["sample", "unit"], drop=False
)
units.index = units.index.set_levels(
    [i.astype(str) for i in units.index.levels]
)  # enforce str in index
validate(units, schema="../schemas/units.schema.yaml")



def get_chromosomes():
    chromosomes = [str(x+1) for x in range(22)] + ["X", "Y", "MT"]
    return chromosomes


##### Wildcard constraints #####
wildcard_constraints:
    sample = "|".join(samples.index),
    chr = "|".join(get_chromosomes()),
    tools = "|".join(config['ucsc_tools']),
    sample_unit = "|".join([
        f'{sample}_{unit}'
        for sample, unit in units[['sample', 'unit']].values
    ]),



def get_final_output():
    ucsc_tools = expand("scripts/{tool}", tool=config['ucsc_tools'])
    compiled_LP = "scripts/LinearPartition/bin"
    chrs_2bit = expand("resources/chrom/2bit/{chr}.2bit", chr=get_chromosomes())
    annotation_tsv = "resources/annotation.tsv"
    coords = "results/coordinates/coords.tsv"
    fa_seq = expand("results/fasta/{sample_unit}.fa",
                    sample_unit=get_sample_units())
    dot_bracket = expand("results/dot_bracket/{sample_unit}.fx",
                          sample_unit=get_sample_units())
    svg = expand("results/svgs/{sample_unit}.svg",
                          sample_unit=get_sample_units())
    return [
        ucsc_tools, compiled_LP,
        chrs_2bit, annotation_tsv,
        coords, fa_seq, dot_bracket,
        svg
    ]


def get_ids(wildcards):
    units_with_ids = units.loc[~units.gene_id.isnull()][[
        "sample", "unit", "gene_id"
    ]]
    return units_with_ids

def get_current_coords(wildcards):
    units_with_coords = units.loc[~units.coordinates.isnull()][[
        "sample", "unit", "coordinates"
    ]]
    return units_with_coords

def get_sample_units():
    sample_units = [
        f'{sample}_{unit}'
        for sample, unit in units[['sample', 'unit']].values
    ]
    return sample_units

def get_fa_seqs():
    units_already_in_fa = units.loc[~units.fasta.isnull()]
    units_already_in_fa = units_already_in_fa[['sample', 'unit', 'fasta']]
    return units_already_in_fa
