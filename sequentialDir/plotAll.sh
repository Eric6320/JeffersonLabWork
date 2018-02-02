#!/bin/tcsh

gnuplot -persist -e "plot 'testFile1.dat' with points title 'Single column data'"

exit
gnuplot -persist -e "plot 'circle.dat' using 1:2 title 'Unit Circle' with points"
gnuplot -persist -e "plot 'ellipseA.dat' using 1:2 title 'Betatron Ellipse One in Cartesian' with points"
gnuplot -persist -e "plot 'ellipseB.dat' using 1:2 title 'Betatron Ellipse Two in Cartesian' with points"
