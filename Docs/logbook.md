# Log Book



## Increasing the number of iterations of xgboost

[119]   train-auc:0.945800  train-ams@0.15:5.935622  Kaggle score 3.6003
[189]   train-auc:0.950121  train-ams@0.15:6.227000  Kaggle score 3.59066


## Normalizing data (04 Jun 2014)

Normalized all data into the range [0,1]

Did two runs with xgboost:
1. 120 iterations, normalized, xgboost,  kaggle score  3.29083
2. 200 iterations, normalized, xgboost,  kaggle score  3.32008

These results are odd. One would expect that normalizing does not
matter, or would even improve the results.  Might be a bug in
the preprocessing code.

First two variables normalized:
[119]   train-auc:0.944377  train-ams@0.15:5.851353

First variable normalized:
[119]   train-auc:0.944949  train-ams@0.15:5.907614

First variable shifted  min(x) to the left
[119]   train-auc:0.945800  train-ams@0.15:5.935622


Dividing all variables by 2000 gives a reall low score.
xgboost seems to dislike small numbers.

All variables normalized, then multiplied by 100, gives the normal score.

## Non adjusted weights  (07 Jun 2104)

xgboost adjust the weight according to the testset size, what happens if
we do not do that:

xgboost, 120 rounds, Unadjusted weights.  Kaggle score 3.54761

## JetSplit algorithm (08 Jun 2014)

JetSplit algorithm,  120 rounds of xgboost on the subsets
for the four different jets.  15% cutoff

Kaggle score   3.03062

60 rounds of xgboost

Kaggle score 3.06791

## JetSplit algorithm (11 Jun 2014)

JetSplit, 120 iterations, weight adjusten to testset size, signal ratio according to training set
Kaggle Score 2.79185

JetSplit, 60 iterations xgboost, weight adjusted according to the 4 testset sizes.
Kaggle Score 2.77926
Wed, 11 Jun 2014 19:53:35

JetSplit, 60 iterations, signal fractions according to trainingset.
Kaggle Score 2.77520

Jet split, 120 rounds of xgboost,
weight adjusted according to testset size 
Kaggle Score 3.06152




vi: spell spl=en ft=markdown
