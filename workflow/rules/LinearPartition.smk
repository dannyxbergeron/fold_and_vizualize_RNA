rule run_linear_partition:
    input:
        fasta = "results/fasta/{sample_unit}.fa"
    output:
        dot_bracket = report(
            "results/dot_bracket/{sample_unit}.fx",
            caption="../report/dot_bracket.rst",
            category="Dot_brackets",
        ),
        mfe = report(
            "results/mfe/{sample_unit}.txt",
            caption="../report/mfe.rst",
            category="Mfe",
        )
    log:
        "logs/run_linear_partition_{sample_unit}.log",
    shell:
        "cat {input.fasta} "
        "| grep -v '^>' "
        "| tr -d '\n' "
        "| scripts/LinearPartition/linearpartition  -V -M "
        "2> {output.mfe} "
        "| grep -v -e '^$' "
        "> {output.dot_bracket} "
