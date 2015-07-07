#! /usr/bin/python
import sys, re

lineCount, covUnder5, ratioNAs, covUnderM, warningLine = 0, 0, 0, 0, 0
with open(sys.argv[1], 'r') as IN:
	with open(sys.argv[1]+'.clean', 'w') as OUT:
		for line in IN:
			if not re.match('^scaffold', line):
				print 'Skipping first line since appears to be header\n'
				continue
			l = line.split('\t')
			ratio, cov, m = l[4], l[5], l[6]
			if float(cov) < 5:
				covUnder5 += 1
				lineCount += 1
				continue
			if str(ratio) == 'NA':
				ratioNAs += 1
				lineCount += 1
				continue
			if float(cov) < int(m):
				if float(ratio) == 1.:
					covUnderM += 1
					lineCount += 1
					cov = m
					l[5] = cov
					OUT.write('\t'.join(l)) 
				else:
					warningLine += 1
					lineCount += 1
					print 'Warning: ' + line
					continue
			else:
				lineCount += 1
				OUT.write(line)
pctRounded = round(float(covUnderM) / float(lineCount) * 100, 2)
pctRemoved = round(float(covUnder5 + ratioNAs + warningLine) / float(lineCount) * 100, 2)
print str(covUnderM) + ' lines had eff_CT_count rounded up to C_count because ratio==1 (' + str(pctRounded) + '%)'
print str(covUnder5 + ratioNAs + warningLine) + ' total lines removed (' + str(pctRemoved) + '%)'
print '  ' + str(covUnder5) + ' because eff_CT_count<5'
print '  ' + str(ratioNAs) + ' because ratio was NA'
print '  ' + str(warningLine) + ' because eff_CT_count<CT_count but ratio!=1\n'