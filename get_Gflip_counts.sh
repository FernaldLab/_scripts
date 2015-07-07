#! /bin/bash
awk 'BEGIN{FS="\t"}
{
	if ($7=="+") {
		print "p:"substr($6,3,2)
		print "p:"substr($6,3,3)
	}
	else if ($7=="-") {
		print "m:"substr($8,3,2)
		print "m:"substr($8,3,3)
	}
	else {
		print "INVALID STRAND INFO: "$0
	}
}
' $1 | \
sort | uniq -c