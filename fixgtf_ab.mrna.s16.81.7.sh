cd ~/Documents/_Fernald_lab
awk 'BEGIN{FS="\t"}
{
	if (/'\''/) 
	{
		print $1"\t"$2"\t"$3"\t"3007468"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9
	}
	else 
	{
		print
	}
}
' Astatotilapia_burtoni.BROADAB2.gtf > Astatotilapia_burtoni.BROADAB2fix.gtf