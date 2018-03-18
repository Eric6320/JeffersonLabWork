#!/bin/tcsh
unset noclobber

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
set N = `$FPATH/setArg.sh N 10 $argv`
set SEED = `$FPATH/setArg.sh seed 5 $argv`
set CORR1 = `$FPATH/setArg.sh corr1 MBT1S01V $argv`
set CORR2 = `$FPATH/setArg.sh corr2 MBT1S02V $argv`
set BPM1 = `$FPATH/setArg.sh bpm1 IPM1S03 $argv`
set DESIGNBEAMLINE = `$FPATH/setArg.sh designBeamline unkicked $argv`
set MODIFIEDBEAMLINE = `$FPATH/setArg.sh modifiedBeamline modified $argv`
set VERTICLE = `echo $CORR1 | grep -c "V"`

# These variables are only referenced if there is optimization needed
set STRENGTHERROR = `$FPATH/setArg.sh strengthError x $argv`
set TESTQUAD = `$FPATH/setArg.sh testQuad MQB1A29 $argv`
set REFERENCEBPM = `$FPATH/setArg.sh referenceBPM IPM1R02 $argv`

# Set variables controlling changeVResponse.sh script behavior
set CHANGEM = `$FPATH/setArg.sh changeM 3 $argv`
set GENERATE = `$FPATH/setArg.sh generate 0 $argv`
set TOLERANCE = `$FPATH/setArg.sh tolerance 1 $argv`
set CORRECTED = 0

set MONTECARLO = `$FPATH/setArg.sh monteCarlo 0 $argv`



















#TODO set up MONTECARLO framework


























set MAXTRIALS = 20
@ x = 1
while (`echo "$x $MAXTRIALS" | awk '{if ($1 < $2) print 1; else print 0;}'` == 1)
	echo "******************************************Starting Trial $x******************************************"
	if ($x != 1) then
		set CORRECTED = 1
	endif

	# Determine the baseline CHI2DOF values against which to compare, then move and rename to standardComparisons.fin in the changeDir directory
	$JPATH/simulate.sh "N=$N, seed=$SEED, corr1=$CORR1, corr2=$CORR2, bpm1=$BPM1, strengthError=$STRENGTHERROR, designBeamline=$DESIGNBEAMLINE, modifiedBeamline=$MODIFIEDBEAMLINE, change=1, corrected=$CORRECTED,"
	mv "$CHI2PATH/comparisons.fin" "$CHANGEPATH/standardComparisons.fin"

	# Determine quality of fix, and error point
	set CURRENTSUM = `$FPATH/sumM.sh $CHANGEM "$CHANGEPATH/standardComparisons.fin"`
	echo "Current CHI2DOF total: $CURRENTSUM - Tolerance: $TOLERANCE"
	# If the current CHI2DOF sum is within accepted tolerances, then print the sum and exit
	if (`echo "$CURRENTSUM $TOLERANCE" | awk '{if ($1 < $2) print 1}'` == 1) then
		echo "Final CHI2DOF sum: $CURRENTSUM"
		exit
	endif

	$FPATH/changeVResponse.sh $N $SEED $CORR1 $CORR2 $BPM1 $STRENGTHERROR $DESIGNBEAMLINE $MODIFIEDBEAMLINE $CHANGEM $GENERATE $TOLERANCE $CORRECTED

	@ x += 1
end
