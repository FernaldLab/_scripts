cd ~/Documents/tophatOUT

c_curve -v -o c_curveATCACG.txt -B ATCACG/accepted_hits.bam 2> c_curveATCACGverbose.txt
c_curve -v -o c_curveCGATGT.txt -B CGATGT/accepted_hits.bam 2> c_curveCGATGTverbose.txt
c_curve -v -o c_curveTGACCA.txt -B TGACCA/accepted_hits.bam 2> c_curveTGACCAverbose.txt
c_curve -v -o c_curveTTAGGC.txt -B TTAGGC/accepted_hits.bam 2> c_curveTTAGGCverbose.txt

lc_extrap -v -o lc_extrapATCACG.txt -B ATCACG/accepted_hits.bam 2> lc_extrapATCACGverbose.txt
lc_extrap -v -o lc_extrapCGATGT.txt -B CGATGT/accepted_hits.bam 2> lc_extrapCGATGTverbose.txt
lc_extrap -v -o lc_extrapTGACCA.txt -B TGACCA/accepted_hits.bam 2> lc_extrapTGACCAverbose.txt
lc_extrap -v -o lc_extrapTTAGGC.txt -B TTAGGC/accepted_hits.bam 2> lc_extrapTTAGGCverbose.txt