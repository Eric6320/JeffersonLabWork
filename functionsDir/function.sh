#!/bin/tcsh

#TODO comment this

# Set variables from command line arguments
set QUAD = $1
set STRENGTH = $2
set BPM = $3
set DESIGNBEAMLINE = $4
set MODIFIEDBEAMLINE = $5
set VERTICLE = $6

# Compile the changeQuadStrength.java file if the command line arguments contain the word 'compile' anywhere
if (`echo $argv | grep -c 'compile'` == 1) then
	echo "function.sh - Compiling changeQuadStrength.java"
	javac $JAVAPATH/changeQuadStrength.java
endif

# Adjust the strength of $QUAD to $STRENGTH, measuring at $BPM
java -cp $JAVAPATH changeQuadStrength $QUAD $STRENGTH "$OPTIMIZEPATH/$DESIGNBEAMLINE.lte" "$OPTIMIZEPATH/$DESIGNBEAMLINE.lte2"
mv "$OPTIMIZEPATH/$DESIGNBEAMLINE.lte2" "$OPTIMIZEPATH/$DESIGNBEAMLINE.lte"

# Re-Determine M matrix elements by first running elegant on the lattice with the new quadrupole strength
cd $OPTIMIZEPATH; elegant $DESIGNBEAMLINE.ele > /dev/null; cd ..;

# Pull the transportation matrix elements from the $DESIGNBEAMLINE.mat file and put them in an ascii readable format
sdds2stream -col=ElementName,s,R11,R12,R21,R22,R33,R34,R43,R44 $OPTIMIZEPATH/$DESIGNBEAMLINE.mat >! $OPTIMIZEPATH/$DESIGNBEAMLINE.matasc
# Take either the horizontal or verticle values based on the value of $VERTICLE
cat $OPTIMIZEPATH/$DESIGNBEAMLINE.matasc | awk -v verticle=$VERTICLE '{print $1" "$2" "$(3+4*verticle)" "$(4+4*verticle)" "$(5+4*verticle)" "$(6+4*verticle)}' >! temp.fin
# Cut the top two lines off of the file
$FPATH/cutLineOffTopOrBottom.sh top 1 temp.fin
# Re-name and move the file back to the optimize directory
mv temp.fin $OPTIMIZEPATH/$DESIGNBEAMLINE.matasc

# Compare new M value at $BPM"
set CHI2DOF = `$FPATH/compareM.sh $BPM 3 $OPTIMIZEPATH/$DESIGNBEAMLINE.matasc $OPTIMIZEPATH/$MODIFIEDBEAMLINE.mat`
echo "CHI2DOF = $CHI2DOF"
