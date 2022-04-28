rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 3){
  df_q1 = args[1]
  df_q2 = args[2]
  df_q3_y = args[3]
  df_q3_n = args[4]
} else {
  cat('usage: Rscript data.R <df_q1><df_q2><df_q3>\n', file=stderr())
  stop()
}

library(wordcloud2)
library(htmlwidgets)

#Question 1
df_both_model <- read.csv(df_q1, header = TRUE)
bing_logit <- glm(rate~prop, data = df_both_model, family = "binomial")
summary(bing_logit)

bing_table <- summary(bing_logit)
bing_df <- data.frame(matrix(ncol = 1))
colnames(bing_df) <- 'p_value'
bing_df$p_value <- bing_table$coefficients[2,4]

#Question 2
nrc_both <- read.csv(df_q2, header = TRUE)
nrc_logit <- glm(rate~nrcTrust + nrcFear + nrcNegative + nrcSadness + nrcAnger + nrcSurprise + nrcPositive + nrcDisgust + nrcJoy + nrcanticipation, data = nrc_both, family = "binomial")
summary(nrc_logit)

nrc_table <- summary(nrc_logit)
nrc_df <- data.frame(matrix(ncol = 10))
colnames(nrc_df) <- c('Trust_p','Fear_p','Negative_p','Sad_p','Anger_p','Surprise_p','Positive_p','Disgust_p','Joy_p','Anticipation_p')
nrc_df$Trust_p <- nrc_table$coefficients[2,4]
nrc_df$Fear_p <- nrc_table$coefficients[3,4]
nrc_df$Negative_p <- nrc_table$coefficients[4,4]
nrc_df$Sad_p <- nrc_table$coefficients[5,4]
nrc_df$Anger_p <- nrc_table$coefficients[6,4]
nrc_df$Surprise_p <- nrc_table$coefficients[7,4]
nrc_df$Positive_p <- nrc_table$coefficients[8,4]
nrc_df$Disgust_p <- nrc_table$coefficients[9,4]
nrc_df$Joy_p <- nrc_table$coefficients[10,4]
nrc_df$Anticipation_p <- nrc_table$coefficients[11,4]

#Question 3
cloud_n <- wordcloud2(df_q3_n, color = "random-light", backgroundColor = "black")
cloud_y <- wordcloud2(words_yes,  color='random-light', backgroundColor="grey")
# save it in html
saveWidget(cloud_y,"cloud_y.html",selfcontained = F)
saveWidget(cloud_n,"cloud_n.html",selfcontained = F)
# and in png or pdf
#webshot("cloud_y.html","cloud_y.png", delay =5, vwidth = 480, vheight=480)
#webshot("cloud_n.html","cloud_n.png", delay =5, vwidth = 480, vheight=480)


