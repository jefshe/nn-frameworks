library(data.table)
library(dplyr)
library(keras)


data <- fread('nn-frameworks/data/train2.csv')
train_idx <- sample(seq_len(nrow(data)),size=floor(0.8*nrow(data)))
train <- data[train_idx, ]
validation <- data[-train_idx,]

# Save precious precious memory
rm(data)
rm(train_idx)
gc()

# Desired input columns
categorical <- c("posa_continent", "hotel_continent", "hotel_country")
categorical_nclasses <- c(5, 7, 213)
numeric <- c("is_mobile", "is_package", "srch_adults_cnt", "srch_children_cnt", "srch_rm_cnt")

# training settings
batch_size = 128
epochs = 1

preprocess <- function(x) 
{
    t <- c()
    for (i in 1:length(categorical)) {
        t <- cbind(t, to_categorical(subset(x,select=categorical[i])[[1]], categorical_nclasses[i] ))
    }
    nums <- data.matrix(subset(x, select = numeric))
    colnames(nums) <- NULL
    cbind(nums,t)
}

generator <- function(dataset, size) 
{
    curr_n <- 1
    function() {
        rows <- curr_n:size
        x <- preprocess(dataset[rows,])
        
        curr_n <<- curr_n + size
        
        list(x, to_categorical(dataset$hotel_cluster[rows],100))
    }
}

model = keras_model_sequential() %>%
    layer_dense( 200 ,input_shape=230, activation='relu') %>%
    layer_dense( 100 , activation='softmax')

# RMSprop(lr=0.001, rho=0.9, epsilon=1e-08, decay=0.0)

model %>% compile(optimizer='rmsprop', loss='binary_crossentropy',metrics=c('accuracy'))

history <- model %>% 
    fit_generator(generator(train, batch_size), epochs=epochs, 
                  steps_per_epoch = floor(nrow(train)/batch_size), 
                  validation_data = generator(validation, batch_size), 
                  validation_steps = floor(nrow(validation)/batch_size))


