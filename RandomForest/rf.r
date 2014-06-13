
set.seed(19671111)
require(randomForest)

load(file="../Processed/norm_dataset.rdata")

# Give NAs a value. Except for the Label NAs,
# otherwise randomForest will complain in the predict phase.
response_label <- dataset[dataset$test==FALSE, "Label"]
dataset$Label <- NULL
dataset[is.na(dataset)] <- -999

feature_subset <- grep("PRI|DER", colnames(dataset), value=TRUE)
training <- dataset[dataset$test == FALSE, feature_subset]

# Train
model <- randomForest(
    x=training, y=response_label, 
    ntree=50, do.trace=TRUE)


# Predict
testset <- dataset[dataset$test == TRUE, feature_subset]
yp <- predict(model, testset, type="prob")

kaggle_prediction <- data.frame( 
    EventID=dataset[dataset$test == TRUE, "EventId"],
    RankOrder=0,
    Class=ifelse(yp[,'s']>0.5, 's', 'b')
)

# Sort according to 's' probability so we can have a RankOrder.
s_prob <- yp[,'s']
sorted_prob <- sort(s_prob, decreasing=FALSE, index.return=TRUE)

kaggle_prediction <- kaggle_prediction[sorted_prob$ix,]
kaggle_prediction$RankOrder <- 1:nrow(kaggle_prediction)

signal_percentage <- function(no_s, no_b) {
    100.0*(no_s/(no_s+no_b))
}


write.table(kaggle_prediction, file="full_prediction.csv",
    sep=",", row.names=FALSE, quote=FALSE)

# Scored     2.87001
# TODO Compute AMS
#
