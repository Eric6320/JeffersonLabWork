#!/bin/tcsh
unset noclobber

set CORRONE = $1
set CORRSTRENGTHONE = $2
set CORRTWO = $3
set CORRSTRENGTHTWO = $4
set MODIFIEDBEAMLINE = $5
set TRIAL = $6
set VERTICLE = $7

perl modifyCorrector.pl "$MODIFIEDBEAMLINE.lte" temp.lte $CORRONE $CORRSTRENGTHONE >& /dev/null
perl modifyCorrector.pl temp.lte "$MODIFIEDBEAMLINE.lte" $CORRTWO $CORRSTRENGTHTWO >& /dev/null

# Run elegant on the modified data
elegant "$MODIFIEDBEAMLINE.ele" >& /dev/null

# Save the Cx and Cy values to file
sdds2stream -col=s,ElementName,Cx,Cxp,Cy,Cyp "$MODIFIEDBEAMLINE.cen" >! "centroidValues.dat"

touch "done.dat"