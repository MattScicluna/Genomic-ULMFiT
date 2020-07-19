#!/bin/bash

python -m torch.distributed.launch --nproc_per_node=4 distributed_genome_train.py &
#python distributed_genome_train.py --no_distributed
