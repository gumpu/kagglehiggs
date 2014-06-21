# vi: spell spl=en
#
set.seed(19671111)
require(randomForest)

load(file="../Processed/norm_dataset.rdata")

response_label <- dataset[dataset$test==FALSE, "Label"]
dataset$Label  <- NULL

# Give NAs a value.
# TODO This needs something better
dataset[is.na(dataset)] <- -999

feature_subset <- grep("PRI|DER", colnames(dataset), value=TRUE)
training <- dataset[dataset$test == FALSE, feature_subset]

# Train
model <- randomForest(
    x=training, y=response_label, 
    ntree=60, do.trace=TRUE)

# Make ntree to low and there won't be predictions for all
# values.


# Also save the predictions for the training set.
train_prediction <- data.frame(
    Class=model$predicted,
    b_vote=model$votes[,'b'],
    s_vote=model$votes[,'s']
)

# Save prediction to file
write.table(train_prediction, file="train_prediction.csv",
    sep=",", row.names=FALSE, quote=FALSE)


# Use the model to make a prediction for the
# test set.
testset <- dataset[dataset$test == TRUE, feature_subset]
yp <- predict(model, testset, type="prob")

test_prediction <- data.frame( 
    EventID=dataset[dataset$test == TRUE, "EventId"],
    RankOrder=0,
    Class=ifelse(yp[,'s']>=0.5, 's', 'b')
)

# Sort according to 's' probability so we can have a RankOrder.
s_prob <- yp[,'s']
sorted_prob <- sort(s_prob, decreasing=FALSE, index.return=TRUE)

# Rearrange the prediction such that the most certain 's' predictions
# are on top.
test_prediction <- test_prediction[sorted_prob$ix,]
test_prediction$RankOrder <- 1:nrow(test_prediction)

# Save prediction to file
write.table(test_prediction, file="test_prediction.csv",
    sep=",", row.names=FALSE, quote=FALSE)

#=============================================================================
# Some statistics

signal_percentage <- function(no_s, no_b) {
    100.0*(no_s/(no_s+no_b))
}
signal_count <- table(test_prediction$Class)
s_pec <- signal_percentage(signal_count['s'], signal_count['b'])
print(sprintf("Signal percentage %f", s_pec))

prediction <- model$predicted
weight <- dataset[dataset$test == FALSE, "Weight"]
s <- sum(weight[(prediction=='s') & (response_label=='s')])
b <- sum(weight[(prediction=='s') & (response_label=='b')])
br <- 10
ams <- sqrt(2*((s+b+br)*log(1+s/(b+br))-s))

print(sprintf("Training AMS %f", ams))

# Scored     2.87001
#            2.76866   (Only jet_num and DER)
#
