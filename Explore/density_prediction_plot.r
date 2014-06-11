#=============================================================================
#
# This plots the density for the various
# input variables grouped according to
#
#   test / trainingset  and  b /  s
#
#=============================================================================

require(ggplot2)

load(file="../Processed/norm_dataset.rdata")

prediction <- read.table(
    "../Predictions/xgboost_120.csv", sep=",", header=TRUE)

dataset[dataset$test,"Label"] <- prediction$Class
dataset$foo <- interaction(dataset$Label, dataset$test)

factors <- labels(dataset)[2][[1]]
factors <- factors[grep("PRI|DER", factors)]

pdf("density_prediction_plot.pdf")
for (f in factors) {
    p1 <- ggplot(dataset[,c(f,"test","Label")], aes_string(x=f)) + 
        geom_density(aes(color=test))+facet_grid(~Label)
    print(p1)
}
dev.off()


#=============================================================================

