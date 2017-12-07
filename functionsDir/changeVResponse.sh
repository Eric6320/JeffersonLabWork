#!/bin/tcsh
unset noclobber

set DESIGNBEAMLINE = $1

echo "returnHighestQStrength.sh - Determining Max Quadrupole Strength"
determineQStrengths.sh $DESIGNBEAMLINE "quadStrengths.dat"

@ THRESHOLD = `sdds2stream -col=ElementName $DESIGNBEAMLINE.twi | grep -c "MQ"`
rm -rf cDir* >& /dev/null

@ x = 1
foreach i (`sdds2stream -col=ElementName $DESIGNBEAMLINE.twi | grep "MQ"`)

	mkdir "cDir$i"

	cp *.sh cDir$i/
	cp *.gnuplot cDir$i/

	cp "determineTransformationMatrix.py" "cDir$i/"
	cp "modifyQuad.pl" "cDir$i/"
	cp "modifyCorrector.pl" "cDir$i/"

	set STRENGTH = `cat "quadStrengths.dat" | head -$x | tail -1`

	cd "cDir$i"

	echo "Launching Comparison Call for $i"

	parallelChangeFunction.sh $i $STRENGTH

	cd ..
	@ x += 1
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
