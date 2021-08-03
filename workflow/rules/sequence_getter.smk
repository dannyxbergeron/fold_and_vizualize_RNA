rule get_coordinates_from_id:
    input:
        annotation_tsv = rules.parse_gtf.output.tsv
    output:
        coords = "results/coordinates/coords.tsv"
    params:
        ids = get_ids,
        current_coords = get_current_coords
    conda:
        "../envs/python_forgi.yaml"
    log:
        "logs/get_coordinates_from_id.log",
    script:
        "../scripts/get_coordinates_from_id.py"


rule get_fasta_sequences:
    input:
        coords = rules.get_coordinates_from_id.output.coords,
        chrs = expand("resources/chrom/2bit/{chr}.2bit", chr=get_chromosomes())
    output:
        fa_seq = expand("results/fasta/{sample_unit}.fa",
                        sample_unit=get_sample_units())
    params:
        chr_dir = 'resources/chrom/2bit',
        twoBitToFa_script = 'scripts/twoBitToFa',
        rev_complement_script = 'scripts/reverse_complement.py',
        already_fa_seq = get_fa_seqs()
    conda:
        "../envs/python_forgi.yaml"
    log:
        "logs/get_fasta_sequences.log",
    script:
        "../scripts/get_fasta_sequences.py"
