#!/bin/bash

# untar your R installation
tar -xzf R402.tar.gz
#use package jsonlite, tidytext, tidyverse
tar -xzf packages_jsonlite_tidys.tar.gz

# make sure the script will use your R installation,
# and the working directory as its home location
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

#create log, error, output directory
#mkdir -p log error output

# run your script
Rscript data.R $1
# note: the two actual command-line arguments are in data.sub's "arguments = " line

