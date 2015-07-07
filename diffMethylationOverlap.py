#! /usr/bin/python

def readFileAndMakeCoordinateSet(file):
	OUT = set()
	with open(file, 'r') as IN:
		inlist = list(IN)
	for line in inlist:
		coord = line.split('\t')[0] + '_' + line.split('\t')[1]
		OUT.add(coord)
	return OUT
	
def makeSetsAndGetOverlap(filesList):
	sets = []
	for file in filesList:
		sets.append(readFileAndMakeCoordinateSet(file))
	overlap = sets[0]
	for s in range(1, len(sets)-1):
		overlap.add(sets[s] in overlap)
	return overlap
	
def filterFile(file, overlap_set):
	outfile = file + '.overlap'
	with open(file, 'r') as IN:
		inlist = list(IN)
	with open(outfile, 'w') as OUT:
		for line in inlist:
			if line.split('\t')[0] + '_' + line.split('\t')[1] in overlap_set:
				OUT.write(line)
	
def main():
##########BE CAREFUL PROBABLY DOESNT WORK, DOING IN R INSTEAD###########
	files = ['/Volumes/handsfiler$/FishStudies/_methylation/3157_vs_3165.filtered.50percent.significant', '/Volumes/handsfiler$/FishStudies/_methylation/3157_vs_3581.filtered.50percent.significant', '/Volumes/handsfiler$/FishStudies/_methylation/3677_vs_3165.filtered.50percent.significant', '/Volumes/handsfiler$/FishStudies/_methylation/3677_vs_3581.filtered.50percent.significant']
	overlap_set = makeSetsAndGetOverlap(files)
	filterFile(files[1], overlap_set)
	
if __name__ == '__main__':
  main()