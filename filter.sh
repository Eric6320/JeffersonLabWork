#!/bin/tcsh
unset noclobber

#Current CHI2DOF total: 3.11798 - Tolerance: 3.5
#Final CHI2DOF sum: 3.11798, Trials required: 1

rm $FINALPATH/*.fin > /dev/null

foreach i (`ls $FINALPATH/*.dat`)
	
	set QUADNAME = `echo $i | awk -F"-" '{print $1}' | awk -F"/" '{print $7}'`
	set SEED = `echo $i | awk -F"-" '{print $2}' | awk -F"." '{print $1}'`
	set S = `$FPATH/pullS.sh $QUADNAME`

	echo "$QUADNAME $SEED $S"

	set CURRENT = `grep -m 1 'Current' $i | awk '{print $4}' | sed 's/,//g'`
	set FINAL = `grep 'Final' $i | awk '{print $4}' | sed 's/,//g'`

	echo "$S $QUADNAME $CURRENT $FINAL $SEED" | tee -a "$FINALPATH/finalData.fin"
end

cd $FINALPATH

gnuplot -persist -e "set xlabel 'S Coordinate (m)'; set ylabel 'CHI2DOF'; plot 'finalData.fin' using 1:3 with points title 'Pre-Minimization CHI2DOF Values'"

gnuplot -persist -e "set xlabel 'S Coordinate (m)'; set ylabel 'CHI2DOF'; plot 'finalData.fin' using 1:4 with points title 'Post-Minimization CHI2DOF Values'"

cd ..
