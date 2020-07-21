#!/bin/bash

date=2020_07_15
db=/lustre03/project/6009524/shared/covid-19/sqlit_test/consensus/$date/cov19_$date.db
sqlite3 $db "SELECT M.GISAID_id,H.haplotype_id,M.seq_continent,M.seq_country,M.seq_division,M.date,H.HussinName FROM (SELECT GISAID_id,seq_continent,seq_country,date,haplotype_fk,seq_division FROM metadata WHERE haplotype_fk IS NOT NULL) AS M LEFT JOIN (SELECT haplotype_id,HussinName FROM haplotype) AS H ON H.haplotype_id=M.haplotype_fk"  | sed 's/||/|NA|/g' | sed 's/||/|NA|/g' |tr ' ' '_' | tr '|' '\t' > /lustre04/scratch/sciclun4/genome_data/covid_data/covid_metadata.txt

#  Covid strains found?
#  /lustre03/project/6009524/shared/covid-19/GISAID/2020-06-30/Analysis_per_sample/resplit/fasta/allFiles.sorted.minimap2.haploid.flt.merged.noINDELs.allCoveredSamples.fasta
#  I don't know what the below is?
#/lustre03/project/6009524/shared/covid-19/GERP/44species/per_sp/names.txts/per_sp/names.txt

#  Covid consensus sequence
#/lustre03/project/6009524/shared/covid-19/Reference/NCBI/NC_045512.2/sequence.fasta
