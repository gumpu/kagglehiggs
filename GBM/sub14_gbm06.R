# Based on the code by Edgar Granados posted in the forum.
#
library(gbm)
rm(list = ls(all = TRUE))
gc()

#globals

SEED = 51

b_tau <- 10
s_val = 1
b_val = 0
vsize = .10
na_val = -999
n_trees = 500

AMS <-function(pred,real,weight ) {
  #a = table(pred,real)
  pred_s_ind = which(pred==s_val)
  real_s_ind = which(real==s_val)
  real_b_ind = which(real==b_val)
  s = sum(weight[intersect(pred_s_ind,real_s_ind)])
  b = sum(weight[intersect(pred_s_ind,real_b_ind)])

  ans = sqrt(2*((s+b+b_tau)*log(1+s/(b+b_tau))-s))
  return(ans)
}

getAMS <- function(test) {
  test = test[order(test$scores),]
  
  s <- sum(test$Weight[test$Label==s_val])
  b <- sum(test$Weight[test$Label==b_val])
  
  ams = rep(0,floor(.9*nrow(test)))
  amsMax = 0
  threshold = 0
  for (i in 1:floor(.9*nrow(test))) {
    #if (i %% 100) print(i)
    s = max(0,s)
    b = max(0,b)
    ams[i] = sqrt(2*((s+b+b_tau)*log(1+s/(b+b_tau))-s))
    if (ams[i] > amsMax) {
      amsMax = ams[i]
      threshold = test$scores[i]
    }
    if (test$Label[i] == s_val)
      s= s-test$Weight[i]
    else
      b= b-test$Weight[i]
    
  }
  plot(ams,type="l")
  
  return(data.frame(ams=amsMax,threshold=threshold))
}

normalize <- function(weights,labels,s,b,n) {
  s_norm = s/sum(weights[labels==s_val])
  b_norm = b/sum(weights[labels==b_val])
  return(ifelse(labels == s_val, s_norm*weights, b_norm*weights))
} 

# get training data
training <- read.csv("../Raw/training.csv", colClasses = c("integer",rep("numeric",31), "character"))
training$Label <- as.numeric(ifelse(training$Label=="s",s_val,b_val))

s_total <- sum(training$Weight[training$Label==s_val])
b_total <- sum(training$Weight[training$Label==b_val])

max_AMS = AMS(training$Label,training$Label,training$Weight)

x_vars = setdiff(names(training),c("EventId","Weight","Label"))

#replace NA
training[training==na_val] <- NA

#shuffle train and use 10% as validation set
set.seed(SEED)
in_test <- sample(nrow(training), floor(vsize*nrow(training)))

train <-training[-in_test,]
test <- training[in_test,]

#renormalize weigths
train$Weight = normalize(train$Weight,train$Label,s_total,b_total)
test$Weight = normalize(test$Weight,test$Label,s_total,b_total)

AMS(train$Label,train$Label,train$Weight)
AMS(test$Label,test$Label,test$Weight)

s_train <- sum(train$Weight[train$Label==s_val])
b_train <- sum(train$Weight[train$Label==b_val])

w = ifelse(train$Label==s_val,train$Weight/s_train,train$Weight/b_train)

set.seed(SEED+1)
gbm_model = gbm.fit(x=train[,x_vars], 
                    y=train$Label,
                    distribution = "adaboost",
                    w = w,
                    n.trees = n_trees,
                    interaction.depth = 9,
                    n.minobsinnode = 1,
                    shrinkage = 0.2,
                    bag.fraction = 0.9)

summary(gbm_model)

test$scores = predict(gbm_model,test[,x_vars],n.trees = n_trees ,type="response")
gbm.roc.area(test$Label, test$scores)
r = getAMS(test)
p = ifelse( test$scores >= r$threshold, s_val,b_val)
AMS(p,test$Label,test$Weight)

s = predict(gbm_model,train[,x_vars],n.trees = n_trees ,type="response")
p = ifelse( s >= r$threshold, s_val,b_val)
AMS(p,train$Label,train$Weight)

gc()

#make prediction
test<- read.csv("../Raw/test.csv", colClasses = c("integer",rep("numeric",30)))

test[test==na_val] <- NA

test$pred = predict(gbm_model,test[,x_vars],n.trees = n_trees ,type="response")

predicted=ifelse(test$pred>=r$threshold,"s","b")

weightRank = rank(test$pred,ties.method= "random")

submission = data.frame(EventId = test$EventId, RankOrder = weightRank, Class = predicted)
write.csv(submission, "sub14.csv", row.names=FALSE)


