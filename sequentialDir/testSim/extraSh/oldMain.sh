#!/bin/tcsh

# Optimal BPMERROR: 0.102

# Store the bpm name, number of particles, and whether the kickers are verticle or horizontal as variables
setenv BPMNAMEONE $1
setenv BPMNAMETWO $2
setenv N $3
setenv SEED $4
setenv ERRORTYPE "none"

# Set error type and value if applicable
if ($#argv >= 6)then
	setenv ERRORTYPE $5
	setenv ERRORVALUE $6	
endif

# Generate a unit circle with N evenly spaced data points
./unitCircle.sh $N

if ($ERRORTYPE == "strength")then
	# Modify the strength of each quadrupole in unkicked.lte by the error value
	./modifyLTE.sh unkicked.lte unkickedTemp.lte "DY= DZ=0" K1= $ERRORVALUE 0 $SEED
	mv unkickedTemp.lte unkicked.lte
	gedit unkicked.lte
	elegant unkicked.ele >& /dev/null
endif

# Perform an Inverse Floquet Transformation to place the Unit Circle points onto a Betatron Ellipse at the specified BPM
./inverseFloquet.sh $BPMNAMEONE "ellipseA.dat"
./inverseFloquet.sh $BPMNAMETWO "ellipseB.dat"

# Add BPM measurement error if applicable
if($ERRORTYPE == "bpm")then
	./addBPMError.sh $N $ERRORVALUE $SEED
endif

# Reformat the data in a MATLAB readable way
./formatEllipses.sh

# Plot the results
#./plotAll.sh

# Perform SVD and pseduo inverse on the matrixes
./runMatlab.sh determineTransformationMatrix.m >& /dev/null

# Reformat the final ellipses to be in standard form for chi squared comparasons
./reformat.sh ellipseA.fin
./reformat.sh ellipseA2.fin

# Calculated quantitative difference between A and A2
setenv CHISQUARED `./leastSquares.sh ellipseA.fin ellipseA2.fin`
echo "$BPMNAMEONE-$BPMNAMETWO Chi2DOF: $CHISQUARED"

./cleanUp.sh

