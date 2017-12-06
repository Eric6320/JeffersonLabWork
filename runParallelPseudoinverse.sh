#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $DESIGNBEAMLINE $MODIFIEDBEAMLINE

set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3
set VERTICLE = $4

rm -r pDir* >& /dev/null
@ x = 1
foreach i (`grep 'IPM' "downstreamBPM.dat" | awk '{print $1}'`)

	mkdir "pDir$x"
	
	set FILEONE = "$BPMONE-centroidValues.dat"
	set FILETWO = `grep -w $i "downstreamBPM.dat" | awk '{print $1"-centroidValues.dat"}'`

	cp $FILEONE "pDir$x/$FILEONE"
	cp $FILETWO "pDir$x/$FILETWO"
	cp "determineTransformationMatrix.py" "pDir$x/determineTransformationMatrix.py"

	cd "pDir$x"

	if (`expr $x % 5` == 0 || $x == `grep -c 'IPM' "../downstreamBPM.dat"`) echo "Launching pseudoInverse Call #$x"


	set INFORMATION = `grep -w $i "../downstreamBPM.dat" | awk -v bpm1=$BPMONE '{print bpm1" "$1" "$2}'`
	
	(parallelPseudoinverse.sh $INFORMATION &)

	cd ..
	@ x += 1
end
	
set DONECOUNT = `ls pDir* | grep -c "done.dat"`
@ THRESHOLD = `grep -c "IPM" "downstreamBPM.dat"`

while ($DONECOUNT != $THRESHOLD)
	echo "Done count: $DONECOUNT / $THRESHOLD"
	set DONECOUNT = `ls pDir* | grep -c "done.dat"`
	sleep 1
end

echo "$DONECOUNT Done!"

echo "Generating Matrix Files"

rm $MODIFIEDBEAMLINE.mat >& /dev/null; touch $MODIFIEDBEAMLINE.mat

foreach i (`seq $THRESHOLD`)
	cat "pDir$i/done.dat" >> $MODIFIEDBEAMLINE.mat
end

sdds2stream -col=ElementName,s,R11,R12,R21,R22,R33,R34,R43,R44 $DESIGNBEAMLINE.mat >! $DESIGNBEAMLINE.matasc

cat "$DESIGNBEAMLINE.matasc" | awk -v verticle=$VERTICLE '{print $1" "$2" "$(3+4*verticle)" "$(4+4*verticle)" "$(5+4*verticle)" "$(6+4*verticle)}' >! "$DESIGNBEAMLINE.matasc"

cutLineOffTopOrBottom.sh top 1 $DESIGNBEAMLINE.matasc

rm -r pDir* >& /dev/null
