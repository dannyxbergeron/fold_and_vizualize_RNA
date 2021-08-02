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
print(samples)


units = pd.read_table(config["units"], dtype=str).set_index(
    ["sample", "unit"], drop=False
)
units.index = units.index.set_levels(
    [i.astype(str) for i in units.index.levels]
)  # enforce str in index
validate(units, schema="../schemas/units.schema.yaml")
print(units)
# units.loc[('SNORD2', '1'), 'coordinates'] = 'test' # TEST !!!
# print(units)


def get_chromosomes():
    chromosomes = [str(x+1) for x in range(22)] + ["X", "Y", "MT"]
    return chromosomes


##### Wildcard constraints #####
wildcard_constraints:
    sample = "|".join(samples.index),
    chr = "|".join(get_chromosomes()),
    tools = "|".join(config['ucsc_tools'])



def get_final_output():
    ucsc_tools = expand("scripts/{tool}", tool=config['ucsc_tools'])
    compiled_LP = "scripts/LinearPartition/bin"
    chrs_2bit = expand("resources/chrom/2bit/{chr}.2bit", chr=get_chromosomes())
    annotation_tsv = "resources/annotation.tsv"
    return [
        ucsc_tools, compiled_LP,
        chrs_2bit, annotation_tsv
    ]
