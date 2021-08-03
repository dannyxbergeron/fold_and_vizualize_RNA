rule run_linear_fold:
    input:
        fasta = "results/fasta/{sample_unit}.fa"
    output:
        dot_bracket = "results/dot_bracket/{sample_unit}.fx",
        mfe = "results/mfe/{sample_unit}.txt"
    log:
        "logs/run_linear_fold_{sample_unit}.log",
    shell:
        "cat {input.fasta} "
        "| grep -v '^>' "
        "| tr -d '\n' "
        "| scripts/LinearPartition/linearpartition  -V -M "
        "2> {output.mfe} "
        "| grep -v -e '^$' "
        "> {output.dot_bracket} "
