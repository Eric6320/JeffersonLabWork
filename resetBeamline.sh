#!/bin/tcsh
unset noclobber

#TODO DONE

set BEAMLINE = $1
set BPM1 = `setArg.sh bpm1 IPM1S03 $argv`

rm $BEAMLINE.* >& /dev/null
ced2elegant --zone=ARC1 --lattice_name=$BEAMLINE
sed -i 's/n_particles_per_bunch=1/n_particles_per_bunch=1000/' "$BEAMLINE.ele"

#javac /a/devuser/erict/workspace/Miscellaneous/src/addMatrixOutput.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ addMatrixOutput "$BEAMLINE.ele" $BPM1

elegant "$BEAMLINE.ele"





