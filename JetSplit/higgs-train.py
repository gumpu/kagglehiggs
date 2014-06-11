#!/usr/bin/python
# this is the example script to use xgboost to train 

import inspect
import os
import sys
import numpy as np

import xgboost as xgb


def train(jet_number):
    test_size = 550000

    train_filename = 'training_{}.csv'.format(jet_number)
    test_filename  = 'test_{}.csv'.format(jet_number)

    n_columns = 0
    with open(train_filename, "r") as f:
        line = f.readline()
        parts = line.split(',')
        n_columns = len(parts)

    num_test_samples = 0
    with open(test_filename, "r") as f:
        for line in f:
            num_test_samples += 1

        num_test_samples -= 1


    # load in training data, directly use numpy
    dtrain = np.loadtxt( 
            train_filename, delimiter=',', 
            skiprows=1, 
            converters={(n_columns-1): lambda x:int(x=='s'.encode('utf-8')) } )
    print ('finish loading from csv ')

    label  = dtrain[:,(n_columns-1)]
    data   = dtrain[:,1:(n_columns-2)]

    # rescale weight to make it same as test set
    weight = dtrain[:,(n_columns-2)] * float(test_size) / len(label)

    sum_wpos = sum( weight[i] for i in range(len(label)) if label[i] == 1.0  )
    sum_wneg = sum( weight[i] for i in range(len(label)) if label[i] == 0.0  )

    # print weight statistics 
    print ('weight statistics: wpos=%g, wneg=%g, ratio=%g' % ( sum_wpos, sum_wneg, sum_wneg/sum_wpos ))


    # construct xgboost.DMatrix from numpy array, treat -999.0 as missing
    # value

    xgmat = xgb.DMatrix( data, label=label, missing = -999.0, weight=weight )

    # setup parameters for xgboost
    param = {}
    # use logistic regression loss, use raw prediction before logistic
    # transformation since we only need the rank

    param['objective'] = 'binary:logitraw'
    # scale weight of positive examples
    param['scale_pos_weight'] = sum_wneg/sum_wpos
    param['bst:eta'] = 0.1 
    param['bst:max_depth'] = 6
    param['eval_metric'] = 'auc'
    param['silent'] = 1  # 1
    param['nthread'] = 1 # 16  Lets not overheat the laptop

    # you can directly throw param in, though we want to watch multiple
    # metrics here 
    plst = list(param.items())+[('eval_metric', 'ams@0.15')]

    watchlist = [ (xgmat,'train') ]

    # Boost 120 trees
    # num_round = 120
    num_round = 60
    print ('loading data end, start to boost trees')
    bst = xgb.train( plst, xgmat, num_round, watchlist );

    # Save the model
    model_filename = 'higgs_{}.model'.format(jet_number)
    bst.save_model(model_filename)

    print ('finish training')


for jet in range(4):
    train(jet)

