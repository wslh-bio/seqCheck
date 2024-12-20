process SEQTK_SAMPLE {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "staphb/seqtk:1.4"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("subsampled/*.fastq.gz"), emit: reads
    path "versions.yml"                           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    mkdir subsampled
    seqtk sample -s100 ${reads[0]} ${params.subsampleN} | gzip > subsampled/${reads[0]}
    seqtk sample -s100 ${reads[1]} ${params.subsampleN} | gzip > subsampled/${reads[1]}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqtk: \$( seqtk 2>&1 >/dev/null | sed -n -e "s/Version: //g;3p" )
    END_VERSIONS
    """

}