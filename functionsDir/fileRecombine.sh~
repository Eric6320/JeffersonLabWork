#!/bin/tcsh
unset noclobber

#* Description:
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

#$CHANGEPATH/$icomparison.dat
#$CHANGEPATH/nextQuadBPM.dat

set QUADFILE = $1
set DELTAQ = $2

echo "fileRecombine.sh - Dividing by change"
set THRESHOLD = `ls $CHANGEPATH/MQ*comparison.dat | wc -l`
set STRINGPLACEHOLDER = "comparison.dat"

foreach x (`seq $THRESHOLD`)
	set TEMPQUAD = `cat $QUADFILE | head -$x | tail -1 | awk '{print $1}'`
	awk -v deltaQ=$DELTAQ '{print ($2/deltaQ)}' "$CHANGEPATH/$TEMPQUAD-comparison.dat" >! "$CHANGEPATH/comparison$x.fin"
end

echo "fileRecombine.sh - Recombining changeVResponse files"
rm "$CHANGEPATH/matrixM.fin" > /dev/null; touch "$CHANGEPATH/matrixM.fin" #TODO delete the file removal here
foreach FILE (`ls $CHANGEPATH/comparison*.fin`)
	paste -d " " $CHANGEPATH/matrixM.fin $FILE >! $CHANGEPATH/temp.dat
	mv $CHANGEPATH/temp.dat $CHANGEPATH/matrixM.fin
end

gedit "$CHANGEPATH/matrixM.fin"

