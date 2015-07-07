#!/bin/bash

## login with email address as password
ftp anonymous@ftp.ncbi.nlm.nih.gov
get \
genomes/Haplochromis_burtoni/RNA/rna.fa.gz \
/Users/burtonigenomics/Documents/_Burtoni_annotations/H_burtoni_rna.fa.gz
quit

cd ~/Documents/_Burtoni_annotations
gunzip H_burtoni_rna.fa.gz
mkdir db

~/Documents/ncbi-blast-2.2.30+/bin/makeblastdb \
-in H_burtoni_rna.fa \
-input_type fasta \
-dbtype nucl \
-out ./db/H_burtoni_rna

~/Documents/ncbi-blast-2.2.30+/bin/makeblastdb \
-in D_rerio_protein.fa \
-input_type fasta \
-dbtype prot \
-out ./db/D_rerio_protein

~/Documents/ncbi-blast-2.2.30+/bin/makeblastdb \
-in D_rerio_rna.fa \
-input_type fasta \
-dbtype nucl \
-out ./db/D_rerio_rna

blastn \
-query test_rna.fa \
-db ./db/H_burtoni_rna \
-out testout1 \
-outfmt 7 \
-max_target_seqs 2

blastx \
-query test_rna.fa \
-db ./db/D_rerio_protein \
-out testoutprot \
-outfmt '7 std' \
-max_target_seqs 2

#################
# combine files from ncbi and ensembl
cp D_rerio_protein.fa D_rerio_protein_combined.fa
cat Danio_rerio.Zv9.pep.all.fa >> D_rerio_protein_combined.fa

~/Documents/ncbi-blast-2.2.30+/bin/makeblastdb \
-in D_rerio_protein_combined.fa \
-input_type fasta \
-dbtype prot \
-out ./db/D_rerio_protein_combined

blastx \
-query test_rna.fa \
-db ./db/D_rerio_protein_combined \
-out testoutprot \
-outfmt '7 std' \
-max_target_seqs 4


############

cat D_rerio_protein.fa O_latipes_protein.fa O_niloticus_protein.fa T_rubripus_protein.fa \
> Drer_Olat_Onil_Trub_protein.fa

~/Documents/ncbi-blast-2.2.30+/bin/makeblastdb \
-in Drer_Olat_Onil_Trub_protein.fa \
-input_type fasta \
-dbtype prot \
-out ./db/Drer_Olat_Onil_Trub_protein


blastx \
-query test_rna.fa \
-db ./db/Drer_Olat_Onil_Trub_protein \
-out testoutprot \
-outfmt '7 std stitle' \
-max_target_seqs 10

blastx \
-query yth_rna.fa \
-db ./db/Drer_Olat_Onil_Trub_protein \
-out testoutprot \
-outfmt '7 std stitle' \
-max_target_seqs 10


cat Danio_rerio.Zv9.pep.all.fa Oreochromis_niloticus.Orenil1.0.pep.all.fa Oryzias_latipes.MEDAKA1.pep.all.fa Takifugu_rubripes.FUGU4.pep.all.fa \
> Drer_Olat_Onil_Trub_ENS_pep.fa

~/Documents/ncbi-blast-2.2.30+/bin/makeblastdb \
-in Drer_Olat_Onil_Trub_ENS_pep.fa \
-input_type fasta \
-dbtype prot \
-out ./db/Drer_Olat_Onil_Trub_ENS_pep

blastx \
-query test_rna.fa \
-db ./db/Drer_Olat_Onil_Trub_ENS_pep \
-out testoutprotENS \
-outfmt '7 std stitle' \
-max_target_seqs 10

###########################

~/Documents/ncbi-blast-2.2.30+/bin/blastx \
-query test_rna.fa \
-db ./db/H_sapiens_protein \
-out testoutprotHS \
-outfmt '7 std stitle' \
-max_target_seqs 10

~/Documents/ncbi-blast-2.2.30+/bin/blastx \
-query test_rna.fa \
-db ./db/Drer_Olat_Onil_Trub_protein \
-out testoutprotFISH \
-outfmt '7 std stitle' \
-max_target_seqs 10

~/Documents/ncbi-blast-2.2.30+/bin/blastx \
-query test_rna.fa \
-db ./db/Drer_Olat_Onil_Trub_ENS_pep \
-out testoutprotFISH_ENS \
-outfmt '7 std stitle' \
-max_target_seqs 10

##############################
date
~/Documents/ncbi-blast-2.2.30+/bin/blastx \
-query H_burtoni_rna.fa \
-db ./db/Drer_Olat_Onil_Trub_protein \
-out H_burtoni_rna_blastx_FISH \
-outfmt '7 std stitle' \
-max_target_seqs 5
date
~/Documents/ncbi-blast-2.2.30+/bin/blastx \
-query H_burtoni_rna.fa \
-db ./db/Drer_Olat_Onil_Trub_ENS_pep \
-out H_burtoni_rna_blastx_FISH_ENS \
-outfmt '7 std stitle' \
-max_target_seqs 2
date

##############################

### actually ran:
~/Documents/ncbi-blast-2.2.30+/bin/blastx \
-query H_burtoni_rna.fa \
-db ./db/Drer_Olat_Onil_Trub_ENS_pep \
-out H_burtoni_rna_blastx_FISH_ENS_top1 \
-outfmt '7 std' \
-max_target_seqs 1

# check output against intput fasta file

# number of total transcripts in blast output
grep "^gi" H_burtoni_rna_blastx_FISH_ENS_top1 | wc -l
# 60394

# number of unique transcripts in blast output
grep "^gi" H_burtoni_rna_blastx_FISH_ENS_top1 | cut -f1 | sort | uniq | wc -l
# 44268

# some transcripts have >1 line in blast output because multiple stretches from same gene
grep "^gi" H_burtoni_rna_blastx_FISH_ENS_top1 | cut -f1 | sort | uniq -c | awk '$1>1' | wc -l
# 6548
grep "^gi" H_burtoni_rna_blastx_FISH_ENS_top1 | cut -f1 | sort | uniq -c | awk '$1>1{print $2}' \
> H_burtoni_rna_blastx_FISH_ENS_top1_multiLineIDs
# get version of blast results for only these transcripts (very slow)
grep -f H_burtoni_rna_blastx_FISH_ENS_top1_multiLineIDs H_burtoni_rna_blastx_FISH_ENS_top1 \
> H_burtoni_rna_blastx_FISH_ENS_top1_multiLine

# number of entries in input fasta file
grep "^>gi" H_burtoni_rna.fa | wc -l
# 44798

# number of unique entries in input fasta file
grep "^>gi" H_burtoni_rna.fa | cut -d " " -f1 | sort | uniq | wc -l
# 44798

# which transcripts from burtoni weren't in blast output?
# get burtoni input IDs
grep "^>gi" H_burtoni_rna.fa | cut -d " " -f1 | cut -c 2- | sort > H_burtoni_rna.fa_IDs
# get ID in blast output
grep "^gi" H_burtoni_rna_blastx_FISH_ENS_top1 | cut -f1 | sort | uniq \
> H_burtoni_rna_blastx_FISH_ENS_top1_IDs
# get IDs only in input
comm -2 -3 H_burtoni_rna.fa_IDs H_burtoni_rna_blastx_FISH_ENS_top1_IDs > H_burtoni_rna.fa_IDs_noHit
grep -f "H_burtoni_rna.fa_IDs_noHit" "H_burtoni_rna.fa" > H_burtoni_rna.fa_IDs_noHit_fullName
# all seem to be misc_RNA, uncharacterized, or partial mRNA


#####

grep ">gi" H_burtoni_rna.fa > H_burtoni_rna.fa_headers

#####
# for reciprocal blast

~/Documents/ncbi-blast-2.2.30+/bin/makeblastdb \
-in H_burtoni_protein.fa \
-input_type fasta \
-dbtype prot \
-out ./db/H_burtoni_protein

# use parseBestHitBlastxResultsWithComments.py and buildFastaFromParsedTopHits.sh
# to generate query file

~/Documents/ncbi-blast-2.2.30+/bin/blastp \
-query Drer_Olat_Onil_Trub_ENS_pep.fa_ForReciprocal_H_burtoni_rna_blastx_FISH_ENS_top1.transcriptsAndHitsByGenes.fa \
-db ./db/H_burtoni_protein \
-out H_burtoni_rna_blastx_FISH_ENS_top1_reciprocalBackFrom_Drer_Olat_Onil_Trub_ENS_pep \
-outfmt '7 std' \
-max_target_seqs 1


# get rid of comments
grep -v "^#" H_burtoni_rna_blastx_FISH_ENS_top1_reciprocalBackFrom_Drer_Olat_Onil_Trub_ENS_pep \
> H_burtoni_rna_blastx_FISH_ENS_top1_reciprocalBackFrom_Drer_Olat_Onil_Trub_ENS_pep_noComments
