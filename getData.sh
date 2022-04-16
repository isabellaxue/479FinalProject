#!/bin/bash

wget http://snap.stanford.edu/data/amazon/productGraph/user_dedup.json.gz

gzip -d user_dedup.json.gz

awk 'NR%2789333==1{x="J"++i".json";}{print > x}' user_dedup.json