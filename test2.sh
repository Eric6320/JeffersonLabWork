#!/bin/tcsh
unset noclobber



if (`grep "Trials required:" "$FINALPATH/$TESTQUAD-$SEED.dat"` != 1) then
	rm "$FINALPATH/$TESTQUAD-$SEED.dat" > /dev/null; touch "$FINALPATH/$TESTQUAD-$SEED.dat"
	echo "*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/$TESTQUAD-$SEED*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/" | tee -a "$FINALPATH/$TESTQUAD-$SEED.dat"
	$FPATH/correct.sh $N $SEED $CORR1 $CORR2 $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $STRENGTHERROR $TESTQUAD $CHANGEM $GENERATE $TOLERANCE $MAXTRIALS | tee -a "$FINALPATH/$TESTQUAD-$SEED.dat"
else
	echo "$FINALPATH/$TESTQUAD-$SEED.dat already exists, moving to next file"
endif
