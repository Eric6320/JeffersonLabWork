#!/bin/tcsh
unset noclobber
unset COLORS

#* Description:
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

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

if ($GENERATE == 1) then
	$FPATH/cleanUp.sh "change"
endif

@ x = 1
while (`echo "$x $MAXTRIALS" | awk '{if ($1 <= $2) print 1; else print 0;}'` == 1)
	echo "******************************************Starting Trial $x******************************************"
	if ($x != 1) then
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
