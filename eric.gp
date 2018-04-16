set title "Quadrupole Corrector Strength Error Example"
set xlabel "S Coordinate (m)"
set ylabel "s Value"
set grid
set term png font "Helvetica,14"
set output "quadStrengthErrorExample.png"
plot '/u/home/erict/git/JeffersonLabWork/chi2Dir/comparisons.fin' title "" w l lw 3 lc rgb "blue"
