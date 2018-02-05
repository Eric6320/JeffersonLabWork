#!/bin/tcsh
unset noclobber

#* Description: Searches through the given $DESIGNLATTICE for the quadrupole with the largest absolute strength, and adds one percent of that strength to all other quadrupoles on the same beamline
#* Argument: $1 - $DESIGNLATTICE - Lattice file which contains all of the design quadrupole strengths.
#* Example: determineQStrengths.sh unkicked.lte quadStrengths.dat
#* Main Output: $CHANGEPATH/"quadStrengths.dat"

# Set variables from command line arguments
set DESIGNLATTICE = $1
set OUTPUTFILE = $2

# Compile the script if the argument line contains the word 'compile'
if (`echo $argv | grep -c "compile"` == 1) then
	echo "determineQStrengths.sh - Compiling determineQStrengths.java"
	javac $JAVAPATH/determineQStrengths.java
endif

echo "determineQStrengths.sh - Adding 1% of max quadrupole strength to all quadrupoles"
java -cp $JAVAPATH determineQStrengths $DESIGNLATTICE $OUTPUTFILE
