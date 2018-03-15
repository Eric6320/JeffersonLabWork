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
set N = $1
set SEED = $2
set CORR1 = $3
set CORR2 = $4
set BPM1 = $5
set DESIGNBEAMLINE = $6
set MODIFIEDBEAMLINE = $7
set CHANGEM = $8

set DESIGNTWISSFILE = "$DESIGNBEAMLINE.twi"


# Determine the number of quadrupoles being manipulated
set THRESHOLD = `wc -l $CHANGEPATH/nextBPM.dat | awk '{print $1}'`

# For each Quadrupole in the design twiss file, determine the chi2dof response from changing its design strength to the modified one in $CHANGEPATH/"quadStrengths.dat"
@ x = 1
foreach i (`sdds2stream -col=ElementName $DESIGNTWISSFILE | grep "MQ"`)
	if (`grep -c $i $CHANGEPATH/nextQuadBPM.dat` == 1) then
		echo "******************************************** $x/$THRESHOLD) Determining CHI2DOF Change for $i********************************************"
		set STRENGTH = `grep $i "$CHANGEPATH/quadStrengths.dat" | awk '{print $2}'`

		time $JPATH/simulate.sh "N=$N, seed=$SEED, corr1=$CORR1, corr2=$CORR2, bpm1=$BPM1, designBeamline=$DESIGNBEAMLINE, modifiedBeamline=$MODIFIEDBEAMLINE, change=1, changeQuad=$i, changeQuadStrength=$STRENGTH, changeM=$CHANGEM,"

		@ x += 1
	endif
end

