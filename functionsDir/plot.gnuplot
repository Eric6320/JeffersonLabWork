set title 'Post Optimization Outlier Removed M Plot 3'
set xlabel 'S Coordinate'
set ylabel 'CHI2DOF'

plot 'plotM3.dat' using 1:2 title 'Post Optimization Outlier Removed M Plot 3' with points

set table "plotM3.png"
plot 'plotM3.dat' using 1:2 title 'Post Optimization Outlier Removed M Plot 3' with points
unset table
