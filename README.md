# JeffersonLabWork
General purpose for all of my jefferson lab code

# Directories

allStuff - Contains old, 'unsafe' parallel code that generates a 'correct' answer up to the end of the optimize.sh script. Used as a standard for comparison in
re-parallelizing the script correctly using ppss. Does not contain proper data file separation, and runs the possibility of generating too many threads.

rawDataDir - Contains the raw data files that searve as a starting point for the simulate.sh script. Anytime these files are referenced,
they are not modified. If a modified version of any file within this directory needs to be modified, a copy is modified and saved somewhere else instead.

javaFiles - Contains a symbolic link to an Eclipse workspace source directory. Within this source directory are all java files which are used in simulate.sh.

glossaryDir - Contains any bookkeeping files, such as file hiarchy or commenting structure. Most likely will be removed at the end of the project in favor
of a better documentation structure.

functionsDir - Contains all external scripts which are referenced within simulate.sh. Contains python and perl scripts, but the directory is primarily
tcshell scripts which perform a wide range of functions. Spanning from 'cleaning up' old data files, to setting environment variables.

ellipseDir - 
