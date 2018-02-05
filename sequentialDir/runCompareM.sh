#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $DESIGNBEAMLINE $MODIFIEDBEAMLINE

set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3

set S = `./pullS.sh $BPMONE`

rm comparison*.dat >& /dev/null
foreach i (1 2 3 4)
	echo "runCompareM.sh - Calculating Chi2DOF for M $i"
	foreach x (`grep 'IPM' downstreamBPM.dat | awk '{print $1}'`)
		./compareM.sh $x $i $DESIGNBEAMLINE $MODIFIEDBEAMLINE >>! comparison$i.dat
	end
end

paste -d " " downstreamBPM.dat comparison1.dat comparison2.dat comparison3.dat comparison4.dat >! comparisons.fin

#Remove the line comparing the BPM to itself
sed -i '1d' comparisons.fin