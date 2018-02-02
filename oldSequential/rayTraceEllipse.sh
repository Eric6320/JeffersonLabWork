#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $CORRONE $CORRTWO $MODIFIEDBEAMLINE $VERTICLE

set BPMONE = $1
set CORRONE = $2
set CORRTWO = $3
set MODIFIEDBEAMLINE = $4
set VERTICLE = $5

set STRENGTHSFILE = $MODIFIEDBEAMLINE"Strengths.dat"

echo "rayTraceEllipse.sh - Calculating Centroid Values"
# Change the quadrupole strengths to those given in the strengths file - $OUTPUTFILE
cat $STRENGTHSFILE | awk -v bpm1=$BPMONE -v corr1=$CORRONE -v corr2=$CORRTWO -v beamline=$MODIFIEDBEAMLINE '{ system("./setTwoCorrectorStrengths.sh "corr1" "$1" "corr2" "$2" "beamline" "NR) }'

rm "*-centroidValues.dat" >& /dev/null

foreach i (`ls centroidValues*`)
	foreach j (`grep IPM $i | awk '{print $2}'`)
		grep -w $j $i >>! "$j-oldCentroidValues.dat"
	end
end



foreach i (`grep IPM information.twiasc | awk '{print $2}'`)
	cat "$i-oldCentroidValues.dat" | awk -v verticle=$VERTICLE '{print $(3+2*verticle)" "$(4+2*verticle)}' >! "$i-centroidValues.dat"
	rm "$i-oldCentroidValues.dat"
end
