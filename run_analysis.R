
##  Download, Unzip and Load Data

if(!file.exists("./data"))  {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "./data/dataset.zip", method="curl")
unzip("./data/dataset.zip", exdir="./data")
dir <- "./data/UCI HAR Dataset"
test_dir <- "./data/UCI HAR Dataset/test"
train_dir <- "./data/UCI HAR Dataset/train"
dir_files <- dir(dir, full.names = TRUE)
test_files <- dir(test_dir, full.names = TRUE)
train_files <- dir(train_dir, full.names = TRUE)
y_train <- read.table(train_files[4], col.names="Lables")
X_train <- read.table(train_files[3])
y_test <- read.table(test_files[4], col.names="Lables")
X_test <- read.table(test_files[3])
subject_train <- read.table(train_files[2], col.names="Subject")
subject_test <- read.table(test_files[2], col.names="Subject")
features <- read.table(dir_files[3])
ColumnNames <- as.vector(features$V2)
activity_lables <- read.table(dir_files[1], col.names=c("Index", "Activity.Name"))
## Merges the training and the test sets to create one data set.

colnames(X_train) <- ColumnNames
colnames(X_test) <- ColumnNames
X_train <- cbind(y_train, X_train)
X_train <- cbind(subject_train, X_train)
X_test <- cbind(y_test, X_test)
X_test <- cbind(subject_test, X_test)
x <- rbind(X_train, X_test)

## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive activity names. 

x <- merge(activity_lables, x, by.x="Index", by.y="Lables")

## Extracts only the measurements on the mean and standard deviation for each measurement. 

extract <- colnames(x)[grep("mean", colnames(x))]
extract <- c(extract, colnames(x)[grep("std", colnames(x))])
extract <- sort(extract)
extract <- c("Subject", "Activity", extract)
x <- x[order(x$Subject),extract]

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

names <- colnames(x)[,3:81]
x2 <- data.table(x)
xgroup <- x2[, lapply(.SD, mean), by=c( "Subject","Activity"), .SDcols=names]

## Write two files
write.csv(x2, file = "x.csv")
write.csv(xgroup, file = "xSummary.csv")
