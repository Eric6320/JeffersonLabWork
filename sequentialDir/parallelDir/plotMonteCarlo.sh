#!/bin/tcsh

tail -n +2 mcOutputFile.fin > ellipseTemp.fin; mv ellipseTemp.fin mcOutputFile.fin

gnuplot -persist -e "plot 'mcOutputFile.fin' using 1:2 title 'Chi2DOF distribution' with points"
