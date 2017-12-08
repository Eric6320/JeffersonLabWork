#!/bin/tcsh
unset noclobber

# Read in inputs #TODO FIX N VALUE
#set N = 5
#set MODIFIEDBEAMLINE = $2
#set CORRONE = $3
#set CORRTWO = $4
#set VERTICLE = $5


# Store variables as command input or defaults
set N = `$FPATH/setArg.sh N 10 $argv`
set SEED = `$FPATH/setArg.sh seed 5 $argv`
set CORRONE = `$FPATH/setArg.sh corr1 MBT1S01V $argv`
set CORRTWO = `$FPATH/setArg.sh corr2 MBT1S02V $argv`
set BPM1 = `$FPATH/setArg.sh bpm1 IPM1S03 $argv`
set DESIGNBEAMLINE = `$FPATH/setArg.sh designBeamline unkicked $argv`
set MODIFIEDBEAMLINE = `$FPATH/setArg.sh modifiedBeamline modified $argv`
set VERTICLE = `echo $CORRONE | grep -c "V"`
set BPMERROR = `$FPATH/setArg.sh bpmError x $argv`
set STRENGTHERROR = `$FPATH/setArg.sh strengthError -1 $argv`


rm elegantFile.ppss >& /dev/null; touch elegantFile.ppss
rm -r elegantPPSSDir >& /dev/null; mkdir elegantPPSSDir

# Build script file
@ x = 1
while ($x <= $N)
	
	set LINE = `cat modifiedStrengths.dat | head -$x | tail -1`
	set CORRSTRENGTHONE = `echo $LINE | awk '{print $1}'`
	set CORRSTRENGTHTWO = `echo $LINE | awk '{print $2}'`

	echo "$CORRONE $CORRSTRENGTHONE $CORRTWO $CORRSTRENGTHTWO $MODIFIEDBEAMLINE $x $VERTICLE" >> elegantFile.ppss

	@ x += 1
end

# Run scripts
ppss -f 'elegantFile.ppss' -c "$FPATH/elegantFunction.sh "

exit

# TODO VERIFY EVERYTHING BELOW THIS POINT

# Recompile
@ x = 1
while ($x <= $N)
	foreach FILE (`ls *CentroidValues.dat`)
		foreach ROW (`grep "IPM" information.dat`)
			set BPM = `awk '{print $2}'`
			cat $ROW >>  $BPM-centroidValues.dat
		end
	end
	@ x += 1
end
