#!/bin/tcsh

# Print out statistical information
javac /a/devuser/erict/workspace/Miscellaneous/src/calculateStatistics.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ calculateStatistics $1
