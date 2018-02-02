#!/bin/tcsh

unset noclobber

#javac /a/devuser/erict/workspace/Miscellaneous/src/addLineNumbers.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ addLineNumbers information.twiasc unkicked.twiasc2 IPM1S05

grep 'IPM\|MQ' unkicked.twiasc2


