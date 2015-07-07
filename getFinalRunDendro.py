#! /usr/bin/python
import os, shutil

os.mkdir("_endRuns")
files = os.listdir(".")
filesDendro = [i for i in files if "dendro" in i]

d = dict()
for file in filesDendro:
	thisFile = file.split("run")
	stem = thisFile[0]
	thisRun = int(thisFile[1].split("dendro")[0])
	if stem in d.keys():
		if thisRun > d[stem]:
			d[stem] = thisRun
	else:
		d[stem] = thisRun
	d[stem] = thisRun
	
for key in d.keys():
	file = key + "run" + str(d[key]) + "dendro-block1.jpg"
	shutil.copy2(file, "_endRuns")
