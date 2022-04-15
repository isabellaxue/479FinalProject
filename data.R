rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  RpackagesDir = args[1]
} else {
  cat('usage: Rscript singleR.R <RpackagesDir>\n', file=stderr())
  stop()
}

# Tell R to search in RpackagesDir, in addition to where it already
# was searching, for installed R packages.
.libPaths(new=c(RpackagesDir, .libPaths()))
if (!require("jsonlite")) { # If loading package fails ...
  # Install package in RpackagesDir.
  install.packages(pkgs="jsonlite", lib=RpackagesDir, repos="https://cran.r-project.org")
  stopifnot(require("jsonlite")) # If loading still fails, quit.
}

#Code
library(jsonlite)

raw <- readLines("F1.json")

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



