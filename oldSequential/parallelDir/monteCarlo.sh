#!/bin/tcsh

./resetUnkicked.sh >& /dev/null

setenv BPMNAMEONE `./setVariable.sh bpm1 IPM1R09 $argv` 
setenv ERRORTYPE `./setVariable.sh errorType bpm $argv`
setenv ERRORTOLERANCE `./setVariable.sh errorTolerance 0.00005 $argv`
setenv TRIALS `./setVariable.sh trials 3 $argv`
setenv SEED `./setVariable.sh seed 0 $argv`
setenv SCRIPT `./setVariable.sh script foreachBPM $argv`

# Generate a data file containing a $TRIALS number of positive gaussian distributed error tolerances
rm tolerances.fin >& /dev/null
./createScalarGaussian.sh 1 $TRIALS $ERRORTOLERANCE tolerances .dat $SEED
cat tolerances1.dat | awk '{print (sqrt($1*$1))}' > tolerances.fin


setenv ERROR "$ERRORTYPE"'Error='

rm mcOutputFile.fin >& /dev/null; touch mcOutputFile.fin
printf "%-20s %-20s\n" "Error Tolerance" "Average Chi2DOF" >> mcOutputFile.fin
cat tolerances.fin | awk -v Error=$ERROR -v bpmNameOne=$BPMNAMEONE -v script=$SCRIPT -v Trials=$TRIALS '{ system("./"script".sh "Error$1" bpm1="bpmNameOne" monteCarlo=1 trialnumber="NR" totalTrials="Trials" | tee mcOutputFile.dat") }'

gedit mcOutputFile.fin

./plotMonteCarlo.sh
