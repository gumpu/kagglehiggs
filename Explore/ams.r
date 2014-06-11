
load(file="../Processed/norm_dataset.rdata")

training <- dataset[dataset$test == FALSE,]
n <- nrow(training)


prediction <- rep('s', n)
s <- sum(training$Weight[(prediction=='s') & (training$Label=='s')])
b <- sum(training$Weight[(prediction=='s') & (training$Label=='b')])

br <- 10
AMS1 <- sqrt(2*((s+b+br)*log(1+s/(b+br))-s))

prediction <- training$Label
s <- sum(training$Weight[(prediction=='s') & (training$Label=='s')])
b <- sum(training$Weight[(prediction=='s') & (training$Label=='b')])

br <- 10
AMS2 <- sqrt(2*((s+b+br)*log(1+s/(b+br))-s))


