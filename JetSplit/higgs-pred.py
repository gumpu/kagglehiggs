#!/usr/bin/python
# make prediction 
import sys
import numpy as np
# add path of xgboost python module
sys.path.append('../../python/')
import xgboost as xgb

def predict(jet_id):
    model_filename      = "higgs_{}.model".format(jet_id)
    test_filename       = "test_{}.csv".format(jet_id)
    prediction_filename = "higgs_pred_{}.csv".format(jet_id)

    modelfile = 'higgs.model'
    outfile = 'higgs.pred.csv'

    # How many columns for this dataset
    with open(test_filename, "r") as f:
        line = f.readline()
        parts = line.split(',')
        n_columns = len(parts)

    # load in testdata directly use numpy
    dtest = np.loadtxt(test_filename, delimiter=',', skiprows=1 )
    data  = dtest[:,1:(n_columns-1)]
    idx   = dtest[:,0]

    print('Loading test data from {}'.format(test_filename))
    xgmat = xgb.DMatrix( data, missing = -999.0 )

    bst = xgb.Booster({'nthread':16})

    print("Loading model {}".format(model_filename))
    bst.load_model(model_filename)
    print("Making prediction")
    ypred = bst.predict( xgmat )

    with open(prediction_filename, "w") as fo:
        for i, p in zip(idx, ypred):
            fo.write("{},{}\n".format(int(i),p))

    print ('finished writing into prediction file')

for jet in range(4):
    predict(jet)

