#!/bin/tcsh
unset noclobber

#* Description: Recombines all changeVResponse M matrix elements into one data file
#* Argument: $1 - QUADFILE - Data file containing the names of the quadrupoles used in the M matrix
#* Argument: $2 - DELTAQ - Value that all quadrupoles strengths are modified by
#* Example: ./fileRecombine.sh nextQuadBPM.dat 0.05
#* Main Output: $CHANGEPATH/matrixM.fin

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
