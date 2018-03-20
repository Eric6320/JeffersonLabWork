set title 'Downstream Error Example'
set xlabel 'S Coordinate'
set ylabel 'CHI2DOF'

plot 'plotM3.dat' using 1:2 title 'Downstream Error Example' with points

set table "plotM3.png"
plot 'plotM3.dat' using 1:2 title 'Downstream Error Example' with points
unset table
