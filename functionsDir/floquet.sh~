#!/bin/tcsh
unset noclobber

# TODO DONE

# Store argument variables
set INPUTFILE = $1
set OUTPUTFILE = $2
set BPMONE = $3
set VERTICLE = $4

set INVERSE = `echo $argv | grep -c "inverse"`

#sdds2stream -col=s,ElementName,alphax,alphay,betax,betay,psix,psiy $DESIGNTWISSFILE >! information.twiasc

setenv ALPHA `grep -w $BPMONE information.twiasc | awk -v verticle=$VERTICLE '{print $(3+verticle)}'`
setenv BETA  `grep -w $BPMONE information.twiasc | awk -v verticle=$VERTICLE '{print $(5+verticle)}'`
setenv EMITTANCE 1e-9

# Perform the appropriate transformation on the given data file
if ($INVERSE == 1) then
	# Perform Inverse Floquet Transformation to place the Unit Circle points onto a Betatron Ellipse
	cat $INPUTFILE | awk -v Beta=$BETA -v Epsilon=$EMITTANCE -v Alpha=$ALPHA '{print $1*sqrt(Beta*Epsilon)" "sqrt(Epsilon/Beta) * ($2 + $1*Alpha)}' >! $OUTPUTFILE
else
	# Perform Inverse Floquet Transformation to place the Unit Circle points onto a Betatron Ellipse
	cat $INPUTFILE | awk -v Beta=$BETA -v Epsilon=$EMITTANCE -v Alpha=$ALPHA '{print $1/sqrt(Beta*Epsilon)" "$2*sqrt(Beta/Epsilon) - (($1 * Alpha)/sqrt(Beta*Epsilon))}' >! $OUTPUTFILE
endif
