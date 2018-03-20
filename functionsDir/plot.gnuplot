set title 'S Plot'
set xlabel 'xAxis'
set ylabel 'yAxis'

plot 'plotM3.dat' using 1:2 title 'Downstream Error Example' with points

set table "plotM3.png"
plot 'plotM3.dat' using 1:2 title 'Downstream Error Example' with points
unset table
