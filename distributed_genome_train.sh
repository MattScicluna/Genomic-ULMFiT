#!/bin/bash

#  TODO set OMP_NUM_THREADS ??
#  Use lscpu to get number of cpus
export OMP_NUM_THREADS=2

python -m torch.distributed.launch --nproc_per_node=4 distributed_genome_train.py
#nohup python -m torch.distributed.launch --nproc_per_node=4 distributed_genome_train.py &
#nohup python distributed_genome_train.py --no_distributed &

#  find processes to kill
#ps aux | grep genomic_ulmfit | awk '{print $0 $2}'
