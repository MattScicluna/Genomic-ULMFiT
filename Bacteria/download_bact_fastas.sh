#!/bin/bash

# Define a string variable with a value
input="bacterias.txt"
while IFS=" " read -r id file
do
  echo "downloading id = $id into $file"
  esearch -db nucleotide -query $id | efetch -format fasta > "/lustre04/scratch/sciclun4/genome_data/genomic_ulmfit/bacterial_genomes/genome_fastas/${file}"
done < "$input"
