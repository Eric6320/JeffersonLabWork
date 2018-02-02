#!/bin/tcsh

# Store variables as command input or defaults
setenv BPMNAMEONE `./setVariable.sh bpm1 IPM1S00 $argv`
setenv BPMNAMETWO `./setVariable.sh bpm2 IPM1S01 $argv`
setenv SEED `./setVariable.sh seed 0 $argv`
setenv N `./setVariable.sh N 20 $argv`
setenv BPMERROR `./setVariable.sh bpmError 0 $argv`
setenv STRENGTHERROR `./setVariable.sh strengthError 0 $argv`
setenv MONTECARLO `./setVariable.sh monteCarlo 0 $argv`

#echo "bpmOne: $BPMNAMEONE, bpmTwo: $BPMNAMETWO, seed: $SEED, N: $N, bpmError: $BPMERROR, strengthError: $STRENGTHERROR"

# Generate a unit circle with N evenly spaced data points if one does not already exist - circle$N.dat
if (`ls | grep -c "circle$N.dat"` == 0) ./unitCircle.sh $N

# Add error to quad strengths as a percentage of the origional if applicable
if ($STRENGTHERROR != 0) ./modifyQuadStrength.sh unkicked.lte unkicked2.lte $STRENGTHERROR $SEED

# Perform an inverse floquet transformation ot place the unit circle points onto a betatron ellipse at the specified BPM - ellipseA.dat ellipseB.dat
./inverseFloquet.sh $BPMNAMEONE "circle$N.dat" "ellipseA.dat"
./inverseFloquet.sh $BPMNAMETWO "circle$N.dat" "ellipseB.dat"

# Add scalar error to BPM measurement accuracy if applicable
if ($BPMERROR != 0) ./addBPMError.sh 4 $N $BPMERROR bpmError .dat $SEED

# Reformat ellipseA.dat and ellipseB.dat in a MATLAB readable way - ellipseA.fin ellipseB.fin
./formatEllipses.sh

# Plot the results
#./plotAll.sh

# Perform SVD and pseduo inverse on the matrixes - ellipseA2.fin
./runMatlab.sh determineTransformationMatrix.m >& /dev/null

# Reformat the final ellipses to be in standard form for chi squared comparasons
./reformat.sh ellipseA.fin
./reformat.sh ellipseA2.fin

# Print the chi2dof for matrices A and A2
setenv CHISQUARED `./leastSquares.sh ellipseA.fin ellipseA2.fin`
echo "$BPMNAMEONE-$BPMNAMETWO Chi2DOF: $CHISQUARED"

./cleanUp.sh

if ($MONTECARLO) then
	if ($BPMERROR != 0)then
		setenv ERRORCOLUMN $BPMERROR
	else
		setenv ERRORCOLUMN $STRENGTHERROR
	endif

	setenv AVERAGECHI2COLUMN `cat mcOutputFile.dat | awk '{print $3}'`
	printf "%-20s %-20s\n" $ERRORCOLUMN $AVERAGECHI2COLUMN >> mcOutputFile.fin
endif
