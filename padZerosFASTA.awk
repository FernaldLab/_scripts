awk '
{
	if ($1 ~ /^>/) 
	{
		split($1, a, "_")
		n = 4-length(a[2]) 
		zeros = ""
		for(i=1; i<=n; i++) 
			zeros = zeros"0" 
		print a[1] "_" zeros a[2]
	}
	else 
	{
		print
	}
}
' _Burtoni_genome_files/H_burtoni_v1.assembly.fa > _Burtoni_genome_files/H_burtoni_v1.assembly.padded.fa