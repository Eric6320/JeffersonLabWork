#!/bin/tcsh

set QUAD = $1
set STRENGTH = $2
set BPM = $3
set DESIGNBEAMLINE = $4
set MODIFIEDBEAMLINE = $5
set VERTICLE = $6

#Change the one quad strength
#echo "function.sh - Adjusting strength of $QUAD, measuring at $BPM"
#javac /a/devuser/erict/workspace/Miscellaneous/src/changeQuadStrength.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ changeQuadStrength $QUAD $STRENGTH $DESIGNBEAMLINE.lte $DESIGNBEAMLINE.lte2
mv $DESIGNBEAMLINE.lte2 $DESIGNBEAMLINE.lte


# Re-Determine M matrix elements
#echo "function.sh - Recalculating M values"
elegant "$DESIGNBEAMLINE.ele" >& /dev/null
./formatMatasc.sh $DESIGNBEAMLINE $VERTICLE

# Calculate the CHI2DOF of the design and modified M values for the given BPM - comparison*.fin #TODO revisit what needs to be deleted in the runCompareScript
#echo "function.sh - Comparing new M value"

set CHI2DOF = `./compareM.sh $BPM 3 $DESIGNBEAMLINE $MODIFIEDBEAMLINE`
#set CHI2DOF = `./sumM.sh M=3,`
echo "CHI2DOF = $CHI2DOF"
