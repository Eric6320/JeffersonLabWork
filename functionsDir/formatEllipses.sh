#!/bin/tcsh
unset noclobber

#* Description: Formats the centroid values of two BPMs in preparation to perform Singular Value Decomposition Pseudoinverse
#* Argument: $1 - BPMONE - First BPM name
#* Argument: $2 - BPMTWO - Second BPM name
#* Argument: $3 - TRIAL - Trial number
#* Example: formatEllipses.sh IPM1S03 IPM1S05 5
#* Main Output: ellipseA$TRIAL.fin, ellipseB$TRIAL.fin

# Set Variables
set BPMONE = $1
set BPMTWO = $2
set TRIAL = $3

set FILEONE = $CENTROIDPATH/$BPMONE"CentroidValues.dat"
set FILETWO = $CENTROIDPATH/$BPMTWO"CentroidValues.dat"

# Reformat the data in a SVD Pseudoinverse readable way, ellipseA and ellipseB
cat $FILETWO | awk '{print $1"\n"$2}' >! $ELLIPSEPATH/ellipseA$TRIAL.fin
cat $FILEONE | awk '{print $1", "$2", 0, 0\n0, 0, "$1", "$2}' >! $ELLIPSEPATH/ellipseB$TRIAL.fin
