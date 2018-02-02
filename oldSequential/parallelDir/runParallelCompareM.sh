#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $DESIGNBEAMLINE $MODIFIEDBEAMLINE

set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3

#TODO CHANGE ARGUMENTS TO $1 $2 $3
#set BPMONE = `./setArg.sh bpm1 IPM1S03 $argv`
#set DESIGNBEAMLINE = `./setArg.sh designBeamline unkicked $argv`
#set MODIFIEDBEAMLINE = `./setArg.sh modifiedBeamline modified $argv`

set S = `./pullS.sh $BPMONE`

foreach x (1 2 3 4)
	mkdir "mDir$x"
	
	cp $DESIGNBEAMLINE".matasc" mDir$x/$DESIGNBEAMLINE.matasc
	cp $MODIFIEDBEAMLINE".mat" mDir$x/$MODIFIEDBEAMLINE.mat
	cp "downstreamBPM.dat" mDir$x/downstreamBPM.dat

	cd "mDir$x"

	echo "Calculating M$x"
	foreach i (`grep 'IPM' "../downstreamBPM.dat" | awk '{print $1}'`)
		(../parallelCompareM.sh $i $x $DESIGNBEAMLINE $MODIFIEDBEAMLINE &)
	end
	
	cd ..
end

set N = `grep -c 'IPM' "downstreamBPM.dat"`
set DONECOUNT = `ls * | grep -c "parallel-IPM"`
@ THRESHOLD = `expr $N \* 4`

while ($DONECOUNT != $THRESHOLD)
	echo "Done count: $DONECOUNT / $THRESHOLD"
	set DONECOUNT = `ls * | grep -c "parallel-IPM"`
	sleep 1
end

echo "$DONECOUNT Done!"

echo "Recompiling Comparison Files"
# Recompile all of the comparison files
foreach i (1 2 3 4)
	rm "newComparison$i.dat" >& /dev/null
	touch "newComparison$i.dat"
	cat `grep "IPM" "downstreamBPM.dat" | awk -v directory=mDir$i '{print directory"/parallel-"$1".dat"}'` >> "newComparison$i.dat"
end

paste -d " " downstreamBPM.dat newComparison1.dat newComparison2.dat newComparison3.dat newComparison4.dat >! newComparisons.fin

#Remove the line comparing the BPM to itself
sed -i '1d' newComparisons.fin
mv newComparisons.fin comparisons.fin

rm -r mDir* >& /dev/null
