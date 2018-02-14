#!/bin/tcsh
unset noclobber

#* Description: Verifies that both floquet transformations executed within simulate.sh are accurate.
#* Argument: $1 - BETATRONFILEONE - Data file containing the centroid value pairs for the unit circle - betatron ellipse floquet comparison
#* Argument: $2 - BETATRONFILETWO - Data file containing the centroid value pairs for the betatron ellipse - modified betatron ellipse floquet comparison
#* Argument: $3 - BPM - Reference BPM used for each floquet transformation
#* Argument: $4 - N - Number of orbits to be included in the floquet transformations
#* Argument: $5 - VERTICLE - Boolean 1 or 0 which represents whether the floquet transformation is verticle or horizontal
#* Argument: PLOTCHECK - If the word 'plot' is included anywhere in the argument line, the betatron plots for each transformation will be shown
#* Example: ./sanityCheck.sh modifiedEllipseOne.dat IPM1S03CentroidValues.dat IPM1S03 10 1 plot
#* Further Comments: This script can only be run after both the initial and traced floquet transformations have been performed
#* Main Output: Two printed chi2dof values representing the accuracy of both floquet transformations

# Set variables from arguments
set BETATRONFILEONE = $1
set BETATRONFILETWO = $2
set BPM = $3
set N = $4
set VERTICLE = $5

# Determine whether or not the command line arguments include the word 'plot'
set PLOTCHECK = `echo $argv | grep -c "plot"`

echo "sanityCheck.sh - Starting Floquet comparison / varification"


# Transform the betatron ellipse back to a unit circle
$FPATH/floquet.sh $BETATRONFILEONE "modifiedUnitCircleOne.dat" $BPM $VERTICLE
$FPATH/floquet.sh $BETATRONFILETWO "modifiedUnitCircleTwo.dat" $BPM $VERTICLE

# If stated, plot the relevant floquet transformations
if ($PLOTCHECK == 1) then
	# Graph the origional image, the transformed unit circle, and the design unit circle
	$FPATH/plot.sh $BETATRONFILE title=Initial Betatron Ellipse, xAxisLabel=X, yAxisLabel=xPrime,
	$FPATH/plot.sh "modifiedUnitCircleOne.dat" title=Initial Modified Unit Circle, xAxisLabel=X, yAxisLabel=Y,
	$FPATH/plot.sh "modifiedUnitCircleTwo.dat" title=Traced Modified Unit Circle, xAxisLabel=X, yAxisLabel=Y,
	$FPATH/plot.sh "circle$N.dat" title=Design Unit Circle, xAxisLabel=X, yAxisLabel=Y,
endif

# Paste the two unit circles together to calculate the CHI2DOF between them
paste -d " " "modifiedUnitCircleOne.dat" "circle$N.dat" >! "floquetComparisonOne.dat"
paste -d " " "modifiedUnitCircleTwo.dat" "circle$N.dat" >! "floquetComparisonTwo.dat"
set INITIALCOMPARISON = `awk '{ sum += sqrt(($1-$3)^2 + ($2-$4)^2)} END { print sum }' "floquetComparisonOne.dat"`
set TRACEDCOMPARISON = `awk '{ sum += sqrt(($1-$3)^2 + ($2-$4)^2)} END { print sum }' "floquetComparisonTwo.dat"`
rm "floquetComparisonOne.dat" "floquetComparisonTwo.dat"

echo "Initial Comparison: $INITIALCOMPARISON Traced Comparison: $TRACEDCOMPARISON"
