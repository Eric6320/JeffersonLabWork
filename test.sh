#!/bin/tcsh
unset noclobber

# Generate 'baseline' chi matrix
# Output: $CHANGEPATH/matrixX.fin
grep -F -f $CHANGEPATH/nextBPM.dat $CHI2PATH/comparisons.fin | awk -v M=3 '{print $(2+M)}'

# Generate 'baseline' chi matrix
# Output: $CHANGEPATH/matrixX.fin
grep -f $CHANGEPATH/nextBPM.dat $CHI2PATH/comparisons.fin | awk -v M=3 '{print $(2+M)}'
