#!/bin/bash
# Name - rnaseqpipeline_readcounts_starfc.sh
# Author - eliwagnercode
# Usage - Feed 

SECONDS=0

# Change working directory
cd ~/rnaseqpipeline

# STEP 0: Copy or move decompressed fastq files into fastqStagingArea

inputSample=$1

# STEP 1: Run QC
echo "FastQC is running."
fastqc $inputSample -o fastqcResults/
echo "FastQC finished running."
# # Run trimmomatic to trim reads with poor quality; not strictly necessary for soft-clipping
# java -jar Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 12 $inputSample fastqStagingArea/inputSampleTrimmed.fastq TRAILING:10 -phred33
# echo "Trimmomatic finished running!"
# inputSample= "~/rnaseqpipeline/fastqStagingArea/inputFileTrimmed.fastq"
# # Run fastqc on trimmed fastq file(s)
# fastqc $inputSample -o fastqcResults/

# STEP 2: Run STAR alignment; STAR documentation at https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4631051/ and at https://github.com/alexdobin/STAR
# ulimit -n 65535 # Decompressing .gz
echo "STAR read alignment running."
echo "Removing ~/STARtmp"
rm -r ~/STARtmp
echo "."
./star/code/STAR-2.7.10b/bin/Linux_x86_64/STAR \
    --runThreadN 24 \
    --genomeDir ./star/genome/ \
    --sjdbGTFfile ./GCF_015227675.2_mRatBN7.2_genomic.gtf \
    --sjdbOverhang 100 \
    --readFilesIn \
    $inputSample \
    --outFileNamePrefix ./bamFiles/FosPos_S16_ \
    --outSAMtype BAM SortedByCoordinate \
    # --outTmpDir ~/STARtmp \
    # --readFilesCommand zcat # Use for fastq.gz
echo "STAR alignment finished running; BAM file ready for quantification."

# STEP 3: Run featureCounts - Quantification
echo "featureCounts quantifying reads."
featureCounts bamFiles/FosPos_S16_Aligned.sortedByCoord.out.bam \
    -a GRCh38_latest_genomic.gff\
    -o featureCountsResults/count.out \
    -T 24 \
    # -p # paired-end
    

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."