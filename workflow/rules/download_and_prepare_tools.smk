rule download_ucsc_tools:
    """ Download twoBitToFa and faToTwoBit from UCSC for fasta chromosome
        compression and decompression """
    output:
        faToTwoBit = "scripts/faToTwoBit",
        twoBitToFa = "scripts/twoBitToFa"
    log:
        "logs/download_ucsc_tools.log",
    cache: True
    shell:
        "wget --quiet "
        "-O {output.faToTwoBit} "
        "http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/faToTwoBit && "
        "wget --quiet "
        "-O {output.twoBitToFa} "
        "http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/twoBitToFa && "
        "chmod +x {output.faToTwoBit} && "
        "chmod +x {output.twoBitToFa}"


rule download_LinearPartition:
    """ Download the LinearPartition tool from the repository """
    output:
        dir = directory('scripts/LinearPartition')
    params:
        link = "https://github.com/LinearFold/LinearPartition.git"
    log:
        "logs/download_LinearPartition.log"
    cache: True
    shell:
        "cd scripts && git clone {params.link}"


rule compile_LinearPartition:
    """ Compile LinearPartition to make an executable """
    output:
        dir = directory("scripts/LinearPartition/bin")
    log:
        "logs/compile_LinearPartition.log",
    cache: True
    shell:
        "cd scripts/LinearPartition/ && make"
