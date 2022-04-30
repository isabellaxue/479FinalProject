rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 4){
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
df_both_model <- read.csv(df_q1, header = FALSE)
colnames(df_both_model) =c("prop", "rate")
bing_logit <- glm(rate~prop, data = df_both_model, family = "binomial")
summary(bing_logit)

bing_table <- summary(bing_logit)
bing_df <- data.frame(matrix(ncol = 1))
colnames(bing_df) <- 'p_value'
bing_df$p_value <- bing_table$coefficients[2,4]
bing_df$p_value <- format(bing_df$p_value , scientific = FALSE)

write.csv(bing_df, "lr_bing.csv")

#Question 2
nrc_both <- read.csv(df_q2, header = FALSE)
colnames(nrc_both) =c("row_num","nrcTrust","nrcFear","nrcNegative","nrcSadness","nrcAnger","nrcSurprise","nrcPositive","nrcDisgust",
                      "nrcJoy","nrcanticipation","rate")
nrc_logit <- glm(rate~nrcTrust + nrcFear + nrcNegative + nrcSadness + nrcAnger + nrcSurprise + nrcPositive + nrcDisgust + nrcJoy + nrcanticipation, data = nrc_both, family = "binomial")
summary(nrc_logit)

nrc_table <- summary(nrc_logit)
nrc_df <- data.frame(matrix(ncol = 10))
colnames(nrc_df) <- c('Trust_p','Fear_p','Negative_p','Sad_p','Anger_p','Surprise_p','Positive_p','Disgust_p','Joy_p','Anticipation_p')
nrc_df$Trust_p <- format(nrc_table$coefficients[2,4], scientific = FALSE)
nrc_df$Fear_p <- format(nrc_table$coefficients[3,4], scientific = FALSE)
nrc_df$Negative_p <- format(nrc_table$coefficients[4,4], scientific = FALSE)
nrc_df$Sad_p <- format(nrc_table$coefficients[5,4], scientific = FALSE)
nrc_df$Anger_p <- format(nrc_table$coefficients[6,4], scientific = FALSE)
nrc_df$Surprise_p <- format(nrc_table$coefficients[7,4], scientific = FALSE)
nrc_df$Positive_p <- format(nrc_table$coefficients[8,4], scientific = FALSE)
nrc_df$Disgust_p <- format(nrc_table$coefficients[9,4], scientific = FALSE)
nrc_df$Joy_p <- format(nrc_table$coefficients[10,4], scientific = FALSE)
nrc_df$Anticipation_p <- format(nrc_table$coefficients[11,4], scientific = FALSE)

write.csv(nrc_df, "lr_nrc.csv")

#Question 3
#words_yes <- read.csv(df_q3_y, quote = "", sep = " ", header = F,
#         stringsAsFactors = FALSE)
#words_yes <- read.csv(df_q3_n, quote = "", sep = " ", header = F,
#         stringsAsFactors = FALSE)
#cloud_n <- wordcloud2(words_no, color = "random-light", backgroundColor = "black")
#cloud_y <- wordcloud2(words_yes,  color='random-light', backgroundColor="grey")

#saveWidget(cloud_y,"cloud_y.html",selfcontained = F)
#saveWidget(cloud_n,"cloud_n.html",selfcontained = F)

# and in png or pdf
#webshot("cloud_y.html","cloud_y.png", delay =5, vwidth = 480, vheight=480)
#webshot("cloud_n.html","cloud_n.png", delay =5, vwidth = 480, vheight=480)
