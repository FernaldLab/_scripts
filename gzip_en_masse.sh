#!/bin/bash

SUBJECTS="ATCACG CGATGT TGACCA TTAGGC"

for s in $SUBJECTS
	do
		echo $s
		date
		echo "FilteredReads_v8_NoAdapters/"$s"Reads_Filtered_1.fastq"
		gzip "/Users/burtonigenomics/Desktop/Katrina/FilteredReads_v8_NoAdapters/"$s"Reads_Filtered_1.fastq"
		date
		echo "FilteredReads_v8_NoAdapters/"$s"Reads_Filtered_2.fastq"
		gzip "/Users/burtonigenomics/Desktop/Katrina/FilteredReads_v8_NoAdapters/"$s"Reads_Filtered_2.fastq"
		date
		echo "newBowtie/"$s"Reads_Filtered_1.fastq"
		gzip "/Volumes/fishstudies/Katrina/storage/newBowtie/"$s"Reads_Filtered_1.fastq"
		date
		echo "newBowtie/"$s"Reads_Filtered_2.fastq"
		gzip "/Volumes/fishstudies/Katrina/storage/newBowtie/"$s"Reads_Filtered_2.fastq"
	done