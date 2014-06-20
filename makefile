all :
	echo 'Done'


clean :
	make -C Explore      clean
	make -C Raw          clean
	make -C RandomForest clean
	make -C Processed    clean
	make -C SVM          clean

