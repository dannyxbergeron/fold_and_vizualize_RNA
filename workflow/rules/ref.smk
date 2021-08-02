rule get_genome:
    output:
        chr = temp("resources/chrom/fasta/{chr}.fa"),
    log:
        "logs/get_genome_{chr}.log",
    params:
        species = config["ref"]["species"],
        species_capital = config["ref"]["species"].capitalize(),
        build = config["ref"]["build"],
        release = config["ref"]["release"],
    cache: True
    shell:
        "wget --quiet "
        "-O {output.chr}.gz "
        "http://ftp.ensembl.org/pub/release-{params.release}/fasta/"
        "{params.species}/dna/"
        "{params.species_capital}.{params.build}.dna.chromosome.{wildcards.chr}.fa.gz && "
        "gunzip {output.chr}.gz"


rule encode_genome:
    input:
        chr = rules.get_genome.output.chr
    output:
        encoded_chr = "resources/chrom/2bit/{chr}.2bit",
    log:
        "logs/encode_genome_{chr}.log",
    cache: True
    shell:
        "faToTwoBit {input.chr} {output.encoded_chr}"


rule download_gtf:
    output:
        gtf = temp("resources/annotation.gtf")
    log:
        "logs/download_gtf.log",
    params:
        species = config["ref"]["species"],
        species_capital = config["ref"]["species"].capitalize(),
        build = config["ref"]["build"],
        release = config["ref"]["release"],
    cache: True
    shell:
        "wget --quiet "
        "-O {output.gtf}.gz "
        "http://ftp.ensembl.org/pub/release-{params.release}/gtf/"
        "{params.species}/"
        "{params.species_capital}.{params.build}.{params.release}.gtf.gz && "
        "gunzip {output.gtf}.gz"


rule parse_gtf:
    input:
        gtf = rules.download_gtf.output.gtf
    output:
        tsv = "resources/annotation.tsv"
    log:
        "logs/parse_gtf.log",
    params:
        columns = "seqname,start,end,gene_id,gene_name,strand"
    cache: True
    shell:
        "scripts/gtfParser/gtfParser find_parse {input.gtf} "
        "| awk '$3 == \"gene\" || $3 == \"feature\"' "
        "| scripts/colTab/colTab -f IN -c {params.columns} > {output.tsv}"
