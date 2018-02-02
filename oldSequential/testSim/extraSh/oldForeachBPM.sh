#!/bin/tcsh

# Store the bpm name, number of particles, and whether the kickers are verticle or horizontal as variables
setenv BPMNAMEONE $1
setenv N $2
setenv SEED $3
setenv ERRORTYPE "no error"

# Set error type and value if applicable
if ($#argv >= 5)then
	setenv ERRORTYPE $4
	setenv ERRORVALUE $5
	setenv ARGUMENTS {"$N","$SEED","$ERRORTYPE","$ERRORVALUE"}
else
	setenv ARGUMENTS {"$N","$SEED"}
endif

rm unkicked.twiasc unkicked.temp >& /dev/null
sdds2stream -col=s,ElementName unkicked.twi > unkicked.twiasc
setenv SCORRONE `grep -w $BPMNAMEONE unkicked.twiasc | awk '{print $1}'`

grep 'IPM' unkicked.twiasc | awk -v S=$SCORRONE '{if ($1 > S) print $2}' > unkicked.temp && mv unkicked.temp unkicked.twiasc

rm chi2DOFValues.* >& /dev/null
touch chi2DOFValues.dat
#3) Run each found BPM through the main.sh script
foreach x (`grep 'IPM' unkicked.twiasc`)
	setenv CHI2DOF `./main.sh $BPMNAMEONE $x $ARGUMENTS`
	echo $CHI2DOF
	echo $CHI2DOF >> chi2DOFValues.dat
end

#Make chi2DOF readable to the statistics calculator
cat chi2DOFValues.dat | awk '{print $3}' > chi2DOFValues.fin

echo "$ERRORTYPE --------------------------------------------------------------------------------------------------------"
echo `./calculateStatistics.sh chi2DOFValues.fin` | awk '{print $2}'
