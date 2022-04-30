#!/bin/bash
tar -xzf R402.tar.gz
tar -xzf packages_all.tar.gz

# make sure the script will use your R installation,
# and the working directory as its home location
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

rm log/*.log
rm error/*.err
rm output/*.out

# run your script
Rscript question.R bing.csv nrc.csv wordcloud_y.csv wordcloud_n.csv
