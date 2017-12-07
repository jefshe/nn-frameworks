library(data.table)
setwd('kaggle')
expedia_train <- fread('data/train.csv', header=TRUE)
expedia_test <- fread('data/test.csv', header=TRUE)