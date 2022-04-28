#!/bin/bash
tar -xzf R402.tar.gz
#use package wordcloud2, stopwords
tar -xzf packages_cloud_color_stop.tar.gz

export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

#Question 1
cat bing_*.csv > bing.csv

#Question 2
cat nrc_*.csv > nrc.csv

#Question 3
cat wordcloud_y_*.csv > wordcloud_y.csv
cat wordcloud_n_*.csv > wordcloud_n.csv
R script -e "yes = read.csv('wordcloud_y.csv',header=T); \
             no = read.csv('wordcloud_n.csv',header=T); \
             yes = aggregate(yes$n, list(yes$word), FUN=sum); \
             no = aggregate(no$n, list(no$word), FUN=sum); \
             write.csv(yes, 'wordcloud_y.csv', col.names = TRUE); \
             write.csv(no, 'wordcloud_n.csv', col.names = TRUE);"

# run your script
Rscript question.R bing.csv nrc.csv wordcloud_y.csv wordcloud_n.csv
