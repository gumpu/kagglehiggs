set.seed(76514345)

rm(list=ls())
require(e1071)

load(file="../Processed/norm_dataset.rdata")

response_label <- dataset[dataset$test==FALSE, "Label"]
dataset$Label  <- NULL

# Give NAs a value.
dataset[is.na(dataset)] <- 50

feature_subset <- grep("PRI_jet_num|DER", colnames(dataset), value=TRUE)
training <- dataset[dataset$test == FALSE, feature_subset]
idx <- sample.int(nrow(dataset),2000)
training <- training[idx, ]
response_label <- response_label[idx]


# Train
model <- svm(x=training, y=response_label)


