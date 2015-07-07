cd /Users/burtonigenomics/Documents/gatkbp/tophat

cuffdiff --library-type fr-firststrand -p 4 -u --FDR 0.15 \
-b ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa \
-o ../cuffdiff_postRealign_bqsr_fa_FDR.15 \
../../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam \
CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam

# cuffdiff --library-type fr-firststrand -p 4 -u --FDR 0.2 \
# -b ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa \
# -o ../cuffdiff_postRealign_bqsr_fa_FDR.2 \
# ../../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
# ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam \
# CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam