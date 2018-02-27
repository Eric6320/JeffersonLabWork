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

printf "%-40s -%s\n" "fileRecombine.sh" "Dividing by change"
set THRESHOLD = `ls $CHANGEPATH/MQ*comparison.dat | wc -l`
set STRINGPLACEHOLDER = "comparison.dat"

foreach x (`seq $THRESHOLD`)
	set TEMPQUAD = `cat $QUADFILE | head -$x | tail -1 | awk '{print $1}'`
	if ($x == $THRESHOLD) then
		awk -v deltaQ=$DELTAQ '{print ($2/deltaQ)}' "$CHANGEPATH/$TEMPQUAD-comparison.dat" >! "$CHANGEPATH/comparison$x.fin"
	else
		awk -v deltaQ=$DELTAQ '{print ($2/deltaQ)","}' "$CHANGEPATH/$TEMPQUAD-comparison.dat" >! "$CHANGEPATH/comparison$x.fin"
	endif
end

printf "%-40s -%s\n" "fileRecombine.sh" "Recombining changeVResponse files"
foreach x (`seq $THRESHOLD`)
	set FILE = "$CHANGEPATH/comparison$x.fin"
	
	if ($x == 1) then
		cp $FILE "$CHANGEPATH/matrixM.fin"
	else
		paste -d " " $CHANGEPATH/matrixM.fin $FILE >! $CHANGEPATH/temp.dat
		mv $CHANGEPATH/temp.dat $CHANGEPATH/matrixM.fin		
	endif
end
