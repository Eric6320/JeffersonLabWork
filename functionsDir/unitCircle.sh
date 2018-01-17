#!/bin/tcsh
unset noclobber

#* Description: Generates a unit circle out of N number of orbits
#* Argument: $1 - N - Number of orbits to include in the generated Unit Circle
#* Example: 

# Set number of points in the makeCircle gnuplot script
sed -i 's/set samples.*$/set samples '$1+1'/' $FPATH/makeCircle.gnuplot

# Run gnuplot script to generate a Circle.dat file with $1 number of evenly spaced data points
gnuplot $FPATH/makeCircle.gnuplot

# Remove the gnuplot header
cat "circle.dat" | awk 'NR>5 {print $1" "$2}' >! "circle$1.dat"; rm "circle.dat"
