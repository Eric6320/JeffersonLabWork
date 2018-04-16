# JeffersonLabWork
General purpose for all of my jefferson lab code

# Directories

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
