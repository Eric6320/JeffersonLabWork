#!/bin/tcsh
unset noclobber

#* Description: Generates the raw data needed for the changeVResponse M matrix, then recombines those files together
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
#* Argument: $11 - DELTAQ - The change in quadrupole strength that is applied to each quadrupole, and divided out in the M matrix
#* Example: ./generateCVR.sh 8 5 MBT1S01V MBT1S02V IPM1S03 -1 MQB1A29 unkicked modified 3 0.5
#* Main Output: "$CHANGEPATH/matrixM.fin"

# Set variables from command line arguments
set N = $1
set SEED = $2
set CORR1 = $3
set CORR2 = $4
set BPM1 = $5
set DESIGNBEAMLINE = $6
set MODIFIEDBEAMLINE = $7
set STRENGTHERROR = $8
set TESTQUAD = $9
set CHANGEM = $10
set DELTAQ = $11

set DESIGNTWISSFILE = "$RDPATH/$DESIGNBEAMLINE.twi"

# Determine the number of quadrupoles being manipulated
set THRESHOLD = `wc -l $CHANGEPATH/nextBPM.dat | awk '{print $1}'`

# For each Quadrupole in the design twiss file, determine the chi2dof response from changing its design strength to the modified one in $CHANGEPATH/"quadStrengths.dat"
@ x = 1
foreach i (`grep MQ $RDPATH/information.twiasc | awk '{print $2}'`)
	if (`grep -c $i $CHANGEPATH/nextQuadBPM.dat` == 1) then
		echo "******************************************** $x/$THRESHOLD) Determining CHI2DOF Change for $i********************************************"
		set STRENGTH = `grep $i "$CHANGEPATH/quadStrengths.dat" | awk '{print $2}'`

		time $JPATH/simulate.sh "N=$N, seed=$SEED, corr1=$CORR1, corr2=$CORR2, bpm1=$BPM1, designBeamline=$DESIGNBEAMLINE, modifiedBeamline=$MODIFIEDBEAMLINE, strengthError=$STRENGTHERROR, testQuad=$TESTQUAD, change=1, changeQuad=$i, changeQuadStrength=$STRENGTH, changeM=$CHANGEM, deltaQuad=$DELTAQ,"

		@ x += 1
	endif
end

# Recombine the files generated throughout the script into the proper formats in preparation for svd pseudoinverse
# Output: "$CHANGEPATH/matrixM.fin"
$FPATH/fileRecombine.sh $CHANGEPATH/nextQuadBPM.dat $DELTAQ
