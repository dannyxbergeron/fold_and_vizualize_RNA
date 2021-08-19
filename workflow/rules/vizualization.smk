rule viz_representation:
    input:
        fx_file = "results/dot_bracket/{sample_unit}.fx",
        mfe = "results/mfe/{sample_unit}.txt"
    output:
        svg = report(
            "results/svgs/{sample_unit}.svg",
            caption="../report/svgs.rst",
            category="Folding_plots"
        )
    log:
        "logs/viz_representation_{sample_unit}.log",
    conda:
        '../envs/python_forgi.yaml'
    script:
        '../scripts/viz_RNA_fold.py'
