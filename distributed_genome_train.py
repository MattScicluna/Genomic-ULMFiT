"""
Trains a genomic language model with distributed data parallel
"""

import os
import argparse

# sets device for model and PyTorch tensors (-1 = CPU)
os.environ["CUDA_VISIBLE_DEVICES"]="0,2,3,4"

from fastai import *
from fastai.text import *
from fastai.distributed import *
from Bio import Seq
from Bio.Seq import Seq
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.SeqFeature import FeatureLocation, CompoundLocation
import networkx as nx

from utils import *


def main(args):

    if not args.no_distributed:
        torch.cuda.set_device(args.local_rank)
        torch.distributed.init_process_group(backend='nccl', init_method='env://')

    path = Path('/mnt/wd_4tb/shared_disk_wd4tb/mattscicluna/data/genomic_ulmfit/bacterial_genomes/')
    df = pd.read_csv(path/'bacterial_data.csv')
    #df = df[:100] # for testing purposes

    # 10% of the data used for validation
    train_df, valid_df = split_data(df, 0.9)

    tok = Tokenizer(GenomicTokenizer, n_cpus=1, pre_rules=[], post_rules=[], special_cases=['xxpad'])

    data = GenomicTextLMDataBunch.from_df(path, train_df, valid_df, bs=800, tokenizer=tok, text_cols=0, label_cols=1)

    # Save model vocabulary - this will be important later
    if args.local_rank == 0:
        np.save(path/'bact_vocab.npy', data.vocab.itos)

    voc = np.load(path/'bact_vocab.npy')
    #voc = data.vocab.itos  # TEMPORARY HACK SO THIS WORKS DISTRIBUTED (usually use above line)
    
    model_vocab = GenomicVocab(voc)

    data = GenomicTextLMDataBunch.from_df(path, train_df, valid_df, bs=800, tokenizer=tok, vocab=model_vocab,
                                  chunksize=80000, text_cols=0, label_cols=1)

    config = dict(emb_sz=400, n_hid=1150, n_layers=3, pad_token=0, qrnn=False, output_p=0.25, 
                              hidden_p=0.1, input_p=0.2, embed_p=0.02, weight_p=0.15, tie_weights=True, out_bias=True)
    drop_mult = 0.25

    learn = get_model_LM(data, drop_mult, config)
    if not args.no_distributed:
        learn = learn.to_distributed(args.local_rank)
    
    # in order to run this, need to add to line 32 of fastai.distributed
    # see here: https://github.com/fastai/fastai/issues/2148
    #if args.local_rank == 0:
    learn.lr_find(num_it=100) # usually 100
    #learn.recorder.plot()

    learn.fit_one_cycle(5, 1e-2, moms=(0.8,0.7))
    
    if args.local_rank == 0:
        learn.save('b1', return_path=True)

    learn.fit_one_cycle(5, 5e-3, moms=(0.8,0.7))
    
    if args.local_rank == 0:
        learn.save('b2', return_path=True)

        learn.save_encoder('b2_enc')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--local_rank", type=int)
    parser.add_argument('--no_distributed', action='store_true', help='do not use distributed training')
    args = parser.parse_args()
    print('local rank: {}'.format(args.local_rank))
    print('no distributed: {}'.format(args.no_distributed))
    main(args)
