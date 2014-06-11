
trainset <- read.table("../Raw/training.csv", sep=",", header=TRUE)
trainset[trainset == -999] <- NA

testset  <- read.table("../Raw/test.csv", sep=",", header=TRUE)
testset[testset == -999] <- NA

trainset$test <- FALSE
testset$test  <- TRUE

testset$Label  <- NA
testset$Weight <- NA

dataset <- rbind(trainset,testset)

save(dataset, file="../Processed/dataset.rdata")

# Transform variable to the range [0,100]
normalize <- function(x) {
    minv <- min(x, na.rm=TRUE)
    maxv <- max(x, na.rm=TRUE)
    x <- (x - minv) / (maxv - minv)
    x <- 100*x
    return(x)
}

# EventId

dataset$DER_mass_MMC <- normalize(dataset$DER_mass_MMC)
dataset$DER_mass_transverse_met_lep <- normalize( dataset$DER_mass_transverse_met_lep)
dataset$DER_mass_vis <- normalize(dataset$DER_mass_vis)
dataset$DER_pt_h <- normalize(dataset$DER_pt_h)
dataset$DER_deltaeta_jet_jet <- normalize(dataset$DER_deltaeta_jet_jet)
dataset$DER_mass_jet_jet <- normalize(dataset$DER_mass_jet_jet)
dataset$DER_prodeta_jet_jet <- normalize(dataset$DER_prodeta_jet_jet)
dataset$DER_deltar_tau_lep <- normalize(dataset$DER_deltar_tau_lep)
dataset$DER_pt_tot <- normalize(dataset$DER_pt_tot)
dataset$DER_sum_pt <- normalize(dataset$DER_sum_pt)
dataset$DER_pt_ratio_lep_tau <- normalize(dataset$DER_pt_ratio_lep_tau)
dataset$DER_met_phi_centrality <- normalize(dataset$DER_met_phi_centrality)
dataset$DER_lep_eta_centrality <- normalize(dataset$DER_lep_eta_centrality)
dataset$PRI_tau_pt <- normalize(dataset$PRI_tau_pt)
dataset$PRI_tau_eta <- normalize(dataset$PRI_tau_eta)
dataset$PRI_tau_phi <- normalize(dataset$PRI_tau_phi)
dataset$PRI_lep_pt <- normalize(dataset$PRI_lep_pt)
dataset$PRI_lep_eta <- normalize(dataset$PRI_lep_eta)
dataset$PRI_lep_phi <- normalize(dataset$PRI_lep_phi)
dataset$PRI_met <- normalize(dataset$PRI_met)
dataset$PRI_met_phi <- normalize(dataset$PRI_met_phi)
dataset$PRI_met_sumet <- normalize(dataset$PRI_met_sumet)

if (0) {
    dataset$PRI_jet_num <- normalize(dataset$PRI_jet_num)
}

dataset$PRI_jet_leading_pt <- normalize(dataset$PRI_jet_leading_pt)
dataset$PRI_jet_leading_eta <- normalize(dataset$PRI_jet_leading_eta)
dataset$PRI_jet_leading_phi <- normalize(dataset$PRI_jet_leading_phi)
dataset$PRI_jet_subleading_pt <- normalize(dataset$PRI_jet_subleading_pt)
dataset$PRI_jet_subleading_eta <- normalize(dataset$PRI_jet_subleading_eta)
dataset$PRI_jet_subleading_phi <- normalize(dataset$PRI_jet_subleading_phi)
dataset$PRI_jet_all_pt <- normalize(dataset$PRI_jet_all_pt)

# Weight
# Label
# test

save(dataset, file="../Processed/norm_dataset.rdata")

testset  <- dataset[dataset$test==TRUE,]
trainset <- dataset[dataset$test==FALSE,]
testset$test   <- NULL
testset$Label  <- NULL
testset$Weight <- NULL
trainset$test  <- NULL
write.table(trainset, 
    file="../Processed/training.csv", sep=",",
    row.names=FALSE, quote=FALSE, na="-999")
write.table(testset, 
    file="../Processed/test.csv", sep=",",
    row.names=FALSE, quote=FALSE, na="-999")

