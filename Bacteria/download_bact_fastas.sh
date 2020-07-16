#!/bin/bash

esearch -db nucleotide -query "txid1499685" | efetch -format fasta > bacillus_andreraoultii.fasta
