
# Read the predictions for the trainingset

# jetsplit <- read.table("../JetSplit/full_prediction.csv", sep=",", header=TRUE)
# ranfor   <- read.table("../RandomForest/full_prediction.csv", sep=",", header=TRUE)

# Read the predictions for the testset

model_names <- c("JetSplit", "RandomForest", "XGBoost")

jetsplit <- read.table("../JetSplit/test_prediction.csv", sep=",", header=TRUE)
ranfor   <- read.table("../RandomForest/test_prediction.csv", sep=",", header=TRUE)
xgboost  <- read.table("../XGBoost/test_prediction.csv", sep=",", header=TRUE)


# Train again on training set and the predictions for the training set.


# model <-

# Use the new model to make a prediction for the testset combined with the 
# original predictions.


