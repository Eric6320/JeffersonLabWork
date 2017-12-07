#!/bin/tcsh
unset noclobber

set CORRONE = $1
set CORRSTRENGTHONE = $2
set CORRTWO = $3
set CORRSTRENGTHTWO = $4
set MODIFIEDBEAMLINE = $5
set TRIAL = $6
set VERTICLE = $7

set ELEGANTPATH = "~/git/JeffersonLabWork/elegantPPSSDir"

perl $FPATH/modifyCorrector.pl $RDPATH/$MODIFIEDBEAMLINE.lte $ELEGANTPATH/temp.lte $CORRONE $CORRSTRENGTHONE #&> /dev/null
perl $FPATH/modifyCorrector.pl $ELEGANTPATH/temp.lte $ELEGANTPATH/$MODIFIEDBEAMLINE$TRIAL.lte $CORRTWO $CORRSTRENGTHTWO #>& /dev/null

# Run elegant on the modified data
elegant "$ELEGANTPATH/$MODIFIEDBEAMLINE$TRIAL.ele" >& /dev/null

# Save the Cx and Cy values to file
sdds2stream -col=s,ElementName,Cx,Cxp,Cy,Cyp "$ELEGANTPATH/$MODIFIEDBEAMLINE$TRIAL.cen" >! "$ELEGANTPATH/centroidValues$TRIAL.dat"
