#! /usr/bin/python
import sys, numpy

if len(sys.argv) == 3: 
	notify = int(sys.argv[2])
elif len(sys.argv) == 2:
	notify = 1000000
else:
	sys.exit('NEED FILENAME')

with open(sys.argv[1], 'r') as input:
	with open(sys.argv[1] + '.clusters', 'w') as output:
		output.write('cluster\tsize\tmin_lvl\tmax_lvl\tmean_lvl\tpos\tinterval\n')
		lvls = list()
		pos = list()
		cl = 1
		lcount = 0
		for l in input:
			lcount += 1
			if lcount % notify == 0:
				print lcount
			ls = l.split('\t')
			this_cl = int(ls[5])
			this_lvl = float(ls[4])
			this_pos = ':'.join(ls[:3])
			if this_cl == cl:
				lvls.append(this_lvl)
				pos.append(this_pos)
			else:
				clSpan = ':'.join(pos[0].split(':')[:2]) + ':' + pos[len(pos)-1].split(':')[2]
				toWrite = [cl, len(lvls), min(lvls), max(lvls), numpy.mean(lvls), ','.join(pos), clSpan]
				output.write('\t'.join([str(i) for i in toWrite]) + '\n')
				cl = this_cl
				lvls = list()
				pos = list()
				lvls.append(this_lvl)
				pos.append(this_pos)