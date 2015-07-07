#! /usr/bin/python
import sys

def add_CH_cols(Gflip_file, outfile_name):
	outfile = open(outfile_name, "w")
	for line in Gflip_file:
		l = line.split('\t')
		
		if l[6] == "+":
			trp = l[5][2:].strip()
		elif l[6] == "-":
			trp = l[7][2:].strip()
		else:
			print "INVALID STRAND INFO", line
			
		if trp[1] == "G":
			new = "CG"
		elif trp[1] == "N":	
			new = "NNN"	
		elif trp[1] in set(["A","C","T"]):
			if trp[2] == "G":
				new = "CHG"
			elif trp[2] == "N":
				new = "CH"
			else:
				new = "CHH"
		else:
			print "INVALID NUCLEOTIDE", line
		outfile.write(line.strip() + "\t" + trp + "\t" + new + "\n")
	outfile.close()
		
if len(sys.argv) == 1:
	add_CH_cols(sys.stdin, sys.stdin+"_CH")
else:
	with open(sys.argv[1], "r") as f:
		add_CH_cols(f, sys.argv[1]+"_CH")