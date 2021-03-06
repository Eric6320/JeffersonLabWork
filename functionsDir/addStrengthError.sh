#!/bin/tcsh
unset noclobber

#* Description: Modifies the quadrupole strength of a given quadrupole by a given multiplier
#* Argument: $1 - QUAD - Quadrupole whose strength will be modified to similuate error
#* Argument: $2 - PERCENTAGE - Percentage that the strength of $QUAD will be modified by. EX, -1 means change the sign on the strength
#* Argument: $3 - MODIFIEDBEAMLINE - Name of the beamline which has been modified from the design
#* Argument: $4 - SEED - Seed used to generate consistent random numbers. Should be set to 0 to not use a seed
#* Example: set NEWQUADSTRENGTH = `addStrengthError.sh MQB1A29 -1 modified 5`
#* Further Comments: Variables stored within a script are all upper case, however variables passed in from the command line assume camel casing
#* Main Output: New quadrupole strength value, and the $MODIFIEDBEAMLINE.lte file will be changed so that $QUAD reflects the $PERCENTAGE change

# Set variables from arguments
set QUAD = $1
set PERCENTAGE = $2
set MODIFIEDBEAMLINE = $3
set SEED = $4
set MODIFIEDLATTICE = $RDPATH/$MODIFIEDBEAMLINE.lte

# Modify the given lattice file so that the strength of $QUAD is multiplied by $PERCENTAGE
# Output: temp.dat
#javac $JAVAPATH/modifyQuadStrength.java
java -cp $JAVAPATH modifyQuadStrength $QUAD $PERCENTAGE $MODIFIEDLATTICE "$MODIFIEDBEAMLINE.lte" $SEED
