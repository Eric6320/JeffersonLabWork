#!/bin/tcsh
unset noclobber

# Read in inputs #TODO FIX N VALUE
set N = 5
set MODIFIEDBEAMLINE = $2
set CORRONE = $3
set CORRTWO = $4
set VERTICLE = $5

rm elegantFile.ppss >& /dev/null; touch elegantFile.ppss

# Build script file
@ x = 1
while ($x <= $N)
	
	set LINE = `cat modifiedStrengths.dat | head -$x | tail -1`
	set CORRSTRENGTHONE = `echo $LINE | awk '{print $1}'`
	set CORRSTRENGTHTWO = `echo $LINE | awk '{print $2}'`

	echo "functionsDir/elegantFunction.sh $CORRONE $CORRSTRENGTHONE $CORRTWO $CORRSTRENGTHTWO $MODIFIEDBEAMLINE $x $VERTICLE" >> elegantFile.ppss

	@ x += 1
end

ppss -f elegantFile.ppss

# Run scripts

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
