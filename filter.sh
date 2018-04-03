#!/bin/tcsh
unset noclobber

#Current CHI2DOF total: 3.11798 - Tolerance: 3.5
#Final CHI2DOF sum: 3.11798, Trials required: 1

rm $FINALPATH/*.fin > /dev/null
foreach i (`ls $FINALPATH/*.dat`)
	set QUADNAME = `echo $i | awk -F"-" '{print $1}' | awk -F"/" '{print $8}'`
	set SEED = `echo $i | awk -F"-" '{print $2}' | awk -F"." '{print $1}'`
	set S = `$FPATH/pullS.sh $QUADNAME`

	set CURRENT = `grep -m 1 'Current' $i | awk '{print $4}' | sed 's/,//g'`
	set FINAL = `grep 'Final' $i | awk '{print $4}' | sed 's/,//g'`

	echo "$S $QUADNAME $CURRENT $FINAL $SEED" | tee -a "$FINALPATH/finalData.fin"
end

gnuplot -p "plot" 

gedit "$FINALPATH/finalData.fin"
exit

foreach i (`ls $FINALPATH/*.fin`)
	cat $i >>! "$FINALPATH/finalData.fin"
end


exit

grep -hE 'Final|\/\*|Current CHI2DOF total' $FINALPATH/* >! finalData.dat

set NEXTBPM = `sed -n -e '/'$QUAD'/,$p' $DESIGNLATTICE | grep -m 1 "IPM" | awk '{print $1}' | sed "s/://g"`

gedit finalData.dat
