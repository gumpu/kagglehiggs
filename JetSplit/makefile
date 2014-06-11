full_prediction.zip : full_prediction.csv
	zip full_prediction.zip full_prediction.csv

full_prediction.csv : higgs_pred_0.csv combine_predictions.r
	R --vanilla < combine_predictions.r

higgs_pred_0.csv : higgs-pred.py higgs_0.model
	python higgs-pred.py

higgs_0.model : higgs-train.py test_0.csv
	python higgs-train.py

test_0.csv : split_it.r
	R --vanilla < split_it.r

clean :
	rm -rf *.csv
	rm -rf *.model

