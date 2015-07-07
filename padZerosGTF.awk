awk ' BEGIN{FS = "\t"}
{
	split($1, a, "_")
	n = 4-length(a[2]) 
	zeros = ""
	for(i=1; i<=n; i++) 
		zeros = zeros"0" 
	line = a[1] "_" zeros a[2] "\t"
	for(j=2; j<NF; j++)
		line = line $j "\t"
	print line $NF
} ' Astatotilapia_burtoni.BROADAB2.gtf > Astatotilapia_burtoni.BROADAB2.padded.gtf