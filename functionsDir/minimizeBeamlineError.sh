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

# These variables are only referenced if there is optimization needed
set STRENGTHERROR = `$FPATH/setArg.sh strengthError -1 $argv`
set TESTQUAD = `$FPATH/setArg.sh testQuad MQB1A29 $argv`
set REFERENCEBPM = `$FPATH/setArg.sh referenceBPM IPM1R02 $argv`

# Set variables controlling changeVResponse.sh script behavior
set CHANGEM = `$FPATH/setArg.sh changeM 3 $argv`
set GENERATE = `$FPATH/setArg.sh generate 0 $argv`
set TOLERANCE = `$FPATH/setArg.sh tolerance 1 $argv`

$FPATH/changeVResponse.sh $N $SEED $CORR1 $CORR2 $BPM1 $STRENGTHERROR $DESIGNBEAMLINE $MODIFIEDBEAMLINE $CHANGEM $GENERATE $TOLERANCE
exit

@ x = 1
while (`echo "$x $MAXTRIALS" | awk '{if ($1 < $2) print 1; else print 0;}'` == 1)
end
