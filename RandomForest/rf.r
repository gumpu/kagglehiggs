
set.seed(19671111)
require(randomForest)

load(file="../Processed/norm_dataset.rdata")

ll <- dataset$Label
# Give NAs a value. Except for the Label NA,
# otherwise randomForest will complain in the predict phase.
dataset$Label <- NULL
dataset[is.na(dataset)] <- -999
dataset$Label <- ll

feature_subset <- grep("PRI|DER",colnames(dataset),value=TRUE)

training <- dataset[dataset$test == FALSE, c(feature_subset,"Label")]

model <- randomForest( Label~., training, ntree=50, do.trace=TRUE)

signal_percentage <- function(no_s, no_b) {
    100.0*(no_s/(no_s+no_b))
}

testset <- dataset[dataset$test == TRUE, feature_subset]
yp <- predict(model, testset, type="prob")

kaggle_prediction <- data.frame( 
    EventID=dataset[dataset$test == TRUE, "EventId"],
    RankOrder=0,
    Class=ifelse(yp[,'s']>0.5,'s','b')
)

s_prob <- yp[,'s']
sorted_prob <- sort(s_prob, decreasing=FALSE, index.return=TRUE)

kaggle_prediction <- kaggle_prediction[sorted_prob$ix,]
kaggle_prediction$RankOrder <- 1:nrow(kaggle_prediction)

write.table(kaggle_prediction, file="full_prediction.csv", 
    sep=",", row.names=FALSE, quote=FALSE)

# Scored     2.87001
