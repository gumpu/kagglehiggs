
full_prediction.zip : full_prediction.csv
	zip full_prediction.zip full_prediction.csv

full_prediction.csv : hsvm.r
	time R --vanilla < hsvm.r

clean :
	-rm -f *.zip
	-rm -f *.csv
	echo 'Done'

