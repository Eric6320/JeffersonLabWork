#!/bin/tcsh

@ NUMBEROFFILES = `ls | grep -c IPM1` * 2
set FILENAME = "bpmError"
set EXTENSION = ".dat"

echo "addBPMError.sh - Adding BPM Error"	
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ scalarGaussianError $NUMBEROFFILES $N $BPMERROR $FILENAME $EXTENSION $SEED

@ a = 1

foreach x (`ls | grep 'IPM'`)
	@ b = $a + 1

	paste -d " " $x $FILENAME$a$EXTENSION $FILENAME$b$EXTENSION >! temp.dat
	cat temp.dat | awk '{print ($1+$3)" "($2+$4)}' >! $x

	@ a += 2
end

rm bpmError*.dat >& /dev/null
