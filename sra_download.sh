#!/bin/bash
# Author - eliwagnercode
# Usage - Downloads FASTQ files using SRA Toolkit by reading SRR ID numbers from a text file; User provides path to text file in quotes

cd ~/rnaseqpipeline

inputFile=$1
while IFS= read -r line; do
  SECONDS=0
  echo "Downloading $line"
  ./sra/sratoolkit.3.0.6-ubuntu64/bin/fastq-dump --split-3 "$line"
  mv sra/tmp/sra/* sra/downloads
  rm -r sra/tmp/*
  duration=$SECONDS
  echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
done < $inputFile