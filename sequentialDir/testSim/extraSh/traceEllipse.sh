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
setenv TRIALS $9

setenv EMITTANCEBPM 1e-9

rm $BPMNAME.cen >& /dev/null
rm "$BPMNAME-WithBPMError.dat" >& /dev/null

echo "Using $CORRNAMEONE and $CORRNAMETWO to generate $N points at $BPMNAME"

# Determine if the correctors are verticle or horizontal
setenv VERTICLE `echo $CORRNAMEONE | grep -c "V"`

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
javac /a/devuser/erict/workspace/Miscellaneous/src/dxprimeCalculations.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ dxprimeCalculations

cat strengths.dat | awk -v c1=$CORRNAMEONE -v c2=$CORRNAMETWO -v BPMNAME=$BPMNAME -v BPMFILENAME=$BPMNAME '{ system("./setTwoCorrectorStrengths.sh "c1" "$1" "c2" "$2" "BPMNAME" "BPMFILENAME) }'

rm "$BPMNAME.dat" >& /dev/null

if($VERTICLE == 1)then
	awk '{print $4" "$5}' "$BPMNAME.cen" > "$BPMNAME.dat"
else
	awk '{print $2" "$3}' "$BPMNAME.cen" > "$BPMNAME.dat"
endif

# Plot the results
#gnuplot -persist -e "plot 'circle.fin' using 1:2 title 'Betatron Ellipse in Cartesian' with points"
#gnuplot -persist -e "plot '$BPMNAME.dat' using 1:2 title 'Betatron Ellipse at $BPMNAME' with points"

rm "$CORRNAMEONE-$CORRNAMETWO-strengths.dat"
# Conversion factor for the real machine

awk '{print $1*2.8*10^7" "$2*2.8*10^7}' strengths.dat > "$CORRNAMEONE-$CORRNAMETWO-strengths.dat"

# Subtract centroid values
setenv AVERAGECX `awk '{ sum += $1 } END { print sum/NR }' "$BPMNAME.dat"`
setenv AVERAGECY `awk '{ sum += $2 } END { print sum/NR }' "$BPMNAME.dat"`
echo "$AVERAGECX $AVERAGECY"
cat "$BPMNAME.dat" | awk -v averageCX=$AVERAGECX -v averageCY=$AVERAGECY '{ print ($1-averageCX)" "($2-averageCY)}' > temp.dat
mv temp.dat "$BPMNAME.dat"

# Generate error file for comparason
if($BPMERROR == 1 || $STRENGTHERROR == 1 || $DISPLACEMENTERROR == 1)then
./compileJava.sh
./floquet.sh "$BPMNAME.dat" "$BPMNAME.fin" $BETABPM $ALPHABPM $EMITTANCEBPM 0

rm "$BPMNAME-chiSquared.dat" >& /dev/null
touch "$BPMNAME-chiSquared.dat"

	@ x = 1
	while ($x <= $TRIALS)
		echo "Starting Trial: $x / $TRIALS"
		time ./traceEllipseWithError.sh $CORRNAMEONE $CORRNAMETWO $BPMNAME $N $CYCLES $BPMERROR $STRENGTHERROR $DISPLACEMENTERROR
		setenv CHISQUARED `./leastSquares.sh $BPMNAME "$BPMNAME.fin" "$BPMNAME-withError.fin"`
		echo "Chi squared for this trial: $CHISQUARED"
		echo $CHISQUARED >> "$BPMNAME-chiSquared.dat"
		#TODO CHANGE THE TITLE
		gnuplot -persist -e "plot '$BPMNAME-withError.fin' using 1:2 title 'Betatron Ellipse at $BPMNAME With Displacement Error' with linespoints, '$BPMNAME.fin' using 1:2 title 'Betatron Ellipse at $BPMNAME' with linespoints"
	@ x += 1
	end

	setenv AVERAGECHI `awk '{ sum += $1 } END { print sum/NR }' "$BPMNAME-chiSquared.dat"`

	echo "Average CHISQUARED: $AVERAGECHI"

	if($BPMERROR == 1 && $STRENGTHERROR == 0 && $DISPLACEMENTERROR == 0)then
		sed -i 's/BPM measurement uncertainty: .*$/BPM measurement uncertainty: '$AVERAGECHI'/' chiSquaredValues.dat
	endif
	if($BPMERROR == 0 && $STRENGTHERROR == 1 && $DISPLACEMENTERROR == 0)then
		sed -i 's/Quadrupole strength uncertainty: .*$/Quadrupole strength uncertainty: '$AVERAGECHI'/' chiSquaredValues.dat
	endif
	if($BPMERROR == 0 && $STRENGTHERROR == 0 && $DISPLACEMENTERROR == 1)then
		sed -i 's/Quadrupole displacement uncertainty: .*$/Quadrupole displacement uncertainty:  '$AVERAGECHI'/' chiSquaredValues.dat
	endif
endif

