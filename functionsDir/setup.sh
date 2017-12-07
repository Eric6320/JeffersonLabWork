#!/bin/tcsh
unset noclobber

set BPMONE = $1
set N = $2
set DESIGNBEAMLINE = $3
set VERTICLE = $4
set S = $5

# Set static twiss parameters and s coordinate of BPM and two chosen quadrupoles
grep 'IPM' $RDPATH/information.twiasc | awk -v S=$S '{if ($1 >= S) print $2" "$1}' >! "downstreamBPM.dat"

# Generate a unit circle with N evenly spaced data points - circle$N.dat
echo "setup.sh - Generating unit circle";
$FPATH/unitCircle.sh $N

# Transform the points on the unit circle to a betatron ellipse at the specified BPM using the modified lattice- modifiedEllipseOne.dat
echo "setup.sh - Performing inverse floquet transformation on modified beamline"
$FPATH/floquet.sh "circle$N.dat" "modifiedEllipseOne.dat" $BPMONE $VERTICLE "inverse"
