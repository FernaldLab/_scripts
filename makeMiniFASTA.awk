awk '
{
	if ($1 ~ /^>/) 
	{
		line = NR
		print
	}
	else if (NR < line+10)
	{
		print 
	}
	else 
	{
		next
	}
}
' ~/Documents/_Fernald_lab/H_burtoni_v1.assembly.fa > ~/Documents/_Fernald_lab/H_burtoni_v1.assembly.fa.mini