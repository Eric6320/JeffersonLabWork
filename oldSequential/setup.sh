#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $N $DESIGNBEAMLINE $VERTICLE

set BPMONE = $1
set N = $2
set DESIGNBEAMLINE = $3
set VERTICLE = $4
set S = $5

set DESIGNTWISSFILE = "$DESIGNBEAMLINE.twi"

# Set static twiss parameters and s coordinate of BPM and two chosen quadrupoles
echo "setup.sh - Generating twiss information and downstream BPM files - information.twiasc"
sdds2stream -col=s,ElementName,alphax,alphay,betax,betay,psix,psiy $DESIGNTWISSFILE >! information.twiasc
grep 'IPM' information.twiasc | awk -v S=$S '{if ($1 >= S) print $2" "$1}' >! downstreamBPM.dat

# Generate a unit circle with N evenly spaced data points - circle$N.dat
if (`ls | grep -c "circle$N.dat"` == 0) then
	echo "setup.sh - Generating unit circle";
	./unitCircle.sh $N
endif

# Transform the points on the unit circle to a betatron ellipse at the specified BPM using the modified lattice- modifiedEllipseOne.dat
echo "setup.sh - Performing inverse floquet transformation on modified beamline"
./floquet.sh "circle$N.dat" "modifiedEllipseOne.dat" $BPMONE $VERTICLE "inverse"
