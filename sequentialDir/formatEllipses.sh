#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $BPMTWO

set BPMONE = $1
set BPMTWO = $2

set FILEONE = "$BPMONE-centroidValues.dat"
set FILETWO = "$BPMTWO-centroidValues.dat"

# Reformat the data in a MATLAB readable way
cat $FILETWO | awk '{print $1"\n"$2}' >! ellipseA.fin
cat $FILEONE | awk '{print $1", "$2", 0, 0\n0, 0, "$1", "$2}' >! ellipseB.fin
#head -n -2 ellipseA.fin > ellipseTemp.fin; mv ellipseTemp.fin ellipseA.fin
#head -n -2 ellipseB.fin > ellipseTemp.fin; mv ellipseTemp.fin ellipseB.fin
