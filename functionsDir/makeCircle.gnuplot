a = 0
b = 0
r = 1

set title 'Unit Circle'
set xlabel 'X'
set ylabel 'X Prime'
set xrange [-1:1]
set yrange [-1:1]
set zeroaxis
set parametric
set samples 10+1

x(t) = a + r*cos(t)
y(t) = b + r*sin(t)

set table "circle.dat"
plot [0:2*pi] x(t),y(t) with points
unset table
