

train_prediction.csv test_prediction.csv : higgs-pred.py higgs.model
	python higgs-pred.py

higgs.model : higgs-learn.py ../Processed/training.csv
	python higgs-learn.py

clean :
	-rm -f __pycache__
	echo 'Done'
