#


# According to the training data.
signal_fraction <- c(0.25, 0.35, 0.50, 0.30)

predict_class <- function(jet_number) {
    # Load prediction made with xgboost
    filename <- sprintf("higgs_pred_%d.csv", jet_number)
    dataset <- read.table(filename, 
        sep=",", colClasses=c("integer","numeric"))

    # Reverse sort according to the predictions
    # and get the index numbers of the entries.
    V2.sorted <- sort(dataset$V2, decreasing=TRUE, index.return=TRUE)
    ix <- V2.sorted$ix
    n <- length(ix)

    signals <- floor(n*signal_fraction[jet_number+1])

    dataset$Class <- 'b'
    dataset[ix[1:signals],"Class"] <- 's'

    return(dataset)
}

all_jets <- lapply(0:3, predict_class)
prediction <- do.call("rbind", all_jets)
prediction$Class <- factor(prediction$Class)

# Now we compute the rank
# For this we sort all predictions, in increasing order
V2.sorted <- sort(prediction$V2, decreasing=FALSE, index.return=TRUE)
sorted_prediction <- prediction[V2.sorted$ix, ]
# and number them
sorted_prediction$RankOrder <- 1:(nrow(sorted_prediction))


kaggle_prediction <- data.frame(
    EventID=sorted_prediction$V1,
    RankOrder=sorted_prediction$RankOrder,
    Class=sorted_prediction$Class 
)


write.table(kaggle_prediction, file="test_prediction.csv", 
    sep=",", row.names=FALSE, quote=FALSE)

