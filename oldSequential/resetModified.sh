#!/bin/tcsh

rm unkicked.* >& /dev/null

ced2elegant --zone=ARC1 --lattice_name=unkicked

sed -i 's/n_particles_per_bunch=1/n_particles_per_bunch=1000/' unkicked.ele

./addMatrixOutput.sh unkicked.ele

elegant unkicked.ele

sddsprintout -col='(ElementName,s,R11,R12,R21,R22)' unkicked.mat
