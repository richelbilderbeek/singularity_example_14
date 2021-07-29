#!/bin/bash
#singularity exec singularity_2.sif Rscript script.R
cat script.R | singularity exec singularity_2.sif R --vanilla --silent --no-echo
