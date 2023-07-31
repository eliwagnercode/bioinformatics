#!/bin/bash

SECONDS=0


# # Build directories
mkdir ~/rnaseqpipeline
cd  ~/rnaseqpipeline
mkdir fastqStagingArea \
    fastqcResults \
    star \
    star/code \
    star/genome \
    star/tmp \
    bamFiles \
    featureCountsResults

    
    
# Install fastqc and featureCounts
sudo apt install fastqc subread
# Install trimmomatic
cd ~/rnaseqpipeline
wget https://github.com/usadellab/Trimmomatic/archive/refs/tags/v0.39.tar.gz
tar -xzf v0.39.tar.gz
# Install STAR
cd ~/rnaseqpipeline/star/code
wget https://github.com/alexdobin/STAR/archive/2.7.10b.tar.gz
tar -xzf 2.7.10b.tar.gz
cd ~/rnaseqpipeline

# Download gene annotation file (GTF/GFF3)
cd ~/rnaseqpipeline
wget https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.gff.gz
# Download genome assembly file (FASTA); If no primary assembly available, top level assembly contains no haplotypes.
wget https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.fna.gz
gunzip -dk *.gz

# Generate genome indices with STAR
./star/code/STAR-2.7.10b/bin/Linux_x86_64/STAR \
    --runThreadN 24 --runMode genomeGenerate \
    --genomeDir ./star/genome \
    --genomeFastaFiles ./GRCh38_latest_genomic.fna

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."