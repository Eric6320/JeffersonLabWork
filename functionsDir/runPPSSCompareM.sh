#!/bin/tcsh
unset noclobber

#* Description:
#* Argument: $1 - 
#* Argument: $2 - 
#* Argument: $3+ - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# Clear the chi2Dir 
rm -r $CHI2PATH/* >& /dev/null

# Set variables from command line arguments
set BPMONE = $1
set DESIGNFILE = $2
set MODIFIEDFILE = $3
set S = `$FPATH/pullS.sh $BPMONE`

echo "runPPSSCompareM.sh - Comparing Transportation Matrix Values"

# Generate ppss file containing each BPM downstream, each possible M number (1-4), and the names of the files containing Transportation Matrix values
rm compareM.ppss >& /dev/null; touch compareM.ppss
foreach x (1 2 3 4)
	echo "$x $DESIGNFILE $MODIFIEDFILE" >> compareM.ppss
end

# Run parallelCompareM.sh using compareM.ppss to compare each Transportation Matrix element at each downstream BPM
$FPATH/ppss -f 'compareM.ppss' -c "$FPATH/parallelCompareM.sh " -p 4 > /dev/null

paste -d " " downstreamBPM.dat $CHI2PATH/newComparison1.dat $CHI2PATH/newComparison2.dat $CHI2PATH/newComparison3.dat $CHI2PATH/newComparison4.dat >! $CHI2PATH/comparisons.fin

#Remove the line comparing the BPM to itself
cutLineOffTopOrBottom.sh top 1 $CHI2PATH/comparisons.fin

# Clear the job log
$FPATH/clearPPSSOutput.sh
