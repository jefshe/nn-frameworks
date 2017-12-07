library(data.table)
library(tidyverse)
library(lubridate)
types = c("date_time"="POSIXct")
#expedia_train <- fread('nn-frameworks/data/train.csv', header=TRUE)
#expedia_test <- fread('nn-frameworks/data/test.csv', header=TRUE)
# save new dataset to make it run faster in the future
expedia_train <- fread("nn-frameworks/data/train2.csv", colClasses = types )
expedian_test <- fread("nn-frameworks/data/test2.csv")




