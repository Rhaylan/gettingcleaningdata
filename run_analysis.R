##---------------------------------------------------------------------------------##
## Peer graded project for Getting and Cleaning Data class:                        ##
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
## with the average of each variable for each activity and each subject.           ##     
##---------------------------------------------------------------------------------##    
run_analysis <- function(){
  
  library(reshape2)
  
  filename <- "getdata_dataset.zip"
  
  ## Download and unzip the dataset:
  if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename)
  }  
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
  }
  
  # Load activity labels + features
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
  activityLabels[,2] <- as.character(activityLabels[,2])
  features <- read.table("UCI HAR Dataset/features.txt")
  features[,2] <- as.character(features[,2])
  
  # Extract only the data on mean and standard deviation
  featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
  featuresWantedNames <- features[featuresWanted,2]
  featuresWantedNames = gsub('-mean', 'Mean', featuresWantedNames)
  featuresWantedNames = gsub('-std', 'Std', featuresWantedNames)
  featuresWantedNames <- gsub('[-()]', '', featuresWantedNames)
  
  # Load the datasets
  train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
  trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
  trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
  train <- cbind(trainSubjects, trainActivities, train)
  
  test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
  testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
  testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
  test <- cbind(testSubjects, testActivities, test)
  
  # merge datasets and add labels
  allData <- rbind(train, test)
  colnames(allData) <- c("subject", "activity", featuresWantedNames)
  
  # turn activities & subjects into factors
  allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
  allData$subject <- as.factor(allData$subject)
  
  allDataMelted <- melt(allData, id = c("subject", "activity"))
  allDataMean <- dcast(allDataMelted, subject + activity ~ variable, mean)
  
  write.table(allDataMean, "tidy.txt", row.names = FALSE, quote = FALSE) 
}

