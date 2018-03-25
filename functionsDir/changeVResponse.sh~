#!/bin/tcsh
unset noclobber
unset COLORS

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
set N = $1
set SEED = $2
set CORR1 = $3
set CORR2 = $4
set BPM1 = $5
set STRENGTHERROR = $6
set TESTQUAD = $7
set DESIGNBEAMLINE = $8
set MODIFIEDBEAMLINE = $9
set CHANGEM = $10
set GENERATE = $11
set TOLERANCE = $12
set CORRECTED = $13

if ($CORRECTED == 1) then
	set DESIGNLATTICE = $CHANGEPATH/$MODIFIEDBEAMLINE.lte
else
	set DESIGNLATTICE = "$RDPATH/$DESIGNBEAMLINE.lte"
endif

set DESIGNTWISSFILE = "$RDPATH/$DESIGNBEAMLINE.twi"

# Searches through the given lattice file for the quadrupole with the largest absolute strength, and adds one percent of that strength to all other quadrupoles on the same beamline
# Output: $CHANGEPATH/"quadStrengths.dat"
printf "%-40s -%s\n" "determineQStrengths.sh" "Adding 1% of max quadrupole strength to all quadrupoles"
set DELTAQ = `$FPATH/determineQStrengths.sh $DESIGNLATTICE $CHANGEPATH/"quadStrengths.dat"`

# Determine the next BPM downstream of each Quadrupole
printf "%-40s -%s\n" "findNextBPM.sh" "Determining succeeding BPMs"
rm $CHANGEPATH/nextQuadBPM.dat >& /dev/null; touch $CHANGEPATH/nextQuadBPM.dat

foreach QUAD (`sdds2stream -col=ElementName $DESIGNTWISSFILE | grep "MQ"`)
	$FPATH/findNextBPM.sh $QUAD $BPM1 $DESIGNLATTICE >> $CHANGEPATH/nextQuadBPM.dat
end

# Remove any Quadrupoles that are out of bounds from the list
sed -i '/OUTOFBOUNDS/d' "$CHANGEPATH/nextQuadBPM.dat"

# Copy the nextQuadBPM.dat file to a file containing only the subsequent BPMs
awk '{print $2}' "$CHANGEPATH/nextQuadBPM.dat" >! "$CHANGEPATH/nextBPM.dat"

# Generate 'baseline' chi matrix
# Output: $CHANGEPATH/matrixX.fin
rm "$CHANGEPATH/matrixX.fin" >& /dev/null; touch "$CHANGEPATH/matrixX.fin"
foreach NEXTBPM (`cat $CHANGEPATH/nextBPM.dat`)
	grep -w $NEXTBPM $CHANGEPATH/standardComparisons.fin | awk -v M=$CHANGEM '{print $(2+M)}' >> "$CHANGEPATH/matrixX.fin"
end

if ($GENERATE == 1) then
	# Generate the changeVResponse Matrix M
	# Output: $CHANGEPATH/$QUADNAMEcomparison.dat
	$FPATH/generateCVR.sh $N $SEED $CORR1 $CORR2 $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $STRENGTHERROR $TESTQUAD $CHANGEM $DELTAQ
	
	# Recombine the files generated throughout the script into the proper formats in preparation for svd pseudoinverse
	# Output: "$CHANGEPATH/matrixM.fin"
	$FPATH/fileRecombine.sh $CHANGEPATH/nextQuadBPM.dat $DELTAQ
endif


# Determine the necessary quad changes, the perform the opposite on the modified beamline, determine chi2dof improvement
$FPATH/calculateQuadChanges.sh $MODIFIEDBEAMLINE

# TODO do without error
# TODO Add quad error
# TODO add multiple quad error
# TODO Determine the error point

