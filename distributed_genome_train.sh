#!/bin/bash

#python -m torch.distributed.launch --nproc_per_node=2 distributed_genome_train.py
nohup python -m torch.distributed.launch --nproc_per_node=4 distributed_genome_train.py &
#nohup python distributed_genome_train.py --no_distributed &

# find processes to kill
#ps aux | grep genomic_ulmfit | awk '{print $0 $2}'
