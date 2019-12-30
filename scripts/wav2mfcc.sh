#!/bin/bash

## \file
## \TODO This file implements a very trivial feature extraction; use it as a template for other front ends.
## 
## Please, read SPTK documentation and some papers in order to implement more advanced front ends.

# Base name for temporary files
base=/tmp/$(basename $0).$$ 

# Ensure cleanup of temporary files on exit
trap cleanup EXIT
cleanup() {
   \rm -f $base.*
}

if [[ $# != 4 ]]; then
   echo "no va"
   echo "$0 mfcc_order num_filtros input.wav output.mcp"
   exit 1
fi

mfcc_order=$1
num_filtros=$2
inputfile=$3
outputfile=$4


UBUNTU_SPTK=0
if [[ $UBUNTU_SPTK == 1 ]]; then
   # In case you install SPTK using debian package (apt-get)
   X2X="sptk x2x"
   FRAME="sptk frame"
   WINDOW="sptk window"
   MFCC='sptk mfcc'
else
   # or install SPTK building it from its source
   X2X="x2x"
   FRAME="frame"
   WINDOW="window"
   MFCC='mfcc'
fi

# Main command for feature extration
sox $inputfile -t raw - dither -p 12 | $X2X +sf | $FRAME -l 200 -p 40 | $WINDOW -l 200 -L 200 |
$MFCC -l 200 -m $mfcc_order -n $num_filtros -s 8 -w 1 > $base.mfcc # num de banco de filtros > mfcc_order
# 50%

# Our array files need a header with the number of cols and rows:
ncol=$((mfcc_order))
nrow=`$X2X +fa < $base.mfcc | wc -l | perl -ne 'print $_/'$ncol', "\n";'`

# Build fmatrix file by placing nrow and ncol in front, and the data after them
echo $nrow $ncol | $X2X +aI > $outputfile
cat $base.mfcc >> $outputfile

exit
