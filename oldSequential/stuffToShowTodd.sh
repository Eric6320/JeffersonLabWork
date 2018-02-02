#!/bin/tcsh

./cleanUp.sh unkicked modified
./simulate.sh
#./plotParabola.sh N=30, variance=50,
./plotPhase.sh
