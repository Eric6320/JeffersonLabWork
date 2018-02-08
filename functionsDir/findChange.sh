#!/bin/tcsh
unset noclobber

#* Description:
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# Set variables from command line arguments
set M = $1
set CHANGEQUAD = $2
set NEXTBPMFILE = $3
set STANDARDFILE = $4
set COMPARISONFILE = $5

# For every immediate BPM, determine the CHI2DOF change as a result of the $CHANGEQUAD strength change
foreach CURRENTBPM (`cat $NEXTBPMFILE`)
	# Determine the CHI2DOF values of both the standard, and new comparison
	set STANDARDCHI = `grep $CURRENTBPM $STANDARDFILE | awk -v M=$M '{print $(2 + M)}'`
	set COMPARISONCHI = `grep $CURRENTBPM $COMPARISONFILE | awk -v M=$M '{print $(2 + M)}'`

	# Determine the difference between the standard and comparison and print to the correct comparison file
	echo "$CURRENTBPM $STANDARDCHI $COMPARISONCHI" | awk '{print $1" "($3-$2)}' >> "$CHANGEPATH/$CHANGEQUAD-comparison.dat"
end
