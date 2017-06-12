#!/bin/bash

#mainly to debug locally
if [ -z $SERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi
if [ -z $ENV ]; then export ENV=IUHPC; fi

#clean up previous job (just in case)
rm -f finished
jobid=`qsub $SERVICE_DIR/submit.pbs`
echo $jobid > jobid

