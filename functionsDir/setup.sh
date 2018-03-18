#!/bin/tcsh
unset noclobber

#* Description: Generates beamline Twiss information, downstream bpm information, the base unit circle for transformations, and then transforms that unit circle to a betatron ellipse.
#* Argument: $1 - BPMONE - BPM whose Twiss information is used to transform the unit circle to the betatron ellipse.
#* Argument: $2 - N - Number of orbits to include in the Unit Circle generation.
#* Argument: $3 - DESIGNBEAMLINE - Name of the unmodified beamline.
#* Argument: $4 - MODIFIEDBEAMLINE - Name of the traced out beamline, only the name of the beamline is used
#* Argument: $5 - VERTICLE - Boolean 1 or 0 which represents whether the transformation is verticle or horizontal
#* Argument: $6 - S - S coordinate of BPMONE
#* Example: setup.sh IPM1S03 10 design 1 1.005
#* Main Output: $MODIFIEDBEAMLINE"EllipseOne.dat" - Coordinate pairs of design betatron ellipse

# Store Variables
set BPMONE = $1
set N = $2
set DESIGNBEAMLINE = $3
set MODIFIEDBEAMLINE = $4
set VERTICLE = $5
set S = $6

# Set static twiss parameters and s coordinate of BPM and two chosen quadrupoles
# Output: downstreamBPM.dat
grep 'IPM' $RDPATH/information.twiasc | awk -v S=$S '{if ($1 >= S) print $2" "$1}' >! "downstreamBPM.dat"

# Generate a unit circle with N evenly spaced data points
# Output: circle$N.dat
printf "%-40s -%s\n" "setup.sh" "Generating unit circle"
$FPATH/unitCircle.sh $N

# Transform the points on the unit circle to a betatron ellipse at the specified BPM using the modified lattice
# Output: $MODIFIEDBEAMLINE"EllipseOne.dat"
printf "%-40s -%s\n" "setup.sh" "Performing inverse floquet transformation on modified beamline"
$FPATH/floquet.sh "circle$N.dat" $MODIFIEDBEAMLINE"EllipseOne.dat" $BPMONE $VERTICLE "inverse"
