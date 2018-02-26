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
set N = `$FPATH/setArg.sh N 10 $argv`
set SEED = `$FPATH/setArg.sh seed 5 $argv`
set CORR1 = `$FPATH/setArg.sh corr1 MBT1S01V $argv`
set CORR2 = `$FPATH/setArg.sh corr2 MBT1S02V $argv`
set BPM1 = `$FPATH/setArg.sh bpm1 IPM1S03 $argv`
set DESIGNBEAMLINE = `$FPATH/setArg.sh designBeamline unkicked $argv`
set MODIFIEDBEAMLINE = `$FPATH/setArg.sh modifiedBeamline modified $argv`
set CHANGEM = `$FPATH/setArg.sh changeM 3 $argv`

set DESIGNLATTICE = "$RDPATH/$DESIGNBEAMLINE.lte"
set DESIGNTWISSFILE = "$RDPATH/$DESIGNBEAMLINE.twi"

# Remove all excess data files from the main directory, and auxillary folders in preparation for a new run
$FPATH/cleanUp.sh "change" 

# Determine the baseline CHI2DOF values against which to compare, then move and rename to standardComparisons.fin in the changeDir directory
$JPATH/simulate.sh "N=$N, seed=$SEED, corr1=$CORR1, corr2=$CORR2, bpm1=$BPM1, designBeamline=$DESIGNBEAMLINE, modifiedBeamline=$MODIFIEDBEAMLINE, change=1,"
mv "$CHI2PATH/comparisons.fin" "$CHANGEPATH/standardComparisons.fin"

# Searches through the given lattice file for the quadrupole with the largest absolute strength, and adds one percent of that strength to all other quadrupoles on the same beamline
# Output: $CHANGEPATH/"quadStrengths.dat"
echo "determineQStrengths.sh - Adding 1% of max quadrupole strength to all quadrupoles"
set DELTAQ = `$FPATH/determineQStrengths.sh $DESIGNLATTICE $CHANGEPATH/"quadStrengths.dat"`
echo "Delta Q: $DELTAQ"

# Determine the next BPM downstream of each Quadrupole
touch $CHANGEPATH/nextQuadBPM.dat
foreach QUAD (`sdds2stream -col=ElementName $DESIGNTWISSFILE | grep "MQ"`)
	$FPATH/findNextBPM.sh $QUAD $BPM1 $DESIGNLATTICE >> $CHANGEPATH/nextQuadBPM.dat
end

# Remove any Quadrupoles that are out of bounds from the list
sed -i '/OUTOFBOUNDS/d' $CHANGEPATH/nextQuadBPM.dat

# Copy the nextQuadBPM.dat file to a file containing only the subsequent BPMs
awk '{print $2}' $CHANGEPATH/nextQuadBPM.dat >! $CHANGEPATH/nextBPM.dat

# Determine the number of quadrupoles being manipulated
set THRESHOLD = `wc -l $CHANGEPATH/nextBPM.dat`

# For each Quadrupole in the design twiss file, determine the chi2dof response from changing its design strength to the modified one in $CHANGEPATH/"quadStrengths.dat"
@ x = 1
foreach i (`sdds2stream -col=ElementName $DESIGNTWISSFILE | grep "MQ"`)
	if (`grep -c $i $CHANGEPATH/nextQuadBPM.dat` == 1) then
		echo "******************************************** $x/$THRESHOLD) Determining Sum CHI2DOF for $i********************************************"
		set STRENGTH = `grep $i "quadStrengths.dat" | awk '{print $2}'`

		# Output: $CHANGEPATH/$icomparison.dat
		$JPATH/simulate.sh "N=$N, seed=$SEED, corr1=$CORR1, corr2=$CORR2, bpm1=$BPM1, designBeamline=$DESIGNBEAMLINE, modifiedBeamline=$MODIFIEDBEAMLINE, change=1, changeQuad=$i, changeQuadStrength=$STRENGTH, changeM=$CHANGEM,"

		@ x += 1
	endif
end

# Recombine the files generated throughout the script into the proper formats in preparation for svd pseudoinverse
# Output: "$CHANGEPATH/matrixM.fin"
$FPATH/fileRecombine.sh $CHANGEPATH/nextQuadBPM.dat $DELTAQ

exit

# Determine the necessary quad changes, the perform the opposite on the modified beamline
$FPATH/calculateQuadChanges.sh #TODO add arguments

# Determine the error point, and chi2dof value from the correction
#TODO finish this

