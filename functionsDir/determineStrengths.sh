#!/bin/tcsh
unset noclobber

#* Description: Uses Twiss information at the given BPM to calculate the two corrector strengths needed to trace out each orbit on the betatron ellipse
#* Argument: $1 - BPMONE - BPM whose Twiss information is used as a reference point for the correctors
#* Argument: $2 - CORRONE - Name of the first quadrupole which is manipulated to trace out each orbit
#* Argument: $3 - CORRTWO - Name of the second quadrupole which is manipulated to trace out each orbit
#* Argument: $4 - VERTICLE - Boolean 1 or 0 which represents whether the transformation is verticle or horizontal.
#* Argument: $5 - MODIFIEDBEAMLINE - Name of the traced out beamline, only the name of the beamline is used
#* Example: determineStrengths.sh IPM1S03 MBT1S01V MBT1S02V 1 modified
#* Main Output: $MODIFIEDBEAMLINE"Strengths.dat"

# Set Variables from Arguments
set BPMONE = $1
set CORRONE = $2
set CORRTWO = $3
set VERTICLE = $4
set MODIFIEDBEAMLINE = $5

# Name Relevant Files
set INFORMATIONFILE = "$RDPATH/information.twiasc"
set OUTPUTFILE = $MODIFIEDBEAMLINE"Strengths.dat"
set INPUTELLIPSE = $MODIFIEDBEAMLINE"EllipseOne.dat"

# Pull necessary Twiss information with BPM and Corrector names as reference
set ALPHABPM = `grep -w $BPMONE $INFORMATIONFILE | awk -v verticle=$VERTICLE '{print $(3+verticle)}'`		
set BETAONE = `grep -w $CORRONE $INFORMATIONFILE | awk -v verticle=$VERTICLE '{print $(5+verticle)}'`		
set BETATWO = `grep -w $CORRTWO $INFORMATIONFILE | awk -v verticle=$VERTICLE '{print $(5+verticle)}'`		
set BETABPM = `grep -w $BPMONE $INFORMATIONFILE | awk -v verticle=$VERTICLE '{print $(5+verticle)}'`		
set PSIONE = `grep -w $CORRONE $INFORMATIONFILE | awk -v verticle=$VERTICLE '{print $(7+verticle)}'`
set PSITWO = `grep -w $CORRTWO $INFORMATIONFILE | awk -v verticle=$VERTICLE '{print $(7+verticle)}'`	
set PSIBPM = `grep -w $BPMONE $INFORMATIONFILE | awk -v verticle=$VERTICLE '{print $(7+verticle)}'`

# Print twiss information in a form readable to the strength calculator
cat $INPUTELLIPSE | awk -v Abpm=$ALPHABPM -v B1=$BETAONE -v B2=$BETATWO -v Bbpm=$BETABPM -v P1=$PSIONE -v P2=$PSITWO -v Pbpm=$PSIBPM ' {print $1" "$2" "Abpm" "B1" "B2" "Bbpm" "P1" "P2" "Pbpm}' >! "betatronPositions.dat"

# calculate necessary kicker strengths and angles to hit each target in the designEllipseOne.dat file
# Output: $MODIFIEDBEAMLINE"Strengths.dat
printf "%-40s -%s\n" "determineStrengths.sh" "Calculating Quadrupole Strengths"
#javac $JAVAPATH/dxprimeCalculations.java
java -cp $JAVAPATH dxprimeCalculations $OUTPUTFILE
