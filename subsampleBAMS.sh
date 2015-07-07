# cd ~/Documents/tophatOUT
# samtools view -s 0.8 -b ATCACG/accepted_hits.bam > ATCACG/accepted_hits.80percent01.bam
# samtools view -s 0.8 -b ATCACG/accepted_hits.bam > ATCACG/accepted_hits.80percent02.bam
# samtools view -s 0.8 -b ATCACG/accepted_hits.bam > ATCACG/accepted_hits.80percent03.bam
# samtools view -s 0.8 -b ATCACG/accepted_hits.bam > ATCACG/accepted_hits.80percent04.bam
# samtools view -s 0.8 -b ATCACG/accepted_hits.bam > ATCACG/accepted_hits.80percent05.bam
# 
# samtools view -s 0.8 -b CGATGT/accepted_hits.bam > CGATGT/accepted_hits.80percent01.bam
# samtools view -s 0.8 -b CGATGT/accepted_hits.bam > CGATGT/accepted_hits.80percent02.bam
# samtools view -s 0.8 -b CGATGT/accepted_hits.bam > CGATGT/accepted_hits.80percent03.bam
# samtools view -s 0.8 -b CGATGT/accepted_hits.bam > CGATGT/accepted_hits.80percent04.bam
# samtools view -s 0.8 -b CGATGT/accepted_hits.bam > CGATGT/accepted_hits.80percent05.bam
# 
# samtools view -s 0.8 -b TGACCA/accepted_hits.bam > TGACCA/accepted_hits.80percent01.bam
# samtools view -s 0.8 -b TGACCA/accepted_hits.bam > TGACCA/accepted_hits.80percent02.bam
# samtools view -s 0.8 -b TGACCA/accepted_hits.bam > TGACCA/accepted_hits.80percent03.bam
# samtools view -s 0.8 -b TGACCA/accepted_hits.bam > TGACCA/accepted_hits.80percent04.bam
# samtools view -s 0.8 -b TGACCA/accepted_hits.bam > TGACCA/accepted_hits.80percent05.bam

# samtools view -s 0.8 -b TTAGGC/accepted_hits.bam > TTAGGC/accepted_hits.80percent01.bam
# samtools view -s 0.8 -b TTAGGC/accepted_hits.bam > TTAGGC/accepted_hits.80percent02.bam
# samtools view -s 0.8 -b TTAGGC/accepted_hits.bam > TTAGGC/accepted_hits.80percent03.bam
# samtools view -s 0.8 -b TTAGGC/accepted_hits.bam > TTAGGC/accepted_hits.80percent04.bam
# samtools view -s 0.8 -b TTAGGC/accepted_hits.bam > TTAGGC/accepted_hits.80percent05.bam


cd ~/Documents/picard-tools-1.101/picard-tools-1.101/

ls ~/Documents/tophatOUT | grep ^[ACT] | \
awk '
{ 
	for(i=1;i<=5;i++)
	{
		print "java -Xmx2g -jar DownsampleSam.jar INPUT=~/Documents/tophatOUT/"$0"/accepted_hits.bam OUTPUT=~/Documents/tophatOUT/"$0"/accepted_hits.80percent"i".bam RANDOM_SEED=null PROBABILITY=0.8"
	}
}' | bash

cd ~/Documents/tophatOUT

ls | grep ^[ACT] | \
awk '
{ 
	for(i=1;i<=5;i++)
	{
		print "samtools index "$0"/accepted_hits.80percent"i".bam"
	}
}' | bash