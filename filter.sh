#!/bin/tcsh
unset noclobber

foreach i (`ls $FINALPATH/*.dat`)
	set QUADNAME = `echo $i | awk -F"-" '{print $1}'`
	set SEED = `echo $i | awk -F"-" '{print $2}' | awk -F"." '{print $1}'`
	
	grep -hE 'Final|\/\*|Current CHI2DOF total' $i >! 
end

exit

grep -hE 'Final|\/\*|Current CHI2DOF total' $FINALPATH/* >! finalData.dat

set NEXTBPM = `sed -n -e '/'$QUAD'/,$p' $DESIGNLATTICE | grep -m 1 "IPM" | awk '{print $1}' | sed "s/://g"`

gedit finalData.dat
