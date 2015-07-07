#! /bin/bash
awk 'BEGIN{FS="\t"}
{
	if ($4=="+") {
		print "p:"substr($12,3,2)
		print "p:"substr($12,3,3)
	}
	else if ($4=="-") {
		print "m:"substr($13,3,2)
		print "m:"substr($13,3,3)
	}
	else {
		print "INVALID STRAND INFO: "$0
	}
}
' $1 | \
sort | uniq -c