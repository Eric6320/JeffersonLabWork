#!/bin/tcsh
unset noclobber

# Store variables as command input or defaults
set N = `setArg.sh N 10 $argv`
set SEED = `setArg.sh seed 5 $argv`
set CORR1 = `setArg.sh corr1 MBT1S01V $argv`
set CORR2 = `setArg.sh corr2 MBT1S02V $argv`
set BPM1 = `setArg.sh bpm1 IPM1S03 $argv`
set DESIGNBEAMLINE = `setArg.sh designBeamline unkicked $argv`
set MODIFIEDBEAMLINE = `setArg.sh modifiedBeamline modified $argv`
set BPMERROR = `setArg.sh bpmError x $argv`
set STRENGTHERROR = `setArg.sh strengthError -1 $argv`

cd ~/toddElegant/thesisWork/parallelDir

./simulate.sh N=$N, seed=$SEED, corr1=$CORR1, corr2=$CORR2, bpm1=$BPM1, designBeamline=$DESIGNBEAMLINE, modifiedBeamline=$MODIFIEDBEAMLINE, bpmError=$BPMERROR, strengthError=$STRENGTHERROR,

cd ~/toddElegant/thesisWork/testSim
