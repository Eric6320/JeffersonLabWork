#!/bin/tcsh
unset noclobber

#* Description: Determines the transformation matrices between the two given BPM
#* Argument: $1 - BPMONE - BPM to use as a reference point for all SVD pseudoinverse transformations
#* Argument: $2 - BPMTWO - BPM to be used as the ending reference point in the SVD pseudoinverse transformation
#* Argument: $3 - S - S coordinate of BPMTWO, used primarily for book keeping
#* Argument: $4 - TRIAL - TRIAL number for parallel bookkeeping
#* Example: ppss -f 'pseudoinverse.ppss' -c "$FPATH/parallelPseudoinverse.sh "
#* Further Comments: The script will not function without the pseudoinverse.ppss script having being generated first, information about this script is in runPPSSPseudoinverse.sh
#* Further Comments: All of the transformation matrix information is stored in the ellipseDir folder
#* Main Output: mValues$TRIAL.dat

# The arguments passed in are one continuous string, so each variable must be pulled from its corresponding column
set BPMONE = `echo $1 | awk '{print $1}'`
set BPMTWO = `echo $1 | awk '{print $2}'`
set S = `echo $1 | awk '{print $3}'`
set TRIAL = `echo $1 | awk '{print $4}'`

# Reformat ellipseA.dat and ellipseB.dat in a MATLAB readable way
#* Output: ellipseA$TRIAL.fin ellipseB$TRIAL.fin
$FPATH/formatEllipses.sh $BPMONE $BPMTWO $TRIAL

# Perform SVD and pseduo inverse on the matrixes
#* Output: ellipseA2$TRIAL.fin
python $FPATH/determineTransformationMatrix.py $TRIAL $ELLIPSEPATH

# Calculate determinant to make sure the calculation was performed correctly, should be ~1
echo `cat $ELLIPSEPATH/ellipseC$TRIAL.fin` >! $ELLIPSEPATH/temp$TRIAL.dat
set DETERMINANT = `cat $ELLIPSEPATH/temp$TRIAL.dat | awk '{print ($1*$4 - $2*$3)}'`

# Format the in the form: $BPMTWO $S M1 M2 M3 M4 Determinant: $DETERMINANT
#* Output: ellipseDir/mValues$TRIAL.dat
echo "$BPMTWO $S `cat $ELLIPSEPATH/ellipseC$TRIAL.fin` Determinant: $DETERMINANT" >! "$ELLIPSEPATH/mValues$TRIAL.dat"
rm $ELLIPSEPATH/ellipse*$TRIAL.fin $ELLIPSEPATH/temp$TRIAL.dat >& /dev/null
