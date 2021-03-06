#!/bin/tcsh
unset noclobber

#* Description: Performs either a floquet, or inverse floquet transformation on the data in the input file and saves it as the outputfile
#* Argument: $1 - INPUTFILE - Input file containing the coordinates to be transformed
#* Argument: $2 - OUTPUTFILE - Output file location used to store the transformed coordinates
#* Argument: $3 - BPM - Name of the BPM to be used as a reference point for the transformation. BPM from which to pull Twiss information
#* Argument: $4 - VERTICLE - 1 or 0 indicating whether to make verticle or horizontal considerations for the transformation
#* Argument: inverse - If the word 'inverse' is included anywhere in the command line argument, the transformation will be an inverse floquet transformation, otherwise it will be a standard floquet transformation
#* Example: floquet.sh inputFileName outputFileName IPM1S03 1 inverse
#* Main Output: $OUTPUTFILE - Typically modifiedEllipseOne.dat

# Store argument variables
set INPUTFILE = $1
set OUTPUTFILE = $2
set BPM = $3
set VERTICLE = $4

set INVERSE = `echo $argv | grep -c "inverse"`

# Store Twiss information from the given $BPM variable
set ALPHA = `grep -w $BPM $RDPATH/information.twiasc | awk -v verticle=$VERTICLE '{print $(3+verticle)}'`
set BETA = `grep -w $BPM $RDPATH/information.twiasc | awk -v verticle=$VERTICLE '{print $(5+verticle)}'`
set EMITTANCE = 1e-9

# Perform the appropriate transformation on the given data file
if ($INVERSE == 1) then
	# Perform Inverse Floquet Transformation to place the Unit Circle points onto a Betatron Ellipse
	cat $INPUTFILE | awk -v Beta=$BETA -v Epsilon=$EMITTANCE -v Alpha=$ALPHA '{print $1*sqrt(Beta*Epsilon)" "sqrt(Epsilon/Beta) * ($2 + $1*Alpha)}' >! $OUTPUTFILE
else
	# Perform a standard Floquet Transformation to turn the Betatron Ellipse back into a Unit Circle
	cat $INPUTFILE | awk -v Beta=$BETA -v Epsilon=$EMITTANCE -v Alpha=$ALPHA '{print $1/sqrt(Beta*Epsilon)" "$2*sqrt(Beta/Epsilon) - (($1 * Alpha)/sqrt(Beta*Epsilon))}' >! $OUTPUTFILE
endif
