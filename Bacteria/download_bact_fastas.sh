#!/bin/bash

# Define a string variable with a value
input="bacterias.txt"
while IFS=" " read -r id file
do
  echo "downloading id = $id into $file"
  #esearch -db nucleotide -query $id | efetch -format fasta > "$file"
done < "$input"
