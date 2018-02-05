#!/bin/tcsh
unset noclobber

#* Description: Calculates a CHI2DOF value between the Transportation Matrix elements M of the design and modified beamlines
#* Argument: $1 - BPM - BPM at which the comparison is taking place
#* Argument: $2 - M - Transportation Matrix element (1,2,3, or 4) to use in the CHI2DOF calculation
#* Argument: $3 - DESIGNFILE - Unmodified beamline used in the CHI2DOF comparison which the modified beamline 'should' look like
#* Argument: $4 - MODIFIEDFILE - Modified beamline used in the CHI2DOF comparison.
#* Example: ./compareM.sh IPM1S05 3 unkicked.matasc modified.mat
#* Main Output: A CHI2DOF value printed to terminal, typically then stored as a variable in another script

# Store command line arguments as variables
set BPM = $1
set M = $2
set DESIGNFILE = $3
set MODIFIEDFILE = $4

# Search for the $M-th Transportation Matrix element at $BPM in both $DESIGNFILE and $MODIFIEDFILE
set DESIGNVALUE = `grep $BPM $DESIGNFILE | awk -v M=$M '{print $(2+M)}'`
set MODIFIEDVALUE = `grep $BPM $MODIFIEDFILE | awk -v M=$M '{print $(2+M)}'`

# Print the CHI2DOF value between the design and modified values to terminal
echo "$DESIGNVALUE $MODIFIEDVALUE" | awk '{print ($1 - $2)^2}'
