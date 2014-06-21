
test_prediction.zip : test_prediction.csv
	zip test_prediction.zip test_prediction.csv

train_prediction.csv test_prediction.csv : rf.r
	time R --vanilla < rf.r

clean :
	-rm -f *.zip
	-rm -f *.csv
	echo 'Done'

