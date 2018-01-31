#!/bin/tcsh
unset noclobber

#* Description: TODO
#* Argument: TODO
#* Example: TODO
#* Further Comments: TODO
#* Main Output: TODO

# Set variables from arguments
set BETATRONFILEONE = $1
set BETATRONFILETWO = $2
set BPM = $3
set N = $4
set VERTICLE = $5

set PLOTCHECK = `echo $argv | grep -c "plot"`

echo "sanityCheck.sh - Starting Floquet comparison / varification"


# Transform the betatron ellipse back to a unit circle
$FPATH/floquet.sh $BETATRONFILEONE "modifiedUnitCircleOne.dat" $BPM $VERTICLE
$FPATH/floquet.sh $BETATRONFILETWO "modifiedUnitCircleTwo.dat" $BPM $VERTICLE

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

#TODO ADD THE DETERMINANT VARIFICATION HERE

echo $INITIALCOMPARISON $TRACEDCOMPARISON