#! /usr/bin/python

# Takes the output of a GATK indel run, finds the regions with a lot of reads, and saves them to a bed file.

import sys, re

def main():
	inputReport = open(sys.argv[1], 'r')
	outputBed = open(sys.argv[1] + '.bed', 'w')
	intervals = re.findall(r'Not attempting realignment in interval (scaffold_\d+):(\d+)-?(\d*) because there are too many reads.', inputReport.read())
	for interval in intervals:
		outputBed.write(interval[0] + '\t' + interval[1] + '\t')
		if interval[2] == "": outputBed.write(interval[1] + '\tfake_end\t.\n')
		else: outputBed.write(interval[2] + '\treal_end\t.\n')

main()