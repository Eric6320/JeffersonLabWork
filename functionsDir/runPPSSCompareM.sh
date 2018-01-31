#!/bin/tcsh
unset noclobber

# Set arguments
set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3
set S = `$FPATH/pullS.sh $BPMONE`

echo "runPPSSCompareM.sh - Comparing Transportation Matrix Values"
rm compareM.ppss >& /dev/null; touch compareM.ppss

# Make ppss file
foreach x (1 2 3 4)
	foreach i (`grep 'IPM' "downstreamBPM.dat" | awk '{print $1}'`)
		echo "$i $x $DESIGNBEAMLINE $MODIFIEDBEAMLINE" >> compareM.ppss
	end
end

# Run parallel functions
$FPATH/ppss -f 'compareM.ppss' -c "$FPATH/parallelCompareM.sh "

# Recompile data
foreach M (1 2 3 4)
	rm "$CHI2PATH/newComparison$M.dat" >& /dev/null
	touch "$CHI2PATH/newComparison$M.dat"
	cat `grep "IPM" "downstreamBPM.dat" | awk -v M=$M -v path=$CHI2PATH '{print path"/parallel"M"-"$1".dat"}'` >> "$CHI2PATH/newComparison$M.dat"
end

paste -d " " downstreamBPM.dat $CHI2PATH/newComparison1.dat $CHI2PATH/newComparison2.dat $CHI2PATH/newComparison3.dat $CHI2PATH/newComparison4.dat >! $CHI2PATH/comparisons.fin

#Remove the line comparing the BPM to itself
cutLineOffTopOrBottom.sh top 1 $CHI2PATH/comparisons.fin
