#! /usr/bin/python
import sys

with open(sys.argv[1], 'r') as infile:
	with open(sys.argv[1] + '_forR', 'w') as outfile:
		for l in infile:
			#print l
			l = l.split('\t')
			cds = ':'.join(l[:3])
			hit_count = l[3]
			pc_bp = round(float(l[4]), 5)
			avg_lvl = round(float(l[5]), 5)
			
			dist_start = list()
			dist_start_pc = list()
			sense = list()
			nucs = list()
			levels = list()
			cds_len = int(l[2]) - int(l[1])
			#d = 0
			hits = l[6].split(',')
			for h in hits:
				h = h.split(':')
				#d += int(h[12])
				dist_start.append(h[12])
				dist_start_pc.append(str(round((float(h[12]) / cds_len), 5)))
				sense.append(h[13])
				nucs.append(h[9])
				levels.append(h[4])
			
			fstrand = l[7][0]
			ids = l[9].split(',')
			gene = ids[0].split(';')[0].split('"')[1]
						
			p1 = '\t'.join([cds, str(cds_len), fstrand, gene, hit_count, str(pc_bp), str(avg_lvl)])
			p2 = '\t'.join([','.join(dist_start), ','.join(dist_start_pc), ','.join(nucs), ','.join(sense), ','.join(levels)])
			outfile.write(p1 + '\t' + p2 + '\n')