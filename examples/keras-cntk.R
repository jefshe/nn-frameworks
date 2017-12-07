#library(data.table)
#setwd('kaggle')
#expedia_train <- fread('data/train.csv', header=TRUE)
#expedia_test <- fread('data/test.csv', header=TRUE)
rm(list=ls())
library(keras)

use_backend("cntk")

#separating train and test file
mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

# reshape - flatten images into 1d vector
data_shape = 784 # 28*28
x_train <- array_reshape(x_train, c(nrow(x_train), data_shape))
x_test <- array_reshape(x_test, c(nrow(x_test), data_shape))
# rescale
x_train <- x_train / 255
x_test <- x_test / 255

y_train <- to_categorical(y_train, 10)
y_test <- to_categorical(y_test, 10)

model <- keras_model_sequential() 
model %>% 
    layer_dense(units = 256, activation = 'relu', input_shape = c(data_shape)) %>% 
    layer_dropout(rate = 0.4) %>% 
    layer_dense(units = 128, activation = 'relu') %>%
    layer_dropout(rate = 0.3) %>%
    layer_dense(units = 10, activation = 'softmax')
summary(model)

model %>% compile(
    loss = 'categorical_crossentropy',
    optimizer = optimizer_rmsprop(),
    metrics = c('accuracy')
)

train_time <- Sys.time()
history <- model %>% fit(
    x_train, y_train, 
    epochs = 30, batch_size = 128, 
    validation_split = 0.2, verbose = 0
)
train_time <- Sys.time() - train_time


plot(history)
