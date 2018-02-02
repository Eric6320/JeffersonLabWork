#!/bin/tcsh

./cleanUp.sh

#1) Pass in two arguments, Corrector Name and Kick Strength
setenv CORRNAME $1
setenv KICKSTRENGTH $2
setenv VERTICLE `echo $CORRNAME | grep -c "V"`

#2) Run elegant on the unkicked data
elegant unkicked.ele >& /dev/null

#3) Save unkicked Cx and Cy to file
sdds2stream -col=s,Cx,Cy unkicked.cen > unkicked.dat

#4) Edit .lte file and change kick strength of CORRNAME to KICKSTRENGTH
perl modifyCorrector.pl unkicked.lte kicked.lte $CORRNAME $KICKSTRENGTH >& /dev/null

#5) Re-run elegant on the kicked data
elegant kicked.ele >& /dev/null

#6) Set static beta and psi corr values
sdds2stream -col=ElementName,betax,psix,betay,psiy,s unkicked.twi > unkicked.twiasc

setenv Scorr `grep $CORRNAME unkicked.twiasc | awk '{print $6}'`
setenv Bxcorr `grep $CORRNAME unkicked.twiasc | awk '{print $2}'`
setenv Bycorr `grep $CORRNAME unkicked.twiasc | awk '{print $4}'`
setenv Psixcorr `grep $CORRNAME unkicked.twiasc | awk '{print $3}'`
setenv Psiycorr `grep $CORRNAME unkicked.twiasc | awk '{print $5}'`

#7) Save kicked Cx and Cy to file
sdds2stream -col=s,Cx,Cy unkicked.cen > kicked.dat

#8) Stitch together the simulation files
paste -d " " unkicked.dat kicked.dat > final.dat

#9) Calculate the simulated dx by subtracting the unkicked Centroid values from the kicked Centroid values
cat final.dat | awk '{print $1" "(($5-$2))" "(($6-$3))}' > final.dif

#10) Calculate the theoretical dx with the formula dx[mm] = kick[mrad] * sqrt(betax_corr betax_obs) * sin(psix_obs - psix_corr)
sed -i 's/set title.*$/set title '"'"$CORRNAME"'"'/' plotOrbits.gnuplot
sed -i 's/Plots\/.*$/Plots\/'"$CORRNAME"'.png"/' plotOrbits.gnuplot

if($VERTICLE == 1)then
	cat unkicked.twiasc | awk -v kickstrength=$KICKSTRENGTH -v Bcorr=$Bycorr -v Psicorr=$Psiycorr -v Scorr=$Scorr '{printf("%22s %10s\n",$6,(($6-Scorr>0) ? (kickstrength*sqrt($4*Bcorr)*sin($5-Psicorr)) : (0.0)))}' > final.the
	sed -i 's/'final.dif' using 1:2/'final.dif' using 1:3/' plotOrbits.gnuplot
else
	cat unkicked.twiasc | awk -v kickstrength=$KICKSTRENGTH -v Bcorr=$Bxcorr -v Psicorr=$Psixcorr -v Scorr=$Scorr '{printf("%22s %10s\n",$6,(($6-Scorr>0) ? (kickstrength*sqrt($2*Bcorr)*sin($3-Psicorr)) : (0.0)))}' > final.the
	sed -i 's/1:3/1:2/' plotOrbits.gnuplot
endif

#Plot The results
gnuplot plotOrbits.gnuplot

#11) Stitch together the simulation and theory files
paste -d " " final.dif final.the > final.chi

#12) Run Chi Squared Per Degree of Freedom Evaluation
if($VERTICLE == 1)then
	setenv CHI `awk '{ sum += (($3-$5)^2)} END { print sum }' final.chi`
else
	setenv CHI `awk '{ sum += (($2-$5)^2)} END { print sum }' final.chi`
endif	
	echo "Chi squared per degree of freedom value for $CORRNAME is: $CHI"
