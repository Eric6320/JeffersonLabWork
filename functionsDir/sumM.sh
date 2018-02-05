#!/bin/tcsh

#* Description: Determines the sum total of all CHI2DOF calculations for a given Transportation Matrix element number $M
#* Argument: $1 - M - Transportation Matrix element number (1-4)
#* Argument: $2 - FILE - File containing chi2dof calculations between the design and modified transportation matrices
#* Example: ./sumM.sh 3 $CHI2PATH/comparisons.fin
#* Main Output: Sum total of all CHI2DOF calculations for the given M element number

# Set variables from command line arguments
set M = $1
set FILE = $2

# Sum the CHI2DOF values of Transportation Matrix element number $M contained in $FILE
awk -v M=$M '{ sum += $(2+M)} END { print sum }' $FILE
