#!/bin/bash

# use the current directory
#$ -cwd
#$ -S /bin/bash

# mail this address
#$ -M ahilliar@stanford.edu
# send mail on begin, end, suspend
#$ -m es

# request RAM, not hard-enforced on FarmShare
#$ -l mem_free=8G
#$ -pe pvm 4
# request hrs of runtime, is hard-enforced on FarmShare
#$ -l h_rt=02:00:00

blastx \
-query ../blast/H_burtoni_rna.fa \
-db ../blast/db/Drer_Olat_Onil_Trub_ENS_pep \
-out ../blast/H_burtoni_rna_blastx_Drer_Olat_Onil_Trub_ENS_pep_BARLEY \
-outfmt '7 std stitle' \
-max_target_seqs 2

