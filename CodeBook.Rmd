Getting and Cleaning Data Class Project
by Brian Sewell
========================================================

Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

This data {x.csv} created from the below code was extracted from original data collected from the accelerometers from the Samsung Galaxy S smartphone.

This will download the original data, unzip it, and load into R

```{r}
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
```

This will merge the training data set and test data sit to create one data set

```{r}
colnames(X_train) <- ColumnNames
colnames(X_test) <- ColumnNames
X_train <- cbind(y_train, X_train)
X_train <- cbind(subject_train, X_train)
X_test <- cbind(y_test, X_test)
X_test <- cbind(subject_test, X_test)
x <- rbind(X_train, X_test)
```

Appropriately labels the data set with descriptive activity names. 

```{r}
x <- merge(activity_lables, x, by.x="Index", by.y="Lables")
```

Extracts only the measurements on the mean and standard deviation for each measurement. 

```{r}
extract <- colnames(x)[grep("mean", colnames(x))]
extract <- c(extract, colnames(x)[grep("std", colnames(x))])
extract <- sort(extract)
extract <- c("Subject", "Activity", extract)
x <- x[order(x$Subject),extract]
```

Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r}
names <- colnames(x)[,3:81]
x2 <- data.table(x)
xgroup <- x2[, lapply(.SD, mean), by=c( "Subject","Activity"), .SDcols=names]

```

Writes x.csv containing cleaned data.
Writes xSummary.csv that contains the mean of each variable grouped by Subject and Activity.

```{r}
write.csv(x2, file = "x.csv")
write.csv(xgroup, file = "xSummary.csv")
```

