

load(file="../Processed/norm_dataset.rdata")

split_dataset <- split(dataset, f=dataset$PRI_jet_num)

# Given a column name and a data frame checks
# whether all values in the column are NA
col_is_na <- function(col_name, a_dataframe=NULL) {
    all(is.na(a_dataframe[,col_name]))
}

for (datasubset in split_dataset) {
    col_names <- colnames(datasubset)
    # Find all columns that are all NA
    na_columns <- vapply( X=col_names, FUN=col_is_na, 
                          FUN.VALUE=FALSE, a_dataframe=datasubset)
    # Remove these from the dataframe
    datasubset <- datasubset[,!na_columns]
    jet_number <- datasubset[1,"PRI_jet_num"]
    datasubset$PRI_jet_num <- NULL

    # Write results into seperate training and testing files.
    train_filename <- paste(paste("training",jet_number,sep="_"),"csv",sep=".")
    test_filename  <- paste(paste("test",jet_number,sep="_"),"csv",sep=".")
    training <- datasubset[datasubset$test==FALSE,]
    training$test <- NULL
    testing <- datasubset[datasubset$test==TRUE,]
    testing$test <- NULL
    print(dim(testing))
    write.table(training, 
        file=train_filename, sep=",",
        row.names=FALSE, quote=FALSE, na="-999")
    write.table(testing, 
        file=test_filename, sep=",",
        row.names=FALSE, quote=FALSE, na="-999")
}

