#!/bin/tcsh
unset noclobber

# TODO DONE

# Set number of points in the makeCircle gnuplot script
sed -i 's/set samples.*$/set samples '$1+1'/' "makeCircle.gnuplot"

# Run gnuplot script to generate a Circle.dat file with $1 number of evenly spaced data points
gnuplot makeCircle.gnuplot

# Remove the gnuplot header
cat "circle.dat" | awk 'NR>5 {print $1" "$2}' >! "circle$1.dat"
