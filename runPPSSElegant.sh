#!/bin/tcsh
unset noclobber

# Read in inputs
set N = $1
set MODIFIEDBEAMLINE = $2
set CORRONE = $3
set CORRTWO = $4
set VERTICLE = $5

# Build script file
# For each BPM in the information file, make a 
foreach i (`grep IPM information.twiasc | awk '{print $2}'`)
	rm "$i-centroidValues.dat" >& /dev/null
	touch "$i-centroidValues.dat"
end

# Run scripts
rm -r Dir* >& /dev/null

@ x = 1
while ($x <= $N)
	mkdir "Dir$x"
	
	cp "$MODIFIEDBEAMLINE.lte" "Dir$x/$MODIFIEDBEAMLINE.lte"
	cp "$MODIFIEDBEAMLINE.ele" "Dir$x/$MODIFIEDBEAMLINE.ele"
	cp "modifyCorrector.pl" "Dir$x/modifyCorrector.pl"

	set LINE = `cat modifiedStrengths.dat | head -$x | tail -1`
	set CORRSTRENGTHONE = `echo $LINE | awk '{print $1}'`
	set CORRSTRENGTHTWO = `echo $LINE | awk '{print $2}'`

	cd "Dir$x"
	
	if (`expr $x % 10` == 0 || $x == $N) echo "Launching Elegant Call #$x"

	(elegantFunction.sh $CORRONE $CORRSTRENGTHONE $CORRTWO $CORRSTRENGTHTWO $MODIFIEDBEAMLINE $x $VERTICLE &)
	
	cd ..
	@ x += 1
end

# Recompile
