
full_prediction.zip : full_prediction.csv
	zip full_prediction.zip full_prediction.zip

full_prediction.csv : rf.r
	time R --vanilla < rf.r

clean :
	-rm -f *.zip
	-rm -f *.csv
	echo 'Done'

