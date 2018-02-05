#!/bin/tcsh
unset noclobber

#* Description:
#* Argument: $1 - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# Set variables from command line arguments
set DESIGNBEAMLINE = $1

set DESIGNLATTICE = "$RDPATH/$DESIGNBEAMLINE.lte"
set DESIGNTWISSFILE = "$RDPATH/$DESIGNBEAMLINE.twi"

# Searches through the given lattice file for the quadrupole with the largest absolute strength, and adds one percent of that strength to all other quadrupoles on the same beamline
# Output: $CHANGEPATH/"quadStrengths.dat"
$FPATH/determineQStrengths.sh $DESIGNLATTICE $CHANGEPATH/"quadStrengths.dat"

# Determine how many quadrupoles exist on the given beamline
@ THRESHOLD = `sdds2stream -col=ElementName $DESIGNTWISSFILE | grep -c "MQ"`
echo "$THRESHOLD"

exit

# For each Quadrupole in the design twiss file
@ x = 1
foreach i (`sdds2stream -col=ElementName $DESIGNTWISSFILE | grep "MQ"`)

	#mkdir "$CHANGEPATH/$i\Dir"

	set STRENGTH = `cat "quadStrengths.dat" | head -$x | tail -1`

	#echo "Launching Comparison Call for $i"

	$FPATH/changeFunction.sh $i $STRENGTH

	@ x += 1
	exit
end

set DONECOUNT = `ls cDir* | grep -c "sumChi2DOF.dat"`

while ($DONECOUNT != $THRESHOLD)
	echo "Done count: $DONECOUNT / $THRESHOLD"
	set DONECOUNT = `ls cDir* | grep -c "sumChi2DOF.dat"`
	sleep 5
end

echo "$DONECOUNT Done!"

rm "response.dat" >& /dev/null
touch "response.dat"
foreach i (`sdds2stream -col=ElementName $DESIGNBEAMLINE.twi | grep "MQ"`)
	cat "cDir$i/sumChi2DOF.dat" | awk -v bpm=$i '{print bpm" "$1}' >> "response.dat"
end

gedit "response.dat"

#rm -r cDir* >& /dev/null
