#!/bin/tcsh
unset noclobber
unset COLORS

#* Description: Runs the changeVResponse.sh script some $MAXTRIALS number of times, or until the beamlines chi2dof value is below the given $TOLERANCE
#* Argument: $1 - N - Number of orbits to include in the ellipse generation
#* Argument: $2 - SEED - Seed used for any random number generation throughout the scripts
#* Argument: $3 - CORR1 - The first corrector used to trace out ellipses at BPM1
#* Argument: $4 - CORR2 - The second corrector used to trace out ellipses at BPM2
#* Argument: $5 - BPM1 - The bpm used as a reference point for tracing out the beamline's ellipses
#* Argument: $6 - DESIGNBEAMLINE - Name of the 'perfect' beamline used in chi2dof comparisons
#* Argument: $7 - MODIFIEDBEAMLINE - Name of the 'measured' beamline that contains any errors, used in chi2dof comparisons
#* Argument: $8 - VERTICLE - 0 or 1 boolean value indicating whether the reference for the beamline is vertical or horizontal
#* Argument: $9 - STRENGTHERROR - Percentage strength value change to be applied to the given $TESTQUAD
#* Argument: $10 - TESTQUAD - Quadrupole whos strength will be changed, and the response will be measured
#* Argument: $11 - CHANGEM - Transport matrix element whose chi2dof comparisons will observed
#* Argument: $12 - GENERATE - 0 or 1 boolean value indicating whether or not to generate a new changeVResponse matrix between each trial
#* Argument: $13 - TOLERANCE - CHI2DOF tolerance at which testing stops
#* Argument: $14 - MAXTRIALS - Max number of changeVResponse matrices that will be generated before the minimization is stopped
#* Example: ./correct.sh 8 5 MBT1S01V MBT1S02V IPM1S03 unkicked modified 1 -1 MQB1A29 3 1 3.5 5
#* Further Comments: $GENERATE should almost always be 1, it is usully only 0 for testing 
#* Main Output: CHI2DOF value printed to console indicating whether or not the minimization was sucessful, or reached the maximum number of trials before stopping

# Store base variables as command input or defaults
set N = $1
set SEED = $2
set CORR1 = $3
set CORR2 = $4
set BPM1 = $5
set DESIGNBEAMLINE = $6
set MODIFIEDBEAMLINE = $7
set VERTICLE = $8

# These variables are only referenced if there is optimization needed
set STRENGTHERROR = $9
set TESTQUAD = $10

# Set variables controlling changeVResponse.sh script behavior
set CHANGEM = $11
set GENERATE = $12
set TOLERANCE = $13
set MAXTRIALS = $14
set CORRECTED = 0

# If the $GENERATE variable is set, reset the changeDir/ folder
if ($GENERATE == 1) then
	$FPATH/cleanUp.sh "change"
endif

# Repeatedly generate changeVResponse Matrices and apply their -Q changes until the max trials have been reached, or the CHI2DOF value is below the threshold
@ x = 0
while (`echo "$x $MAXTRIALS" | awk '{if ($1 <= $2) print 1; else print 0;}'` == 1)
	echo "******************************************Starting Trial $x******************************************"
	if ($x != 0) then
		set CORRECTED = 1
	endif

	# Determine the baseline CHI2DOF values against which to compare, then move and rename to standardComparisons.fin in the changeDir directory
	$JPATH/simulate.sh "N=$N, seed=$SEED, corr1=$CORR1, corr2=$CORR2, bpm1=$BPM1, strengthError=$STRENGTHERROR, testQuad=$TESTQUAD, designBeamline=$DESIGNBEAMLINE, modifiedBeamline=$MODIFIEDBEAMLINE, change=1, corrected=$CORRECTED,"
	mv "$CHI2PATH/comparisons.fin" "$CHANGEPATH/standardComparisons.fin"

	# Determine quality of fix, and error point
	set CURRENTSUM = `$FPATH/sumM.sh $CHANGEM "$CHANGEPATH/standardComparisons.fin"`
	echo "Current CHI2DOF total: $CURRENTSUM - Tolerance: $TOLERANCE"

	# If the current CHI2DOF sum is within accepted tolerances, then print the sum and exit
	if (`echo "$CURRENTSUM $TOLERANCE" | awk '{if ($1 < $2) print 1}'` == 1) then
		echo "Final CHI2DOF sum: $CURRENTSUM, Trials required: $x"
		exit
	endif

	# Determine the new changeVResponse matrix and apply quadrupole strength changes
	$FPATH/changeVResponse.sh $N $SEED $CORR1 $CORR2 $BPM1 $STRENGTHERROR $TESTQUAD $DESIGNBEAMLINE $MODIFIEDBEAMLINE $CHANGEM $GENERATE $TOLERANCE $CORRECTED

	@ x += 1
end

# If the current CHI2DOF sum is within accepted tolerances, then print the sum, otherwise report that the minimization was unsucessful
if (`echo "$CURRENTSUM $TOLERANCE" | awk '{if ($1 > $2) print 1}'` == 1) then
	echo "Did not reach Tolerance goal, Current CHI2DOF total: $CURRENTSUM - Tolerance: $TOLERANCE, Trials required: $x"
endif
