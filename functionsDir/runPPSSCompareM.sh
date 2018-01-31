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







#TODO for some reason the files from parallelCompareM.sh are not being generated correctly. Check mValuesDir/ and for some reason some file names are getting screwed up should be parallel$M-$BPM.dat








# Recompile data
echo "Recompiling Comparison Files"
foreach M (1 2 3 4)
	rm "$MPATH/newComparison$M.dat" >& /dev/null
	touch "$MPATH/newComparison$M.dat"
	cat `grep "IPM" "downstreamBPM.dat" | awk -v M=$M -v path=$MPATH '{print path"/parallel"M"-"$1".dat"}'` >> "$MPATH/newComparison$M.dat"
end

exit

paste -d " " downstreamBPM.dat newComparison1.dat newComparison2.dat newComparison3.dat newComparison4.dat >! newComparisons.fin

#Remove the line comparing the BPM to itself
cutLineOffTopOrBottom.sh top 1 newComparisons.fin
#sed -i '1d' newComparisons.fin
mv newComparisons.fin comparisons.fin

rm -r mDir* >& /dev/null
