We downloaded a list of bacterial genomes based on the organisms used here https://github.com/kheyer/Genomic-ULMFiT/blob/master/Bacteria/Bacterial%20Ensemble/Genomic%20Language%20Models/Bacterial%20Ensemble%20LM%200%20Data%20Processing.ipynb
(look at cell 5)

We chose the consensus sequence or representative sequence when available (see here for an example: https://www.ncbi.nlm.nih.gov/genome/?term=Bacillus+andreraoultii)
We chose the specific assembly based on the most recent entry in NCBI which simulteneously had a large size, small number of Scaffolds, and full assembly level.
The selection was somewhat ad-hoc, and Assembly level id is available in `bacterias.txt`.

Note:
'Bacillus sp EGD-AK10.fna' removed because it is no longer in db (was corrupted somehow?)
Could not find 'Streptococcus sp.fna' 'Vibrio sp C7.fna' in NCBI genome database, so left these out.