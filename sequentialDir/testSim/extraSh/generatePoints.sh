#!/bin/tcsh

# Store the bpm name, number of particles, and whether the kickers are verticle or horizontal as variables
setenv VERTICLE $1
setenv BPMNAME $2
setenv N $3
setenv CYCLES $4
setenv BETA $5
setenv ALPHA $6
setenv EMITTANCE $7

setenv S `grep $BPMNAME unkicked.twiasc | awk '{print $1}'`

# Set number of points in the makeCircle gnuplot script
sed -i 's/set samples.*$/set samples '$N'/' makeCircle.gnuplot
sed -i 's/cycles =.*$/cycles = '$CYCLES'/' makeCircle.gnuplot

# Run gnuplot script to generate a Circle.dat file with $N number of evenly spaced data points
echo "Generating $N points around $CYCLES cycles on the Unit Circle"
gnuplot makeCircle.gnuplot

# Perform Inverse Floquet Transformation to place the Unit Circle points onto a Betatron Ellipse
./floquet.sh circle.dat circle.fin $BETA $ALPHA $EMITTANCE 1
#cat circle.dat | awk -v Beta=$BETA -v Epsilon=$EMITTANCE -v Alpha=$ALPHA 'NR>=0&&NR<=4 {print $0} NR>4 {print $1*sqrt(Beta*Epsilon)" "sqrt(Epsilon/Beta) * ($2 + $1*Alpha)}' > circle.fin

#gnuplot -persist -e "plot 'circle.dat' using 1:2 title 'Unit Circle' with points"
#gnuplot -persist -e "plot 'circle.fin' using 1:2 title 'Betatron Ellipse in Cartesian' with points"
