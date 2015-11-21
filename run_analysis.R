
## Download the Dataset:
##_____________________________________________________________________________________
TmpFile <- "projectfiles.zip"


if (!file.exists(TmpFile)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, TmpFile)
} 

## Unzip the file if needed:
##_____________________________________________________________________________________

if (!file.exists("UCI HAR Dataset")) { 
  unzip(TmpFile) 
}

# Load activity labels & the names of features from the files:activity_labels.txt,features.txt
##_____________________________________________________________________________________

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extracts only the measurements on the mean and standard deviation for each measurement. 
##_____________________________________________________________________________________

Target_features <- grep(".*mean.*|.*std.*", features[,2],ignore.case = TRUE)
Target_features_names <- features[Target_features,2]
Target_features_names <- gsub('[()]', '', Target_features_names)

## Load the datasets
##_____________________________________________________________________________________
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
x_train <- x_train[, Target_features]
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")


x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
x_test <- x_test[, Target_features]
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Merge the datasets
##_____________________________________________________________________________________
Total_train <- cbind(subject_train, y_train, x_train)
Total_test <- cbind(subject_test, y_test, x_test)
Total_data <- rbind(Total_train, Total_test)


#Uses descriptive activity names to name the activities in the data set
##_____________________________________________________________________________________

Total_data[,2] <- activityLabels[Total_data[,2],2] 

# Appropriately labels the data set with descriptive variable names. 
##_____________________________________________________________________________________

colnames(Total_data) <- c("subject", "activity", Target_features_names)

#  creates a data set with the average of each variable for each activity and each subject.
##_____________________________________________________________________________________

Total_data <- aggregate(Total_data, by=list(activity = Total_data$activity, subject=Total_data$subject), FUN =mean)
Total_data[,3] <- NULL
Total_data[,3] <- NULL

#  creates a Txt File with the Dataset
##_____________________________________________________________________________________

write.table(Total_data, "Project_tidy.txt", row.names = FALSE, quote = FALSE)