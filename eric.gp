set title "Quadrupole Corrector Strength Error Example"
set xlabel "S Coordinate (m)"
set ylabel "s Value"
set grid
set term png font "Times-Roman,14"
set output "quadStrengthErrorExample.png"
plot '/a/devuser/erict/git/JeffersonLabWork/chi2Dir/comparisons.fin' using 2:5 title "" w l lw 3 lc rgb "blue"
