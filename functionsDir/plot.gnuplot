set title 'Design Unit Circle'
set xlabel 'X'
set ylabel 'Y'

plot 'circle10.dat' using 1:2 title 'Design Unit Circle' with points

set table "circle10.png"
plot 'circle10.dat' using 1:2 title 'Design Unit Circle' with points
unset table
