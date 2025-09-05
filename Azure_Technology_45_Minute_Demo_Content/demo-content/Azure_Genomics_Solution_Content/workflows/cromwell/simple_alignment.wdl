version 1.0
workflow simple_alignment {
  input { File fastq1; File fastq2; String sample_id; String ref_fasta }
  call bwa_mem { input: fastq1=fastq1, fastq2=fastq2, sample_id=sample_id, ref_fasta=ref_fasta }
  output { File bam = bwa_mem.output_bam; File bai = bwa_mem.output_bai }
}
task bwa_mem {
  input { File fastq1; File fastq2; String sample_id; String ref_fasta }
  command <<<
    set -euo pipefail
    bwa mem -t ${runtime_cpu} ${ref_fasta} ${fastq1} ${fastq2} | samtools view -Sb - > ${sample_id}.unsorted.bam
    samtools sort -@ ${runtime_cpu} -o ${sample_id}.bam ${sample_id}.unsorted.bam
    samtools index ${sample_id}.bam
  >>>
  output { File output_bam = "${sample_id}.bam"; File output_bai = "${sample_id}.bam.bai" }
  runtime { cpu: 8 memory: "32 GB" disks: "local-disk 100 HDD" docker: "biocontainers/bwa:v0.7.17_cv1" }
}