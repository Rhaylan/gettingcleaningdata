# gettingcleaningdata
Notes from my run_analysis.R script:
Peer graded project for Getting and Cleaning Data class:                        ##
## The run_analysis script downloads and unzips (performs a check to determine if  ##
## this step is required) a set of motion sensor data and calculations from a      ##
## samsung smartphone and performs the following steps to create the required tidy ##
## data sets:                                                                      ##
## 1. Merges the training and the test sets to create one data set.                ##
## 2.	Extracts only the measurements on the mean and standard deviation for each ##
## measurement.                                                                    ##                                                                   
## 3.	Uses descriptive activity names to name the activities in the data set.    ##          
## 4.	Appropriately labels the data set with descriptive variable names.         ##
## 5.	From the data set in step 4, creates a second, independent tidy data set   ##
## with the average of each variable for each activity and each subject.    
First Open feature and activity files
Next open the three test data files and the three training data files
Next we take out the punctuation from the featureNames table so they conform to naming conventions.  Use the gsub() function to identify the non-ascii pattern we want to replace,  what we want to replace it with and the table name and colum to apply the function on.  This is a perl script type statement.
Again use the gsub() function to remove the ""-" from the activityLabels table column 2 and replace it with a ".".  And use the R tolower() to convert the names to all lower case
Use grep to decrease variables from 500+ to only the measurements on the mean and standard deviation
Since there will be an offset in the labels by adding "activity" and "subject" labels create an offset in the stdMeanLevels variable
Now that the feature names and activity label tables are cleaned and normalized it's time to merge the training and test data tables.  First merge the test, activities and subjects data tables.  Make a copy of the original test data and give it column names
Use cbind() to bind the test data to the test activities data and give it a column name
Then use cbind() to bind the test & activities table to the test subjects data  and givei t a column name
Next merge the training, activities and subjects data tables.  Make a copy of the original training data and give it column names
Use cbind() to bind the training data to the training activities data and give it a column name
use cbind() to bind the training & activities table to the training subjects data and give t a column name
Merge copyTrainData and copyTestData Data.Tables
Re-order the row names after the order()
loop through the data.table and replace the activity integer with a descriptive label
Pull out just the mean and standard deviation variables based on the grep performed earlier on "std" and "mean" patterns.  Then use cbind() to bind them to the subject  and activity columns
Install reshape2 package
Melt the wide-format data table into a long-format data table so we can defing the identifiers  subjects and activities from the measurements.  Then take the mean
And finally write out our tidy data.table for further analysis 
