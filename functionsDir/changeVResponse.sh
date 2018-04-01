#!/bin/tcsh
unset noclobber
unset COLORS

#* Description: Generates a changeVResponse Matrix and applies the opposite Q matrix values to the modified beamlines quadrupole strengths
#* Argument: $1 - N - Number of orbits to include in the ellipse generation
#* Argument: $2 - SEED - Seed used for any random number generation throughout the scripts
#* Argument: $3 - CORR1 - The first corrector used to trace out ellipses at BPM1
#* Argument: $4 - CORR2 - The second corrector used to trace out ellipses at BPM2
#* Argument: $5 - BPM1 - The bpm used as a reference point for tracing out the beamline's ellipses
#* Argument: $6 - STRENGTHERROR - Percentage strength value change to be applied to the given $TESTQUAD
#* Argument: $7 - TESTQUAD - Quadrupole whos strength will be changed, and the response will be measured
#* Argument: $8 - DESIGNBEAMLINE - Name of the 'perfect' beamline used in chi2dof comparisons
#* Argument: $9 - MODIFIEDBEAMLINE - Name of the 'measured' beamline that contains any errors, used in chi2dof comparisons
#* Argument: $10 - CHANGEM - Transport matrix element whose chi2dof comparisons will observed
#* Argument: $11 - GENERATE - 0 or 1 boolean value indicating whether or not to generate a new changeVResponse matrix between each trial
#* Argument: $12 - TOLERANCE - CHI2DOF tolerance at which testing stops
#* Argument: $13 - CORRECTED - 0 or 1 boolean value indicating whether to use the origional 'clean' modified lattice, or the corrected modified lattice after at least one trial has been run
#* Example: ./changeVResponse.sh 8 5 MBT1S01V MBT1S02V IPM1S03 -1 MQB1A29 unkicked modified 3 1 3.5 1
#* Main Output:  $CHANGEPATH/$MODIFIEDBEAMLINE.lte with new strength values

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
set DESIGNTWISSFILE = "$RDPATH/$DESIGNBEAMLINE.twi"

# If it is the first trial, use the 'clean' lattice, otherwise used the corrected lattice
if ($CORRECTED == 1) then
	set DESIGNLATTICE = $CHANGEPATH/$MODIFIEDBEAMLINE.lte
else
	set DESIGNLATTICE = "$RDPATH/$DESIGNBEAMLINE.lte"
endif

# Searches through the given lattice file for the quadrupole with the largest absolute strength, and adds one percent of that strength to all other quadrupoles on the same beamline
# Output: $CHANGEPATH/"quadStrengths.dat"
printf "%-40s -%s\n" "determineQStrengths.sh" "Adding 1% of max quadrupole strength to all quadrupoles"
set DELTAQ = `$FPATH/determineQStrengths.sh $DESIGNLATTICE $CHANGEPATH/"quadStrengths.dat"`

# Determine the next BPM downstream of each Quadrupole
printf "%-40s -%s\n" "findNextBPM.sh" "Determining succeeding BPMs"
rm $CHANGEPATH/nextQuadBPM.dat >& /dev/null; touch $CHANGEPATH/nextQuadBPM.dat
foreach QUAD (`grep MQ $RDPATH/information.twiasc | awk '{print $2}'`)
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

# If the generate variable is specified, generate a changeVResponse Matrix M
if ($GENERATE == 1) then
	# Generate the changeVResponse Matrix M
	# Output: $CHANGEPATH/$QUADNAMEcomparison.dat
	$FPATH/generateCVR.sh $N $SEED $CORR1 $CORR2 $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $STRENGTHERROR $TESTQUAD $CHANGEM $DELTAQ
	
	# Recombine the files generated throughout the script into the proper formats in preparation for svd pseudoinverse
	# Output: "$CHANGEPATH/matrixM.fin"
	$FPATH/fileRecombine.sh $CHANGEPATH/nextQuadBPM.dat $DELTAQ
endif


# Determine the necessary quad changes, the perform the opposite on the modified beamline, determine chi2dof improvement
# Output: $CHANGEPATH/$MODIFIEDBEAMLINE.lte
$FPATH/calculateQuadChanges.sh $MODIFIEDBEAMLINE
