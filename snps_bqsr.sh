cd /Volumes/fishstudies/_gatkbp_backup/tophat

# process files output from /Volumes/fishstudies/_code/snps_bqsr.R

# filter snps with QUAL < 50
ls | grep '^AT\|^TG' | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $6>=50'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDassembly > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDassemblyQ50"}' | bash
ls | grep '^AT\|^TG' | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $6>=50'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDnovel > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDnovelQ50"}' | bash

ls | grep '^CG\|^TT' | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $6>=50'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_Dassembly > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DassemblyQ50"}' | bash
ls | grep '^CG\|^TT' | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $6>=50'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_Dnovel > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DnovelQ50"}' | bash

# make vcf headers for bedtools
ls | awk '{print "echo "$1"; awk '\''/^#/'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcfHEADER"}' | bash

ls | grep '^AT\|^TG' | awk '{print "echo "$1"; cat "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcfHEADER "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDassemblyQ50 > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDassemblyQ50.vcf"}' | bash
ls | grep '^CG\|^TT' | awk '{print "echo "$1"; cat "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcfHEADER "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DassemblyQ50 > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DassemblyQ50.vcf"}'  | bash

ls | grep '^AT\|^TG' | awk '{print "echo "$1"; cat "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcfHEADER "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDnovelQ50 > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDnovelQ50.vcf"}' | bash
ls | grep '^CG\|^TT' | awk '{print "echo "$1"; cat "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcfHEADER "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DnovelQ50 > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DnovelQ50.vcf"}'  | bash

# get overlaps with GTF
ls | grep '^AT\|^TG' | awk '{print "echo "$1"; bedtools intersect -a "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDassemblyQ50.vcf -b ../../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf -wo > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDassemblyQ50.vcf-GTF.hit; echo "$1"; bedtools intersect -a "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDnovelQ50.vcf -b ../../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf -wo > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDnovelQ50.vcf-GTF.hit"}' | bash
ls | grep '^CG\|^TT' | awk '{print "echo "$1"; bedtools intersect -a "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DassemblyQ50.vcf -b ../../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf -wo > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DassemblyQ50.vcf-GTF.hit; echo "$1"; bedtools intersect -a "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DnovelQ50.vcf -b ../../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf -wo > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DnovelQ50.vcf-GTF.hit"}' | bash

# filter out CDS lines
ls | grep '^AT\|^TG' | awk '{print "awk '\''BEGIN{FS=\"\\t\"}$13==\"exon\"'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDnovelQ50.vcf-GTF.hit > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDnovelQ50.vcf-GTF.hitFilt"}' | bash
ls | grep '^AT\|^TG' | awk '{print "awk '\''BEGIN{FS=\"\\t\"}$13==\"exon\"'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDassemblyQ50.vcf-GTF.hit > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_NDassemblyQ50.vcf-GTF.hitFilt"}' | bash

ls | grep '^CG\|^TT' | awk '{print "awk '\''BEGIN{FS=\"\\t\"}$13==\"exon\"'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DnovelQ50.vcf-GTF.hit > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DnovelQ50.vcf-GTF.hitFilt"}' | bash
ls | grep '^CG\|^TT' | awk '{print "awk '\''BEGIN{FS=\"\\t\"}$13==\"exon\"'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DassemblyQ50.vcf-GTF.hit > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf_DassemblyQ50.vcf-GTF.hitFilt"}' | bash

# get stats per interval with bedtools groupby
# make extra column with snp scaffold:position to summarize
cd ATCACG; ls | grep hitFilt$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"}{print $0\"\\t\"$1\":\"$2}'\'' "$1" > "$1"for_groupby"}' | bash
cd ../CGATGT; ls | grep hitFilt$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"}{print $0\"\\t\"$1\":\"$2}'\'' "$1" > "$1"for_groupby"}' | bash
cd ../TGACCA; ls | grep hitFilt$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"}{print $0\"\\t\"$1\":\"$2}'\'' "$1" > "$1"for_groupby"}' | bash
cd ../TTAGGC; ls | grep hitFilt$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"}{print $0\"\\t\"$1\":\"$2}'\'' "$1" > "$1"for_groupby"}' | bash

cd ATCACG
ls | grep for_groupby$ | awk 'BEGIN{FS="\t"}{print "echo "$1"; sort -k11,11 -k14,14 -k15,15 "$1" | bedtools groupby -g 11,14,15 -c 21,21,6,21 -o count,count_distinct,mean,freqdesc > "$1".groupby11_14_15"}' | bash
cd ../CGATGT; ls | grep for_groupby$ | awk 'BEGIN{FS="\t"}{print "echo "$1"; sort -k11,11 -k14,14 -k15,15 "$1" | bedtools groupby -g 11,14,15 -c 21,21,6,21 -o count,count_distinct,mean,freqdesc > "$1".groupby11_14_15"}' | bash
cd ../TGACCA; ls | grep for_groupby$ | awk 'BEGIN{FS="\t"}{print "echo "$1"; sort -k11,11 -k14,14 -k15,15 "$1" | bedtools groupby -g 11,14,15 -c 21,21,6,21 -o count,count_distinct,mean,freqdesc > "$1".groupby11_14_15"}' | bash
cd ../TTAGGC; ls | grep for_groupby$ | awk 'BEGIN{FS="\t"}{print "echo "$1"; sort -k11,11 -k14,14 -k15,15 "$1" | bedtools groupby -g 11,14,15 -c 21,21,6,21 -o count,count_distinct,mean,freqdesc > "$1".groupby11_14_15"}' | bash
