#!/bin/tcsh
unset noclobber
# Arguments: $BEAMLINE #BPM1

set BEAMLINE = $1
set BPM1 = `./setArg.sh bpm1 IPM1S03 $argv`

set ELEGANTFILE = $BEAMLINE.ele

rm $BEAMLINE.* >& /dev/null
ced2elegant --zone=ARC1 --lattice_name=$BEAMLINE
sed -i 's/n_particles_per_bunch=1/n_particles_per_bunch=1000/' $ELEGANTFILE


./addMatrixOutput.sh $ELEGANTFILE $BPM1
elegant $ELEGANTFILE





