#!/bin/tcsh
unset noclobber

#* Description: Changes the copied modified beamline's elegant and lattice files, so elegant data can be generated and distinguished based on trial number
#* Argument: $1 - CORRONE - First quadrupole whose strength will be modified
#* Argument: $2 - CORRSTRENGTHONE - Strength to which the first quadrupole will be set to
#* Argument: $3 - CORRTWO - Second quadrupole whose strength will be modified
#* Argument: $4 - CORRSTRENGTHTWO - Strength to which the second quadrupole will be set to
#* Argument: $5 - MODIFIEDBEAMLINE - Name of the beamline which will be modified to include trial number, then used to run Elegant
#* Argument: $6 - TRIAL - Trial identification number
#* Argument: $7 - VERTICLE - Boolean 1 or 0 which represents whether the transformation is verticle or horizontal
#* Example: ppss -f 'elegantFile.ppss' -c "$FPATH/elegantFunction.sh " > /dev/null
#* Further Comments: The script will not run / function properly if the elegantFile.ppss has not been generated. Information about that file is in runPPSSElegant.sh
#* Main Output: $ELEGANTPATH/"centroidValues$TRIAL.dat"

# The arguments passed in are one continuous string, so each variable must be pulled from its corresponding column
set CORRONE = `echo $1 | awk '{print $1}'`
set CORRSTRENGTHONE = `echo $1 | awk '{print $2}'`
set CORRTWO = `echo $1 | awk '{print $3}'`
set CORRSTRENGTHTWO = `echo $1 | awk '{print $4}'`
set MODIFIEDBEAMLINE = `echo $1 | awk '{print $5}'`
set TRIAL = `echo $1 | awk '{print $6}'`
set VERTICLE = `echo $1 | awk '{print $7}'`

# Change the modified lattice file at the given correctors to the given strengths
#* Output: $MODIFIEDBEAMLINE$TRIAL.lte
perl $FPATH/modifyCorrector.pl $RDPATH/$MODIFIEDBEAMLINE.lte $ELEGANTPATH/temp.lte $CORRONE $CORRSTRENGTHONE >& /dev/null
perl $FPATH/modifyCorrector.pl $ELEGANTPATH/temp.lte $ELEGANTPATH/$MODIFIEDBEAMLINE$TRIAL.lte $CORRTWO $CORRSTRENGTHTWO >& /dev/null

# Change the origional modified elegant file to include the trial number, allowing for parallel runs of Elegant
#* Output: $MODIFIEDBEAMLINE$TRIAL.ele
$FPATH/modifyElegant.sh $MODIFIEDBEAMLINE $TRIAL

# Run elegant on the modified data
(cd $ELEGANTPATH; elegant $MODIFIEDBEAMLINE$TRIAL.ele > /dev/null)

# Save the Cx and Cy values to file
sdds2stream -col=s,ElementName,Cx,Cxp,Cy,Cyp "$ELEGANTPATH/$MODIFIEDBEAMLINE$TRIAL.cen" >! $ELEGANTPATH/"centroidValues$TRIAL.dat"
