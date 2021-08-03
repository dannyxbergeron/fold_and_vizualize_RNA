import sys
sys.stderr = open(snakemake.log[0], "w")

import pandas as pd

annotation = pd.read_csv(snakemake.input.annotation_tsv, sep='\t')
ids = snakemake.params.ids
current_coords = snakemake.params.current_coords

id_rows = annotation.loc[annotation.gene_id.isin(ids.gene_id)].copy(deep=True)
id_rows['coordinates'] = 'chr' + id_rows.seqname + \
                         ':' + id_rows.start.map(str) + \
                         '-' + id_rows.end.map(str) + \
                         ':' + id_rows.strand

ids['coordinates'] = ids['gene_id'].map(dict(zip(id_rows.gene_id, id_rows.coordinates)))
ids.drop('gene_id', axis=1, inplace=True)

merge_coords = pd.concat([ids, current_coords])

merge_coords.to_csv(snakemake.output.coords, sep='\t', index=False)
