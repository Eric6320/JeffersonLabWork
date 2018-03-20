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

# Set variables controlling changeVResponse.sh script behavior
set CHANGEM = `$FPATH/setArg.sh changeM 3 $argv`
set GENERATE = `$FPATH/setArg.sh generate 0 $argv`
set TOLERANCE = `$FPATH/setArg.sh tolerance 1 $argv`
set MAXTRIALS = `$FPATH/setArg.sh maxTrials 5 $argv`

set MONTECARLO = `$FPATH/setArg.sh monteCarlo x $argv`

#TODO POSSIBLY GET RID OF THE GENERATE VARIABLE COMPLETELY ONCE EVERYTHING IS FUNCTIONAL

if ($MONTECARLO != x) then
	#TODO generate seeds here
	
	echo "Monte carlo is being called"
	exit
	foreach TEMPSEED (`cat "seedFile.dat"`)
		$FPATH/correct.sh $N $TEMPSEED $CORR1 $CORR2 $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $STRENGTHERROR $CHANGEM $GENERATE $TOLERANCE $MAXTRIALS
	end	
else
	$FPATH/correct.sh $N $SEED $CORR1 $CORR2 $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $STRENGTHERROR $CHANGEM $GENERATE $TOLERANCE $MAXTRIALS
endif
