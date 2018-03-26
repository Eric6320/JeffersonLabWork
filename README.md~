# JeffersonLabWork
General purpose for all of my jefferson lab code

# Directories

oldParallel - Contains old, 'unsafe' parallel code that generates a 'correct' answer up to the end of the optimize.sh script. Used as a standard for comparison in
re-parallelizing the script correctly using ppss. Does not contain proper data file separation, and runs the possibility of generating too many threads.

sequentialDir - Contains old, sequential code for generating a 'correct' answer up to the end of the optimize.sh script. Used as a standard for comparison in
re-parallelizing the script correctly running ppss, as well as to show speedup improvements. Does not contain proper data file seperation.

rawDataDir - Contains the raw data files that searve as a starting point for the simulate.sh script. Anytime these files are referenced,
they are not modified. If a modified version of any file within this directory needs to be modified, a copy is modified and saved somewhere else instead.

javaFiles - Contains all relevant java and class files.

glossaryDir - Contains any bookkeeping files, such as file hiarchy or commenting structure. Most likely will be removed at the end of the project in favor
of a better documentation structure.

functionsDir - Contains all external scripts which are referenced within simulate.sh. Contains python and perl scripts, but the directory is primarily
tcshell scripts which perform a wide range of functions. Spanning from 'cleaning up' old data files, to setting environment variables.

ellipseDir - Contains output files from runPPSSPseudoinverse.sh, which contain transportation matrix M values. These values are later combined into a
$MODIFIEDBEAMLINE.mat data file, which is used for further chi2dof comparisons.

elegantPPSSDir - Contains an elegant generated set of beamline information for each $N number of beamlines. This beamline information is used to generate centroid
value pairs, which are combined at each BPM.

centroidValuesDir - Contains $N number of centroid value pairs within a data file for each BPM downstream of the initial reference BPM. These files are later
formatted to run a Singular Value Decomposition Pseudoinverse.

chi2Dir - Contains all transportation matrix CHI2DOF calculations in separate data files, and the final compilation in comparisons.fin. These files are later
referenced for use in optimize.sh

optimizeDir - Contains all beamline information needed for optimization. Only the files within this directory are modified.

changeDir - Contains all the changeVResponse matrix information, such as M and X matrix files, as well as their raw data file components.


/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/* READ FROM HERE DOWN TODD /*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*

# Testing Instructions

The first thing you should do is: `cat functionsDir/setEnv.sh` then copy paste all of those setenv commands. If those $PATH variables are not set, nothing will run correctly.

Debug Test 1)

run `./simulate.sh strengthError=-1,`

Be sure to include the comma after any tag/value arguments, or else the arguments will not be set properly and the script will freeze / hang indefinitely. strengthError=-1, flips the quad strength of a pre-set quadrupole. This script contains 90% of the project's important code, generating ellipses, calculating transport matrices, determining chi2dof comparisons, etc. If there is some kind of memory or CPU usage problem, it is most likely contained somewhere in simulate.sh within:

runPPSSElegant.sh
runPPSSPseudoinverse.sh
runPPSSCompare.sh

I've found that this script typically takes anywhere from 11 seconds, to 1-2 minutes to run fully. If it takes much longer I usually assume something is wrong.

Debug Test 2)

run `functionsDir/minimizeBeamlineError.sh strengthError=-1, generate=1,`

generate=1, means calculate new changeVResponse matrices between each iteration. This script uses changeVResponse matrix calculation to minimize the beamline, attempting 5 iterations before giving up. There are 55 elements in the beamline, meaning that ./simulate.sh is run 55 times. 1 iteration can take anywhere between 15 minutes to 1 hour depending on how fast ./simulate.sh is running. The time of each ./simulate.sh call should print to the console.

Debug Test 3)

run `functionsDir/minimizeBeamlineError.sh strengthError=-1, generate=1, monteCarlo=1,`

monteCarlo=1, means generate a list of 3 different quadrupoles with a pre-set number of seeds each, serving as 3 * X beamlines to attempt to minimize. 1 is the default number of seeds, meaning 3 different beamlines would be optimized. However, if you wanted to increase this number all you have to do is add 'numberOfSeeds=x,' to the argument line (without the single quotes, replacing x with whatever number you wanted). This command attempts to minimize multiple different beamlines sequentially, printing to both the console, and a the rawDataDir/testLog.fin file.

Usually it is while running Debug Test 2 or 3 that things start to slow down, and I can never figure out why. Hopefully you are able to figure out more than I can
