#!/bin/tcsh
unset noclobber

#* Description: Uses MonteCarlo techniques to correct one or more simulated beamlines, correcting random strength errors to within a given tolerance
#* Argument: N - Number of orbits to include in the simulation
#* Argument: SEED - Seed used to generate consistent random numbers. Should be set to 0 to not use a seed
#* Argument: CORR1 - Name of the first quadrupole which is manipulated to trace out each orbit
#* Argument: CORR2 - Name of the second quadrupole which is manipulated to trace out each orbit
#* Argument: BPM1 - Name of the BPM whose Twiss parameters are used for the initial inverse Floquet Transformation
#* Argument: DESIGNBEAMLINE - Name of the unmodified 'design' beamline
#* Argument: MODIFIEDBEAMLINE - Name of the beamline which will have components modified throughout the process - ele, lte
#* Argument: STRENGTHERROR - Percentage that the strength of a given quadrupole will be modified by. EX, -1 means change the sign on the strength
#* Argument: CHANGE - Boolean value indicating whether or not the script is being called from within changeVResponse.sh
#* Argument: CHANGEQUAD - Quadrupole whose strength will be modified to determine a new CHI2DOF sum
#* Argument: CHANGEQUADSTRENGTH - Strength to which $CHANGEQUAD will be set to
#* Argument: CHANGEM - Transportation Matrix M element number to use use for CHI2DOF comparisons
#* Argument: TESTQUAD - Quadrupole whos strength will be changed, and the response will be measured
#* Argument: CHANGEM - Transport matrix element whose chi2dof comparisons will observed
#* Argument: GENERATE - 0 or 1 boolean value indicating whether or not to generate a new changeVResponse matrix between each trial
#* Argument: TOLERANCE - CHI2DOF tolerance at which testing stops
#* Argument: MAXTRIALS - Max number of changeVResponse matrices that will be generated before the minimization is stopped
#* Argument: NUMBEROFSEEDS - Number of random number seeds generated to be paired with random quadrupoles for testing
#* Argument: MONTECARLO - 0 or 1 boolean value indicating whether to run 1 test, or a monteCarlo simulation minimizing multiple beamlines
#* Example: ./minimizeBeamlineError.sh generate=1, monteCarlo=1, strengthError=-1,
#* Further Comments: Specifying an example with literally every argument is way too long, simply follow the setArg nomenclature for any additional variables.
#* Further Comments: $TESTQUAD will be overwritten from the monteCarloSeeds.dat file if MONTECARLO != x
#* Main Output: If $MONTECARLO == 1, "$FINALPATH/$TESTQUAD-$SEED.dat" for each $TESTQUAD-$SEED pair generated
#* Main Output: If $MONTECARLO != 1, Final CHI2DOF value printed to console

# Store base variables as command input or defaults
set N = `$FPATH/setArg.sh N 10 $argv`
set SEED = `$FPATH/setArg.sh seed 5 $argv`
set CORR1 = `$FPATH/setArg.sh corr1 MBT1S01V $argv`
set CORR2 = `$FPATH/setArg.sh corr2 MBT1S02V $argv`
set BPM1 = `$FPATH/setArg.sh bpm1 IPM1S03 $argv`
set DESIGNBEAMLINE = `$FPATH/setArg.sh designBeamline unkicked $argv`
set MODIFIEDBEAMLINE = `$FPATH/setArg.sh modifiedBeamline modified $argv`
set VERTICLE = `echo $CORR1 | grep -c "V"`

# These variables are only referenced if there is optimization needed
set STRENGTHERROR = `$FPATH/setArg.sh strengthError -1 $argv`
set TESTQUAD = `$FPATH/setArg.sh testQuad MQB1A29 $argv`

# Set variables controlling changeVResponse.sh script behavior
set CHANGEM = `$FPATH/setArg.sh changeM 3 $argv`
set GENERATE = `$FPATH/setArg.sh generate 0 $argv`
set TOLERANCE = `$FPATH/setArg.sh tolerance 3.5 $argv`
set MAXTRIALS = `$FPATH/setArg.sh maxTrials 5 $argv`
set NUMBEROFSEEDS = `$FPATH/setArg.sh numberOfSeeds 50 $argv`
set MONTECARLO = `$FPATH/setArg.sh monteCarlo x $argv`

# If the $MONTECARLO boolean is set
if ($MONTECARLO != x) then

	# Generate seeds for the Monte Carlo simulation
	$FPATH/generateMonteCarloSeeds.sh $NUMBEROFSEEDS $BPM1

	# While the monteCarloSeeds.dat file still contains $TESTQUAD-$SEED pairs,
	while (`wc -l "$RDPATH/monteCarloSeeds.dat" | awk '{print $1}'` > 0)
		# Set the $TESTQUAD and $SEED variables from the appropriate columns at the top of the data file
		set TESTQUAD = `cat "$RDPATH/monteCarloSeeds.dat" | head -1 | tail -1 | awk '{print $1}'`
		set SEED = `cat "$RDPATH/monteCarloSeeds.dat" | head -1 | tail -1 | awk '{print $2}'`
		
		# If the $TESTQUAD-$SEED pair does not exist, or has not been completely finished, minimize that beamline combination
		if (`grep -c "Trials required:" "$FINALPATH/$TESTQUAD-$SEED.dat"` != 1) then
			rm "$FINALPATH/$TESTQUAD-$SEED.dat" > /dev/null; touch "$FINALPATH/$TESTQUAD-$SEED.dat"
			echo "*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/$TESTQUAD-$SEED*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/" | tee -a "$FINALPATH/$TESTQUAD-$SEED.dat"
			$FPATH/correct.sh $N $SEED $CORR1 $CORR2 $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $STRENGTHERROR $TESTQUAD $CHANGEM $GENERATE $TOLERANCE $MAXTRIALS | tee -a "$FINALPATH/$TESTQUAD-$SEED.dat"
		else
			# Otherwise move on to the next $TESTQUAD-$SEED combination
			echo "$FINALPATH/$TESTQUAD-$SEED.dat already exists, moving to next file"
		endif

		#Remove the minimization attempt that just finished
		$FPATH/cutLineOffTopOrBottom.sh top 1 "$RDPATH/monteCarloSeeds.dat"
	end	
else
	# If MonteCarlo is not specified, minimize just one beamline with the specified values
	$FPATH/correct.sh $N $SEED $CORR1 $CORR2 $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $STRENGTHERROR $TESTQUAD $CHANGEM $GENERATE $TOLERANCE $MAXTRIALS
endif
