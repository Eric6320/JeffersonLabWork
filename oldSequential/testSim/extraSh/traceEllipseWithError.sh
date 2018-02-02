#!/bin/tcsh

# Run Clean Up Script
./traceCleanUp.sh

# Pass in the two corrector names, bpm name, and number of particles, save as variables.
setenv CORRNAMEONE $1
setenv CORRNAMETWO $2
setenv BPMNAME $3
setenv N $4
setenv CYCLES $5

setenv BPMERROR $6
setenv STRENGTHERROR $7
setenv DISPLACEMENTERROR $8

setenv EMITTANCEBPM 1e-9

rm $BPMNAME.cen >& /dev/null
rm "$BPMNAME-WithBPMError.dat" >& /dev/null

echo "Using $CORRNAMEONE and $CORRNAMETWO to generate $N points at $BPMNAME"

# Determine if the correctors are verticle or horizontal
setenv VERTICLE `echo $CORRNAMEONE | grep -c "V"`

#TODO Verify Create Error Files
./addError.sh $N $DISPLACEMENTERROR

if ($DISPLACEMENTERROR == 1) then
	cp unkicked.lte unkickedTemp.lte
	mv unkicked2.lte unkicked.lte
endif

# Run elegant on the unkicked data
elegant unkicked.ele >& /dev/null

# Set static twiss parameters and s coordinate of
sdds2stream -col=s,ElementName,alphax,alphay,betax,betay,psix,psiy unkicked.twi > unkicked.twiasc2
cat unkicked.twiasc2 | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "((1+($3)^2)/$5)" "((1+($4)^2)/$6)" "$7" "$8}' > unkicked.twiasc

if($VERTICLE == 1)then
	setenv ALPHAONE `grep $CORRNAMEONE unkicked.twiasc | awk '{print $4}'`		
	setenv ALPHATWO `grep $CORRNAMETWO unkicked.twiasc | awk '{print $4}'`		
	setenv ALPHABPM `grep $BPMNAME unkicked.twiasc | awk '{print $4}'`		
	setenv BETAONE `grep $CORRNAMEONE unkicked.twiasc | awk '{print $6}'`		
	setenv BETATWO `grep $CORRNAMETWO unkicked.twiasc | awk '{print $6}'`		
	setenv BETABPM `grep $BPMNAME unkicked.twiasc | awk '{print $6}'`		
	setenv GAMMABPM `grep $BPMNAME unkicked.twiasc | awk '{print $8}'`
	setenv PSIONE `grep $CORRNAMEONE unkicked.twiasc | awk '{print $10}'`
	setenv PSITWO `grep $CORRNAMETWO unkicked.twiasc | awk '{print $10}'`
	setenv PSIBPM `grep $BPMNAME unkicked.twiasc | awk '{print $10}'`

else
	setenv ALPHAONE `grep $CORRNAMEONE unkicked.twiasc | awk '{print $3}'`		
	setenv ALPHATWO `grep $CORRNAMETWO unkicked.twiasc | awk '{print $3}'`		
	setenv ALPHABPM `grep $BPMNAME unkicked.twiasc | awk '{print $3}'`		
	setenv BETAONE `grep $CORRNAMEONE unkicked.twiasc | awk '{print $5}'`		
	setenv BETATWO `grep $CORRNAMETWO unkicked.twiasc | awk '{print $5}'`		
	setenv BETABPM `grep $BPMNAME unkicked.twiasc | awk '{print $5}'`		
	setenv GAMMABPM `grep $BPMNAME unkicked.twiasc | awk '{print $7}'`
	setenv PSIONE `grep $CORRNAMEONE unkicked.twiasc | awk '{print $9}'`
	setenv PSITWO `grep $CORRNAMETWO unkicked.twiasc | awk '{print $9}'`	
	setenv PSIBPM `grep $BPMNAME unkicked.twiasc | awk '{print $9}'`

endif

# Determine ellipse to fit data to
./generatePoints.sh $VERTICLE $BPMNAME $N $CYCLES $BETABPM $ALPHABPM $EMITTANCEBPM

cat circle.fin | awk -v Abpm=$ALPHABPM -v B1=$BETAONE -v B2=$BETATWO -v Bbpm=$BETABPM -v P1=$PSIONE -v P2=$PSITWO -v Pbpm=$PSIBPM ' NR>4 {print $1" "$2" "Abpm" "B1" "B2" "Bbpm" "P1" "P2" "Pbpm}' > betatronPositions.dat


# calculate necessary kicker strengths and angles to hit each target in the circle.fin file
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ dxprimeCalculations

# add in quadrupole strength errors
if ($STRENGTHERROR == 1)then
rm strengthError.dat >& /dev/null
rm strengthsWithError.dat >& /dev/null

	java -cp /a/devuser/erict/workspace/Miscellaneous/src/ strengthError strengths.dat strengthError.dat

	paste -d " " strengths.dat strengthError.dat > strengthsWithError.dat
	rm strengths.dat
	cat strengthsWithError.dat | awk '{print ($1+$3)" "($2+$4)}' > strengths.dat
endif

rm "$BPMNAME-withError.cen" >& /dev/null
cat strengths.dat | awk -v c1=$CORRNAMEONE -v c2=$CORRNAMETWO -v BPMNAME=$BPMNAME -v BPMFILENAME="$BPMNAME-withError" '{ system("./setTwoCorrectorStrengths.sh "c1" "$1" "c2" "$2" "BPMNAME" "BPMFILENAME) }'

rm "$BPMNAME-withError.dat"
if ($BPMERROR == 1)then
	rm "$BPMNAME-PasteWithBPMError.dat"
	paste -d " " "$BPMNAME-withError.cen" bpmError.dat bpmError2.dat > "$BPMNAME-PasteWithBPMError.dat"
	if($VERTICLE == 1)then
		awk '{print ($4+$7)" "($5+$8)}' "$BPMNAME-PasteWithBPMError.dat" > "$BPMNAME-withError.dat"
	else
		awk '{print ($2+$7)" "($3+$8)}' "$BPMNAME-PasteWithBPMError.dat" > "$BPMNAME-withError.dat"
	endif
else
	if($VERTICLE == 1)then
		awk '{print $4" "$5}' "$BPMNAME-withError.cen" > "$BPMNAME-withError.dat"
	else
		awk '{print $2" "$3}' "$BPMNAME-withError.cen" > "$BPMNAME-withError.dat"
	endif
endif

# Subtract centroid values
setenv AVERAGECX `awk '{ sum += $1 } END { print sum/NR }' "$BPMNAME-withError.dat"`
setenv AVERAGECY `awk '{ sum += $2 } END { print sum/NR }' "$BPMNAME-withError.dat"`
cat "$BPMNAME-withError.dat" | awk -v averageCX=$AVERAGECX -v averageCY=$AVERAGECY '{ print ($1-averageCX)" "($2-averageCY)}' > temp.dat
mv temp.dat "$BPMNAME-withError.dat"

#gnuplot -persist -e "plot '$BPMNAME-withError.dat' using 1:2 title 'Betatron Ellipse at $BPMNAME With Error' with points"
#gnuplot -persist -e "plot '$BPMNAME.dat' using 1:2 title 'Betatron Ellipse at $BPMNAME' with points"
gnuplot -persist -e "plot '$BPMNAME-withError.dat' using 1:2 title 'Betatron Ellipse at $BPMNAME With Displacement Error' with linespoints, '$BPMNAME.dat' using 1:2 title 'Betatron Ellipse at $BPMNAME' with linespoints"

./floquet.sh "$BPMNAME-withError.dat" "$BPMNAME-withError.fin" $BETABPM $ALPHABPM $EMITTANCEBPM 0

# Conversion factor for the real machine
rm "$CORRNAMEONE-$CORRNAMETWO-strengths.dat"
awk '{print $1*2.8*10^7" "$2*2.8*10^7}' strengths.dat > "$CORRNAMEONE-$CORRNAMETWO-strengths.dat"

if ($DISPLACEMENTERROR == 1) then
	mv unkickedTemp.lte unkicked.lte
endif
