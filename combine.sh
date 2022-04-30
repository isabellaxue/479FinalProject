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

#Question 1
sed -i '1d' bing_*.csv
cat bing_*.csv > bing.csv

#Question 2
sed -i '1d' nrc_*.csv
cat nrc_*.csv > nrc.csv

#Question 3
sed -i '1d' wordcloud_y_*.csv
cat wordcloud_y_*.csv |
awk -F "," '{a[$1]+=$2}END{for(i in a) print i,a[i]}' > wordcloud_y.csv

sed -i '1d' wordcloud_n_*.csv
cat wordcloud_n_*.csv |
awk -F "," '{a[$1]+=$2}END{for(i in a) print i,a[i]}' > wordcloud_n.csv
