# bioinformatics
This repository holds Bash scripts for ETL pipelines for RNA-Seq.

sra_download.sh reads SRR numbers from a text file and downloads fastq files with the fastq-dump feature, using the --split-3 flag to convert .sra format to separate .fastq files in cases of paired-end data.

rnaseqpipeline_readcounts_setup.sh creates directories and downloads and installs genomic reference files and packages including FastQC, Trimmomatic, STAR, and Subread.

rnaseqpipeline_readcounts_starfc.sh utilizes genomic reference files to quantify read counts.

Future goals for this project include automating differential gene expression analysis and pathway enrichment analysis.
