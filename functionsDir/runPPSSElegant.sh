#!/bin/tcsh
unset noclobber

#* Description: Used to run Elegant $N number of times in parallel using ppss, tracing the measured ellipses.
#* Argument: $1 - N - Number of orbits, and number of times to run Elegant
#* Argument: $2 - MODIFIEDBEAMLINE - Name of the beamline whose elegant and lattice files are used to run Elegant
#* Argument: $3 - CORRONE - Name of the first quadrupole which is manipulated to trace out each orbit
#* Argument: $4 - CORRTWO - Name of the second quadrupole which is manipulated to trace out each orbit
#* Argument: $5 - VERTICLE - Boolean 1 or 0 which represents whether the transformation is verticle or horizontal
#* Example: runPPSSElegant.sh 10 modified MBT1S01V MBT1SO2V 1
#* Further Comments: All of the data from the elegant calls are stored in the elegantPPSSDir folder, but all centroidValue data files are stored in the centroidValuesDir folder
#* Main Output: *BPM*CentroidValues.dat

printf "%-40s -%s\n" "runPPSSElegant.sh" "Running Elegant to generate centroidValue data files"

# Store arguments as variables
set N = $1
set MODIFIEDBEAMLINE = $2
set CORRONE = $3
set CORRTWO = $4
set VERTICLE = $5

# Build script file containing corrector names, strengths, trial number, and other misc. bookkeeping information
# Output: elegantFile.ppss
rm elegantFile.ppss >& /dev/null; touch elegantFile.ppss
@ x = 1
while ($x <= $N)
	
	set LINE = `cat modifiedStrengths.dat | head -$x | tail -1`
	set CORRSTRENGTHONE = `echo $LINE | awk '{print $1}'`
	set CORRSTRENGTHTWO = `echo $LINE | awk '{print $2}'`

	echo "$CORRONE $CORRSTRENGTHONE $CORRTWO $CORRSTRENGTHTWO $MODIFIEDBEAMLINE $x $VERTICLE" >> elegantFile.ppss

	@ x += 1
end

# Run Elegant $N number of times in parallel using ppss
# Output: $ELEGANTPATH/centroidValues$TRIAL.dat
$FPATH/ppss -f 'elegantFile.ppss' -c "$FPATH/parallelElegant.sh " > /dev/null
$FPATH/catPPSSOutput.sh

# Recompile all of the centroidValue$TRIAL.dat files into one comprehensive list
# Output: $CENTROIDPATH/$BPM-centroidValues.dat
@ x = 1
while ($x <= $N)
	foreach BPM (`grep "IPM" $RDPATH/information.twiasc | awk '{print $2}'`)
		grep -w $BPM "$ELEGANTPATH/centroidValues$x.dat" | awk -v verticle=$VERTICLE '{print $(3+2*verticle)" "$(4+2*verticle)}' >> $CENTROIDPATH/$BPM"CentroidValues.dat"
	end
	@ x += 1
end

# Move a hard coded extra copy of "IPM1S03CentroidValues.dat" to the main directory for the sanity check
cp $CENTROIDPATH/"IPM1S03CentroidValues.dat" ~/git/JeffersonLabWork/"IPM1S03CentroidValues.dat"

# Clear the job log
$FPATH/clearPPSSOutput.sh
