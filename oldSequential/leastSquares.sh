#!/bin/tcsh

rm final.chi >& /dev/null

setenv FILEONE $1
setenv FILETWO $2

#12) Run Chi Squared Per Degree of Freedom Evaluation
paste -d " " $FILEONE $FILETWO > final.chi

setenv CHISQUARED `awk '{ sum += (($3-$1)^2 + ($4-$2)^2)} END { print sum }' final.chi`

echo $CHISQUARED
