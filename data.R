rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  filename = args[1]
} else {
  cat('usage: Rscript data.R <filename>\n', file=stderr())
  stop()
}

library(jsonlite)
library(tidytext)
library(tidyverse)
library(stopwords)
library(textdata)

#Read json into dataframe
raw <- readLines(filename)

# add missing comma after }
n <- length(raw)
raw[-n] <- gsub("}", "},", raw[-n])
# add brakets at the beginning and end
raw <- c("[", raw, "]")

table <- jsonlite::fromJSON(raw, simplifyVector = FALSE)
table1 <- list()
for (i in 1:length(table)){
  if (length(table[[i]])==9) {
    table1 <- append(table1, list(table[[i]]))
  }
}
df <- as.data.frame(do.call(rbind, table1))
df<- data.frame(df)

#Tokenize reviews 
df1 <- df[, c(4, 5, 6)]

pos <- list()
neg <- list()
for (i in 1:nrow(df1)){
  pos <- append(pos,df1$helpful[i][[1]][[1]])
  neg <- append(neg,df1$helpful[i][[1]][[2]]-df1$helpful[i][[1]][[1]])
}
df1$pos <- NA
df1$neg <- NA
df1$diff <-NA
df1$rate <- NA
df1$pos <- pos
df1$neg <- neg
df1$diff <- unlist(df1$pos) - unlist(df1$neg)
df1 <- df1 %>% mutate(rate = case_when(diff > 0 ~ 1, diff <= 0 ~ 0))
df1$row_num <- seq.int(nrow(df1))

# yes_token <- df1 %>% filter(rate == 1) %>% unnest_tokens(word, reviewText)
# no_token <- df1 %>% filter(rate == 0) %>% unnest_tokens(word, reviewText)
# words_yes <- yes_token %>% count(word,sort=TRUE) 
# words_yes <- words_yes[1:10,]

df_token_yes <- df1 %>% filter(rate == 1) %>% unnest_tokens(word, reviewText) #helpful
df_token_no <- df1 %>% filter(rate == 0) %>% unnest_tokens(word, reviewText) #not helpful
df_token_yes = df_token_yes[,c(6,7,8)]
df_token_no = df_token_no[,c(6,7,8)]

word_num_yes <- df_token_yes %>% group_by(row_num) %>% summarize(count = n())
word_num_no <- df_token_no %>% group_by(row_num) %>% summarize(count = n())

#Question 1-Bing
bing <- get_sentiments("bing") %>% 
  mutate(neg= sentiment == "negative", 
         pos = sentiment =="positive")

df_helpful_yes = df_token_yes %>% 
  left_join(bing) %>% 
  group_by(row_num) %>% 
  summarize(bingNeg = sum(neg, na.rm = T),
            bingPos = sum(pos, na.rm = T),
            bingWords = bingNeg + bingPos) %>% 
  left_join(word_num_yes) %>% mutate(prop = bingWords/count)

df_helpful_yes = df_helpful_yes[6]
#df_helpful_yes$rate = rep(1, length(which(df1$rate == 1)))
df_helpful_yes$rate = rep(1, nrow(df_helpful_yes))

df_helpful_no = df_token_no %>% 
  left_join(bing) %>% 
  group_by(row_num) %>% 
  summarize(bingNeg = sum(neg, na.rm = T),
            bingPos = sum(pos, na.rm = T),
            bingWords = bingNeg + bingPos) %>%
  left_join(word_num_no) %>% mutate(prop = bingWords/count)

df_helpful_no = df_helpful_no[6]
df_helpful_no$rate = rep(0, nrow(df_helpful_no))

df_both_model = rbind(df_helpful_no, df_helpful_yes)
write_csv(df_both_model, paste("bing_",gsub(".json","",x=filename),".csv",sep = ""))


#Question 2-NRC
nrc = get_sentiments("nrc") %>% 
  rename(nrc = sentiment)

nrcWide = nrc %>% 
  mutate(value = 1) %>% 
  pivot_wider(word, names_from = nrc, values_fill = 0)

nrc_yes = df_token_yes %>% 
  left_join(nrcWide) %>% 
  group_by(row_num) %>% 
  summarize(
    nrcTrust = sum(trust, na.rm=T),
    nrcFear = sum(fear, na.rm=T),
    nrcNegative = sum(negative, na.rm=T),
    nrcSadness = sum(sadness, na.rm=T),
    nrcAnger = sum(anger, na.rm=T),
    nrcSurprise = sum(surprise, na.rm=T),
    nrcPositive = sum(positive, na.rm=T),
    nrcDisgust = sum(disgust, na.rm=T),
    nrcJoy = sum(joy, na.rm=T),
    nrcanticipation = sum(anticipation, na.rm=T)
  )

nrc_yes$rate = rep(1, nrow(df_helpful_yes))

nrc_no = df_token_no %>% 
  left_join(nrcWide) %>% 
  group_by(row_num) %>% 
  summarize(
    nrcTrust = sum(trust, na.rm=T),
    nrcFear = sum(fear, na.rm=T),
    nrcNegative = sum(negative, na.rm=T),
    nrcSadness = sum(sadness, na.rm=T),
    nrcAnger = sum(anger, na.rm=T),
    nrcSurprise = sum(surprise, na.rm=T),
    nrcPositive = sum(positive, na.rm=T),
    nrcDisgust = sum(disgust, na.rm=T),
    nrcJoy = sum(joy, na.rm=T),
    nrcanticipation = sum(anticipation, na.rm=T)
  )

nrc_no$rate = rep(0, nrow(df_helpful_no))
nrc_both = rbind(nrc_yes, nrc_no)
write_csv(nrc_both, paste("nrc_",gsub(".json","",x=filename),".csv",sep = ""))

#Question 3-wordcloud
#stopwords
garbage = stopwords::stopwords("en", source = "snowball")
for (i in 1:length(garbage)){
  garbage[i]=str_c(" ",garbage[i], " ")
}
garbage = append(garbage, " it.")
garbage = append(garbage, "I ")
garbage = append(garbage, "It ")
garbage = append(garbage, "The ")
garbage = append(garbage, "This ")
garbage = append(garbage, " one ")
garbage = append(garbage, "34")
for (i in 1:length(garbage)){
  df1$reviewText <- gsub(garbage[i], " ", df1$reviewText)
}

yes_token_1 <- df1 %>% filter(rate == 1) %>% unnest_tokens(word, reviewText)
no_token_1 <- df1 %>% filter(rate == 0) %>% unnest_tokens(word, reviewText)
words_yes <- yes_token_1 %>% count(word,sort=TRUE)
words_no <- no_token_1 %>% count(word,sort=TRUE)

#creating wordclouds
write_csv(words_yes, paste("wordcloud_y_",gsub(".json","",x=filename),".csv",sep = ""))
write_csv(words_no, paste("wordcloud_n_",gsub(".json","",x=filename),".csv",sep = ""))
