set title 'Optimized Chi2dof of M with outlier removed 3'
set xlabel 'S Coordinate'
set ylabel 'CHI2DOF'

plot 'plotM3.dat' using 1:2 title 'Optimized Chi2dof of M with outlier removed 3' with points

set table "plotM3.png"
plot 'plotM3.dat' using 1:2 title 'Optimized Chi2dof of M with outlier removed 3' with points
unset table
