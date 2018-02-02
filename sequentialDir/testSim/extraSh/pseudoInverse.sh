#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $BPMTWO $S

# Store variables as command input or defaults
set BPMONE = $1
set BPMTWO = $2
set S = $3

# Reformat ellipseA.dat and ellipseB.dat in a MATLAB readable way - ellipseA.fin ellipseB.fin
./formatEllipses.sh $BPMONE $BPMTWO

# Perform SVD and pseduo inverse on the matrixes - ellipseA2.fin
python determineTransformationMatrix.py

# TODO Depreciated
#./runMatlab.sh determineTransformationMatrix.m #>& /dev/null

echo `cat ellipseC.fin` | awk -v bpm2=$BPMTWO S=$S '{print bpm2" "S" "$1" "$2" "$3" "$4" Determinant: "($1*$4 - $2*$3)}' > "done.dat"
