#!/bin/tcsh

setenv BPMMEASUREMENTERROR 0.0001
setenv DISPLACEMENTERROR 0.003

#TODO change these values to be more accurate
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ gaussianError $1 $BPMMEASUREMENTERROR bpmError.dat
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ gaussianError $1 $BPMMEASUREMENTERROR bpmError2.dat

# If there is displacement erorr included
if ($2 == 1)then
	java -cp /a/devuser/erict/workspace/Miscellaneous/src/ changeDisplacement unkicked.lte unkicked2.lte $DISPLACEMENTERROR
endif


