#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process ALIGN {
    input:
    path fastq

    output:
    path "aligned.bam"

    script:
    '''
    bwa mem ref.fa $fastq > aligned.sam
    samtools view -Sb aligned.sam > aligned.bam
    '''
}

workflow {
    take: reads
    main:
      ALIGN(reads)
    emit:
      ALIGN.out
}
