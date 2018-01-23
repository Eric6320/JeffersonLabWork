#!/bin/tcsh
unset noclobber

#* Description: Main file used to perform all control optimization funcntions. Generates a Unit Circle, transforms to a betatron ellipse,calculates the strengths necessary to trace the points on the ellipse,
#* Description: Adds strenght error if necessary, traces the betatron ellipse given the calculated strengths, performs SVD pseudoinverse to determine transformation matrices,
#* Description: Calculates CHI2DOF for those transformation matrices, identifies problematic quadrupole, then optimizes the quadrupole strength to correct the beams orbit
#* Argument: N - Number of orbits to include in the simulation
#* Argument: SEED - Seed used to generate consistent random numbers. Should be set to 0 to not use a seed
#* Argument: CORR1 - Name of the first quadrupole which is manipulated to trace out each orbit
#* Argument: CORR2 - Name of the second quadrupole which is manipulated to trace out each orbit
#* Argument: BPM1 - Name of the BPM whose Twiss parameters are used for the initial inverse Floquet Transformation
#* Argument: DESIGNBEAMLINE - Name of the unmodified 'design' beamline
#* Argument: MODIFIEDBEAMLINE - Name of the beamline which will have components modified throughout the process - ele, lte
#* Argument: STRENGTHERROR - Percentage that the strength of a given quadrupole will be modified by. EX, -1 means change the sign on the strength
#* Example: ./simulate.sh N=10, seed=5, corr1=MBT1S01V, corr2=MBT1SO2V, bpm1=IPM1S03, designBeamline=unkicked, modifiedBeamline=modified, strengthError=-1,;
#* Further Comments: Variables stored within a script are all upper case, however variables passed in from the command line assume camel casing
#* Main Output: Quadrupole strength change values

# Store variables as command input or defaults
set N = `$FPATH/setArg.sh N 10 $argv`
set SEED = `$FPATH/setArg.sh seed 5 $argv`
set CORR1 = `$FPATH/setArg.sh corr1 MBT1S01V $argv`
set CORR2 = `$FPATH/setArg.sh corr2 MBT1S02V $argv`
set BPM1 = `$FPATH/setArg.sh bpm1 IPM1S03 $argv`
set DESIGNBEAMLINE = `$FPATH/setArg.sh designBeamline unkicked $argv`
set MODIFIEDBEAMLINE = `$FPATH/setArg.sh modifiedBeamline modified $argv`
set VERTICLE = `echo $CORR1 | grep -c "V"`
set STRENGTHERROR = `$FPATH/setArg.sh strengthError -1 $argv`

# Remove all excess data files from the main directory, and auxillary folders in preparation for a new run
$FPATH/cleanUp.sh
set S = `$FPATH/pullS.sh $BPM1 $DESIGNBEAMLINE`

# Print all of the above variables to the terminal
echo "\nN = $N\nSeed = $SEED\ncorr1 = $CORR1\ncorr2 = $CORR2\nbpm1 = $BPM1\ndesignBeamline = $DESIGNBEAMLINE\nmodifiedBeamline = $MODIFIEDBEAMLINE\nverticle = $VERTICLE\nstrengthError = $STRENGTHERROR\n"

# Generate a unit circle and perform a floquet transformation at the specified bpm
#* Output: $MODIFIEDBEAMLINE"EllipseOne.dat" - Coordinate pairs of design betatron ellipse
$FPATH/setup.sh $BPM1 $N $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $S

# Using the twiss parameters at the given BPM, determine the strengths needed to trace the design ellipse
#* Output: $MODIFIEDBEAMLINE"Strengths.dat"
$FPATH/determineStrengths.sh $BPM1 $CORR1 $CORR2 $VERTICLE $MODIFIEDBEAMLINE

# Add scalar error to Quadrupole Strengths if applicable
if ($STRENGTHERROR != x) then
	echo "addStrengthError.sh - Adding strength error"
	set NEWQUADSTRENGTH = `$FPATH/addStrengthError.sh MQB1A29 $STRENGTHERROR $MODIFIEDBEAMLINE $SEED`
endif

# Using the design strengths, trace the ellipse and determine the centroid values
#* Output: centroidValuesDir/*BPM*CentroidValues.dat
$FPATH/runPPSSElegant.sh $N $MODIFIEDBEAMLINE $CORR1 $CORR2 $VERTICLE

# Sanity check to ensure that modified values do not vary wildly from the design #TODO INCLUDE DETERMINANT CHECK AND MOVE AFTER PSEUDOINVERSE CODE
$FPATH/sanityCheck.sh $BPM1"CentroidValues.dat" $BPM1 $N $VERTICLE "floquet" "plot"
exit

$FPATH/runPPSSPseudoinverse.sh $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE
#$FPATH/catPPSSOutput.sh


# Determine the transformation matrix M for the modified ellipses - modified.mat
runParallelPseudoinverse.sh $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE

# Calculate the CHI2DOF between each of the M matrix elements - comparison*.fin
runParallelCompareM.sh $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE



#./plotPhase.sh $BPM1 $N $VERTICLE,
#./plotM.sh M=3,title=Pre-Corrected Chi2dof of M,
#./findOutlier.sh 3 remove
#./plotM.sh M=3,title=Outlier removed Pre-Corrected Chi2dof of M,

#./plotParabola.sh N=50,

if ($STRENGTHERROR != x) then
	echo "Target strength = $NEWQUADSTRENGTH"
	echo "Function"
	function.sh MQB1A29 $NEWQUADSTRENGTH "IPM1R02" $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE
	echo "runParallelCompareM"
	runParallelCompareM.sh $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE
	echo "Find Outlier"
	findOutlier.sh 3 remove
#	./plotM.sh M=3,title=Fixed Chi2dof of M with outlier removed,
	echo "Optimize"
	optimize.sh MQB1A29 "IPM1R02" $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE
	echo "runParallelCompareM"
	runParallelCompareM.sh $BPM1 $DESIGNBEAMLINE $MODIFIEDBEAMLINE
	echo "FindOutlier"
	findOutlier.sh 3 remove
#	./plotM.sh M=3,title=Optimized Chi2dof of M with outlier removed,
endif
