#!/bin/tcsh

rm unkicked.twiasc >& /dev/null
rm unkicked.twiasc2 >& /dev/null
rm circle.dat >& /dev/null
rm circle.fin >& /dev/null
rm tempInformation.dat >& /dev/null
rm betatronPositions.dat >& /dev/null
rm strengths.dat >& /dev/null
rm machineStrengths.dat >& /dev/null
rm bpmError.dat >& /dev/null
rm bpmError2.dat >& /dev/null
rm strengthsWithError.dat >& /dev/null
touch strengthError.dat
touch strengths.dat

echo "Clean up finished"
