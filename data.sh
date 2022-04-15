#!/bin/bash

module load R/R-4.0.1 # tell execute computer where to find R software

RpackagesDir="R/library" # the R script will install packages here
mkdir --parents "$RpackagesDir" # make directory & parents; no error if exists

Rscript data.R "$RpackagesDir"
