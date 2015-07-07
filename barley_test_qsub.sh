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
#$ -l h_rt=00:30:00

R --vanilla --no-save < scripts/test_for_qsub.R