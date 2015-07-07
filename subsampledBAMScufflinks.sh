cd ~/Documents/cufflinks-2.1.1.OSX_x86_64
	
#./cufflinks --library-type fr-firststrand -o ../cufflinksOUT/ATCACG -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf ../tophatOUT/ATCACG/accepted_hits.bam


ls ~/Documents/tophatOUT | grep ^[ACT] | \
awk '
{ 
	for(i=1;i<=5;i++)
	{
		print "./cufflinks --library-type fr-firststrand -o ~/Documents/cufflinksOUT/GTF/padded/subsamples/"$0""i" -p 4 -G ~/Documents/Astatotilapia_burtoni.BROADAB2.padded.gtf ~/Documents/tophatOUT/"$0"/accepted_hits.80percent"i".bam"
	}
}' | bash