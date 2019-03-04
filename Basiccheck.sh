#!/bin/bash

dirname=$1
exename=$2
shift 2
rest=$@
cdir=$(pwd)
cd
cd $dirname
make
lans=$?
if [ $lans -eq 0 ]; then
		valgrind --leak-check=full --error-exitcode=1 ./$exename $rest
		valerr=$?
		valgrind --tool=helgrind --error-exitcode=1 ./$exename $rest
		helerr=$?
else
		lans=1
		valerr=1
		helerr=1
fi



echo "Results: Compilation: " $lans "Memory Leak: " $valerr " Thread Race: " $helerr 

lans=$((lans*4))
valerr=$((valerr*2))

errorID=$((lans+valerr+helerr))
echo $errorID
cd 
cd $cdir
