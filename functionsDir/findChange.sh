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
set REFERENCEBPM = $3
set DESIGNBEAMLINE = $4
set STANDARDFILE = $5
set COMPARISONFILE = $6

set DESIGNTWISSFILE = "$RDPATH/$DESIGNBEAMLINE.twi"
set DESIGNLATTICE = "$RDPATH/$DESIGNBEAMLINE.lte"


foreach i (`sdds2stream -col=ElementName $DESIGNTWISSFILE | grep "MQ"`)
	# Find the first BPM that follows the given Quad within the $DESIGNLATTICE file
	set NEXTBPM = `$FPATH/findNextBPM.sh $CHANGEQUAD $REFERENCEBPM $DESIGNLATTICE`

	# Determine the CHI2DOF values of both the standard, and new comparison
	set STANDARDCHI = `grep $NEXTBPM $STANDARDFILE | awk -v M=$M '{print $(2 + M)}'`
	set COMPARISONCHI = `grep $NEXTBPM $COMPARISONFILE | awk -v M=$M '{print $(2 + M)}'`

	# Determine the difference between the standard and comparison and print to the correct comparison file
	echo "$STANDARDCHI $COMPARISONCHI" | awk '{print ($2-$1)}' >> "$CHANGEPATH/$CHANGEQUAD-$NEXTBPM-comparison.dat"
	
end
