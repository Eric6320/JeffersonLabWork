#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $BPMTWO $S

# Store variables as command input or defaults
set BPMONE = $1
set BPMTWO = $2
set S = $3

# Reformat ellipseA.dat and ellipseB.dat in a MATLAB readable way - ellipseA.fin ellipseB.fin
formatEllipses.sh $BPMONE $BPMTWO

# Perform SVD and pseduo inverse on the matrixes - ellipseA2.fin
python determineTransformationMatrix.py

echo `cat ellipseC.fin` >! temp.temp
set DETERMINANT = `cat temp.temp | awk '{print ($1*$4 - $2*$3)}'`

echo "$BPMTWO $S `cat ellipseC.fin` Determinant: $DETERMINANT" > "done.dat"
