rule viz_representation:
    input:
        fx_file = 'data/dot_bracket/SNORD2_Intron_LinearPartition.fx'
    output:
        svg = 'data/svgs/SNORD2_Intron.svg'
    conda:
        'envs/python.yaml'
    script:
        'scripts/viz_RNA_fold.py'
