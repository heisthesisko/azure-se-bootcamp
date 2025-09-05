
params.reads = "$baseDir/data/*_{R1,R2}.fastq.gz"
params.index = "/data/indexes/hg38"
params.gtf   = "/data/gtf/hg38.gtf"
params.outdir = "results"

process QC {
  tag "$sample_id"; cpus 2; memory '4 GB'; publishDir "${params.outdir}/qc", mode: 'copy'
  input: tuple val(sample_id), path(reads)
  script: """
  fastqc -t ${task.cpus} ${reads}
  """
}
process ALIGN {
  tag "$sample_id"; cpus 8; memory '32 GB'; publishDir "${params.outdir}/bam", mode: 'copy'
  input: tuple val(sample_id), path(read1), path(read2)
  script: """
  hisat2 -p ${task.cpus} -x ${params.index} -1 ${read1} -2 ${read2} | samtools view -Sb - > ${sample_id}.unsorted.bam
  samtools sort -@ ${task.cpus} -o ${sample_id}.bam ${sample_id}.unsorted.bam
  samtools index ${sample_id}.bam
  """
}
process COUNT {
  tag "$sample_id"; cpus 4; memory '8 GB'; publishDir "${params.outdir}/counts", mode: 'copy'
  input: tuple val(sample_id), path(bam)
  script: """
  featureCounts -T ${task.cpus} -a ${params.gtf} -o ${sample_id}.counts.txt ${bam}
  """
}
workflow {
  Channel.fromFilePairs(params.reads, flat: true)
    .map { sample, reads -> tuple(sample.replaceAll(/_R[12].fastq.gz/,'') , reads) }
    .set { readpairs }
  qc_out = readpairs.into { a; b }
  QC(a)
  aligned = b.map { sid, reads -> tuple(sid, reads[0], reads[1]) } | ALIGN
  aligned.map { sid, bam -> tuple(sid, bam) } | COUNT
}
