#!/bin/tcsh
unset noclobber

#* Description: Uses Brents Minimization algorithm to minimize the CHI2DOF value at the given $REFERENCEBPM
#* Argument: $1 - QUAD - Quadrupole whose strength will be modified to modify the CHI2DOF value
#* Argument: $2 - REFERENCEBPM - BPM whos CHI2DOF values are used as a reference point for the optimizeQuad script. This BPM's strengths are continously modified
#* Argument: $3 - DESIGNBEAMLINE - Name of the beamline whose quadrupole strength values will be changed to minimized CHI2DOF values
#* Argument: $4 - MODIFIEDBEAMLINE - Name of the beamline which has been modified to include some sort of error. The script is trying to match this error
#* Argument: $5 - VERTICLE - Binary value indicating whether the measurement is going to be studied in the horizontal or verticle direction
#* FUNCTIONNAME - $6 - FUNCTIONNAME - Name of the quadrupole strength changing function. Needed to be interchangeable to work with old code
#* Example: ./optimize.sh MQB1A29 IPM1R02 unkicked modified 1 $FPATH/function.sh
#* Further Comments: Contrary to the names of the beamlines, this script changes the $DESIGNBEAMLINE to match the $MODIFIEDBEAMLINE, not vice versa. The idea
#* Further Comments: is to re-create an error in order to determine what it is, and then do the opposite to fix it.
#* Main Output: $OPTIMIZEPATH/$DESIGNBEAMLINE.lte

# Set variables from command line arguments
set QUAD = $1
set REFERENCEBPM = $2
set DESIGNBEAMLINE = $3
set MODIFIEDBEAMLINE = $4
set VERTICLE = $5
set FUNCTIONNAME = $6

# Compile the script if the argument line contains the word 'compile'
if (`echo $argv | grep -c "compile"` == 1) then
	printf "%-40s -%s\n" "optimize.sh" "Compiling optimizeQuad.java"
	javac $JAVAPATH/optimizeQuad.java
endif

# Run the optimizeQuad.java script to minimize the CHI2DOF value at $REFERENCEBPM
java -cp $JAVAPATH optimizeQuad $QUAD $REFERENCEBPM $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $FUNCTIONNAME
