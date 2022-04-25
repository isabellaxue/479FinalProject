rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  filename = args[1]
} else {
  cat('usage: Rscript data.R <filename>\n', file=stderr())
  stop()
}

library(jsonlite)

raw <- readLines(filename)

# add missing comma after }
n <- length(raw)
raw[-n] <- gsub("}", "},", raw[-n])
# add brakets at the beginning and end
raw <- c("[", raw, "]")

table <- jsonlite::fromJSON(raw, simplifyVector = FALSE)
df <- as.data.frame(do.call(rbind, table))
df2 <- apply(df,2,as.character)
df<- data.frame(df2)

head(df)
