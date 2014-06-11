#=============================================================================
#
# This plots the density for the various
# input variables grouped according to
#
#   test / trainingset
#
#=============================================================================

require(ggplot2)

load(file="../Processed/norm_dataset.rdata")

factors <- labels(dataset)[2][[1]]
factors <- factors[grep("PRI|DER", factors)]

pdf("density_plot.pdf")
for (f in factors) {
    p1 <- ggplot(dataset[,c(f,"test","Label")], aes_string(x=f)) + 
        geom_density(aes(color=test))
    print(p1)
}
dev.off()


#=============================================================================

