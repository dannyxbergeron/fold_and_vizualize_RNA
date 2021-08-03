rule download_ucsc_tools:
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

rule compile_LinearPartition:
    output:
        dir = directory("scripts/LinearPartition/bin")
    log:
        "logs/compile_LinearPartition.log",
    cache: True
    shell:
        "cd scripts/LinearPartition/ && make"
