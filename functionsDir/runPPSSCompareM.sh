#!bin/tcsh
unset noclobber

# Set arguments
set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3
set S = `pullS.sh $BPMONE`

rm compareM.ppss >& /dev/null; touch compareM.ppss

# Make ppss file
foreach x (1 2 3 4)
	foreach i (`grep 'IPM' "downstreamMBPM.dat" | awk '{print $1}'`)
		echo "$i $x $DESIGNBEAMLINE $MODIFIEDBEAMLINE" >> compareM.ppss
	end
end

# Run parallel functions
$FPATH/ppss -f 'compareM.ppss' -c '$FPATH/parallelCompareM.sh '

# Recompile data TODO this needs to be revised to actually apply to the framework given
echo "Recompiling Comparison Files"
foreach i (1 2 3 4)
	rm "newComparison$i.dat" >& /dev/null
	touch "newComparison$i.dat"
	cat `grep "IPM" "downstreamBPM.dat" | awk -v directory=mDir$i '{print directory"/parallel-"$1".dat"}'` >> "newComparison$i.dat"
end

paste -d " " downstreamBPM.dat newComparison1.dat newComparison2.dat newComparison3.dat newComparison4.dat >! newComparisons.fin

#Remove the line comparing the BPM to itself
cutLineOffTopOrBottom.sh top 1 newComparisons.fin
#sed -i '1d' newComparisons.fin
mv newComparisons.fin comparisons.fin

rm -r mDir* >& /dev/null
