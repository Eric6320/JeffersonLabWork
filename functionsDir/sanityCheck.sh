#!/bin/tcsh
unset noclobber

#* Description: TODO
#* Argument: TODO
#* Example: TODO
#* Further Comments: TODO
#* Main Output: TODO

# Set variables from arguments
set BETATRONFILE = $1
set BPMONE = $2
set N = $3
set VERTICLE = $4

set FLOQUETCHECK = `echo $argv | grep -c "floquet"`
set PLOTCHECK = `echo $argv | grep -c "plot"`

if ($FLOQUETCHECK == 1) then
	echo "sanityCheck.sh - Starting Floquet comparison / varification"


	# Transform the betatron ellipse back to a unit circle
	$FPATH/floquet.sh $BETATRONFILE "modifiedUnitCircle.dat" $BPMONE $VERTICLE

	if ($PLOTCHECK == 1) then
		# Graph the origional image, the transformed unit circle, and the design unit circle
		$FPATH/plot.sh $BETATRONFILE title=Initial Betatron Ellipse, xAxisLabel=X, yAxisLabel=xPrime,
		$FPATH/plot.sh "modifiedUnitCircle.dat" title=Modified Unit Circle, xAxisLabel=X, yAxisLabel=Y,
		$FPATH/plot.sh "circle$N.dat" title=Design Unit Circle, xAxisLabel=X, yAxisLabel=Y,
	endif

	# Paste the two unit circles together to calculate the CHI2DOF between them #TODO possibly put parenthesis around sqrt() in awk
	paste -d " " "modifiedUnitCircle.dat" "circle$N.dat" >! "floquetComparison.dat"
	awk '{ sum += sqrt(($1-$3)^2 + ($2-$4)^2)} END { print sum }' "floquetComparison.dat"
	rm "floquetComparison.dat"

# If it is not a floquet check, it is a determinant varification
else
	#TODO ADD THE DETERMINANT VARIFICATION HERE
endif




