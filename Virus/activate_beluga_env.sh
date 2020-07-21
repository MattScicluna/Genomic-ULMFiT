#!/bin/bash
module load python/3.7
#module load scipy-stack
module load httpproxy

#virtualenv --no-download /lustre04/scratch/sciclun4/envs/genomic_ulmfit
#python -m ipykernel install --user --name genomic_ulmfit --display-name "Python (genomic_ulmfit)"

source /scratch/envs/genomic_ulmfit/bin/activate
pip install -r ../requirements.txt