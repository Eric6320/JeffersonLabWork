#!/bin/tcsh
unset noclobber

#* Description: Determines the CHI2DOF change at each BPM that results from changing the strength of the given quadrupole
#* Argument: - M - Transport Matrix element comparison column used to determine the CHI2DOF change
#* Argument: - CHANGEQUAD - Quadrupole whose strength was changed to generate a response
#* Argument: - NEXTBPMFILE - Data file containing a list of BPM that immediate succeed their corresponding quadrupole
#* Argument: - STANDARDFILE - Data file containing the CHI2DOF comparisons between the transport elements of the beamline without any quadrupole strength changes
#* Argument: - COMPARISONFILE - Data file containing the CHI2DOF comparisons between the transport elements of the beamline with some quadrupole strength change
#* Example: ./findChange.sh 3 MQB1A29 nextBPM.dat standardComparisons.fin comparisons.fin
#* Main Output: "$CHANGEPATH/$CHANGEQUAD-comparison.dat"

# Set variables from command line arguments
set M = $1
set CHANGEQUAD = $2
set NEXTBPMFILE = $3
set STANDARDFILE = $4
set COMPARISONFILE = $5

# For every immediate BPM, determine the CHI2DOF change as a result of the $CHANGEQUAD strength change
rm "$CHANGEPATH/$CHANGEQUAD-comparison.dat" >& /dev/null
foreach CURRENTBPM (`cat $NEXTBPMFILE`)

	# Determine the CHI2DOF values of both the standard, and new comparison
	set STANDARDCHI = `grep $CURRENTBPM $STANDARDFILE | awk -v M=$M '{print $(2 + M)}'`
	set COMPARISONCHI = `grep $CURRENTBPM $COMPARISONFILE | awk -v M=$M '{print $(2 + M)}'`

	# Determine the difference between the standard and comparison and print to the correct comparison file
	echo "$CURRENTBPM $STANDARDCHI $COMPARISONCHI" | awk '{print $1" "($3-$2)}' >> "$CHANGEPATH/$CHANGEQUAD-comparison.dat"
end
