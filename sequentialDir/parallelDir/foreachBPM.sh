#!/bin/tcsh

setenv TRIALNUMBER `./setVariable.sh trialnumber N/A $argv`
setenv TOTALTRIALS `./setVariable.sh totalTrials N/A $argv`
echo "Trial: $TRIALNUMBER/$TOTALTRIALS-------------------------------------------------------------------------------------------------"
# Store variables as command input or defaults
setenv BPMNAMEONE `./setVariable.sh bpm1 IPM1S00 $argv`
setenv SEED `./setVariable.sh seed 0 $argv`
setenv N `./setVariable.sh N 20 $argv`
setenv BPMERROR `./setVariable.sh bpmError 0 $argv`
setenv STRENGTHERROR `./setVariable.sh strengthError 0 $argv`
setenv MONTECARLO `./setVariable.sh monteCarlo 0 $argv`

# Pull the S coordinates and Element Names from the twiss file and store in a .twiasc file
rm unkicked.twiasc unkicked.temp >& /dev/null
sdds2stream -col=s,ElementName unkicked.twi > unkicked.twiasc

# Determine the first BPM's S coordinate, then keep only those BPM downstream
setenv SCORRONE `grep -w $BPMNAMEONE unkicked.twiasc | awk '{print $1}'`
grep 'IPM' unkicked.twiasc | awk -v S=$SCORRONE '{if ($1 > S) print $2}' > unkicked.temp && mv unkicked.temp unkicked.twiasc

# Determine list chi2DOF list for all downstream BPM
rm chi2DOFValues.* >& /dev/null
touch chi2DOFValues.dat

foreach x (`grep 'IPM' unkicked.twiasc`)
	setenv CHI2DOF `./main.sh bpm1=$BPMNAMEONE bpm2=$x seed=$SEED N=$N bpmError=$BPMERROR strengthError=$STRENGTHERROR`
	echo $CHI2DOF
	echo $CHI2DOF >> chi2DOFValues.dat
end

# Make chi2DOF readable to the statistics calculator
cat chi2DOFValues.dat | awk '{print $3}' > chi2DOFValues.fin

#echo "--------------------------------------------------------------------------------------------------------"
./calculateStatistics.sh chi2DOFValues.fin

if ($MONTECARLO) then
	if ($BPMERROR != 0)then
		setenv ERRORCOLUMN $BPMERROR
	else
		setenv ERRORCOLUMN $STRENGTHERROR
	endif

	setenv AVERAGECHI2COLUMN `cat mcOutputFile.dat | grep "Average" | awk '{print $2}'`
	printf "%-20s %-20s\n" $ERRORCOLUMN $AVERAGECHI2COLUMN >> mcOutputFile.fin
endif
