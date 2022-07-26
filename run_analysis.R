## Download and Unzip Dataset
if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,"./data/dataset.zip")
unzip("./data/dataset.zip")

##1 Merges the training and the test sets to create one data set.
#Read training files
library(dplyr)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Read test files
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Read features file
features <- read.table("UCI HAR Dataset/features.txt")

#Read Activity Labels
activityL <- read.table("UCI HAR Dataset/activity_labels.txt")

#Combine Test and Training
traindata <- data.frame(subject_train,y_train,x_train)
testdata <- data.frame(subject_test,y_test,x_test)

names(traindata) <- c(c("subject","activity"),features[,2])
names(testdata) <- c(c("subject","activity"),features[,2])
fulldata <- rbind(traindata,testdata)

##2 Extracts only the measurements on the mean and standard deviation for each measurement. 
stdNmean <- grep("[Mm]ean|std", names(fulldata))
dataSM <- fulldata[,c(1,2,stdNmean)]

##3 Uses descriptive activity names to name the activities in the data set
activityL <- as.character(activityL[,2])
dataSM$activity <- activityL[dataSM$activity]
dataSM$activity <- as.factor(dataSM$activity)

##4 Appropriately labels the data set with descriptive variable names. 

names(dataSM)[2] = "activity"
names(dataSM)<-gsub("Acc", "Accelerometer", names(dataSM))
names(dataSM)<-gsub("Gyro", "Gyroscope", names(dataSM))
names(dataSM)<-gsub("BodyBody", "Body", names(dataSM))
names(dataSM)<-gsub("Mag", "Magnitude", names(dataSM))
names(dataSM)<-gsub("^t", "Time", names(dataSM))
names(dataSM)<-gsub("^f", "Frequency", names(dataSM))
names(dataSM)<-gsub("tBody", "TimeBody", names(dataSM))
names(dataSM)<-gsub("-mean()", "Mean", names(dataSM), ignore.case = TRUE)
names(dataSM)<-gsub("-std()", "STD", names(dataSM), ignore.case = TRUE)
names(dataSM)<-gsub("-freq()", "Frequency", names(dataSM), ignore.case = TRUE)
names(dataSM)<-gsub("angle", "Angle", names(dataSM))
names(dataSM)<-gsub("gravity", "Gravity", names(dataSM))

##5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata <- dataSM %>% group_by(subject,activity) %>% summarise_all(.f = mean)
write.table(tidydata,"TidyData.txt",row.names = FALSE)
