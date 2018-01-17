#!/bin/tcsh
unset noclobber

#* Description: Generates beamline Twiss information, downstream bpm information, the base unit circle for transformations, and then transforms that unit circle.
#* Argument: $1 - BPMONE - BPM whose Twiss information is used to transform the unit circle to the betatron ellipse.
#* Argument: $2 - N - Number of orbits to include in the Unit Circle generation.
#* Argument: $3 - DESIGNBEAMLINE - Name of the unmodified beamline.
#* Argument: $4 - VERTICLE - Boolean 1 or 0 which represents whether the transformation is verticle or horizontal.
#* Argument: $5 - S - S coordinate of BPMONE
#* Example: 

# Store Variables
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
