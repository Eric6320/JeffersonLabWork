#!/bin/tcsh
unset noclobber

echo "runPPSSElegant.sh - Running Elegant to generate centroidValue data files"

# Read in inputs
set N = $1
set MODIFIEDBEAMLINE = $2
set CORRONE = $3
set CORRTWO = $4
set VERTICLE = $5

# Build script file
rm elegantFile.ppss >& /dev/null; touch elegantFile.ppss
@ x = 1
while ($x <= $N)
	
	set LINE = `cat modifiedStrengths.dat | head -$x | tail -1`
	set CORRSTRENGTHONE = `echo $LINE | awk '{print $1}'`
	set CORRSTRENGTHTWO = `echo $LINE | awk '{print $2}'`

	echo "$CORRONE $CORRSTRENGTHONE $CORRTWO $CORRSTRENGTHTWO $MODIFIEDBEAMLINE $x $VERTICLE" >> elegantFile.ppss

	@ x += 1
end

# Run scripts

$FPATH/ppss -f 'elegantFile.ppss' -c "$FPATH/elegantFunction.sh " > /dev/null

# Recompile
@ x = 1
while ($x <= $N)
	foreach BPM (`grep "IPM" $RDPATH/information.twiasc | awk '{print $2}'`)
		grep -w $BPM "$ELEGANTPATH/centroidValues$x.dat" | awk -v verticle=$VERTICLE '{print $(3+2*verticle)" "$(4+2*verticle)}' >> "$CENTROIDPATH/$BPM-centroidValues.dat"
	end
	@ x += 1
end
