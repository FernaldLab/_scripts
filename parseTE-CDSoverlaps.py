#! /usr/bin/python
import sys

max_distance = 5000
strand_field = 6
q_start = 3
q_end = 4
r_start = 10
r_end = 11

print 'parsing with ' + str(max_distance) + 'bp window size'
with open(sys.argv[1], 'r') as f:
	#print list(f)
	l = list(f)

no_hit = list()
upstream = list()
downstream = list()
overlap = list()

for line in l:
	ls = line.split('\t')
	#print ls
	distance = int(ls[15])
	#print distance
	if distance == -1:
		no_hit.append(line)
	elif distance == 0:
		overlap.append(line)
	elif distance < max_distance:
		strand = ls[strand_field]
		if strand == '+':
			if int(ls[q_end]) < int(ls[r_start]):
				upstream.append(line)
			else:
				downstream.append(line)
		elif strand == '-':
			if int(ls[q_start]) > int(ls[r_end]):
				upstream.append(line)
			else:
				downstream.append(line)
		else:
			print 'INVALID STRAND INFO\n' + line			

big_list = list()
big_list.append(no_hit)
big_list.append(upstream)
big_list.append(downstream)
big_list.append(overlap)
big_list_names = ['no_hit', 'upstream', 'downstream', 'overlap']

print 'writing output...'
for l in range(len(big_list)):
	filename = sys.argv[1] + '.' + big_list_names[l]
	print ' ' + filename
	with open(filename, 'w') as out:
		for line in big_list[l]:
			out.write(line)