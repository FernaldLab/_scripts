awk ' {
	if ($1 ~ /^>/) {
		print seq
		seq = ""
		line_num = NR
		print
	}
	else {
		seq = seq$0
	}
} 
END {
	print seq
} ' ../H_burtoni_v1.assembly.fa > ../H_burtoni_v1.assembly.fa.1line.fa