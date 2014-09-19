## Load data

test.X <- read.table('./UCI HAR Dataset/test/X_test.txt', header = FALSE, sep = "")
test.subject <- read.table('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = "")
test.activity <- read.table('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = "")

train.X <- read.table('./UCI HAR Dataset/train/X_train.txt', header = FALSE, sep = "")
train.subject <- read.table('./UCI HAR Dataset/train/subject_train.txt', header = FALSE, sep = "")
train.activity <- read.table('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = "")

## Merge into one data set

test  <- cbind(test.subject, test.activity, test.X)
train <- cbind(train.subject, train.activity, train.X)

data <- rbind(test, train)

## Load features labels and remove '(', ')' and commas from them

features <- read.table('./UCI HAR Dataset/features.txt', header = FALSE, sep = "")

features$V2 <- gsub("()", "", features$V2, fixed = TRUE)
features$V2 <- gsub("(", "-", features$V2, fixed = TRUE)
features$V2 <- gsub(")", "-", features$V2, fixed = TRUE)
features$V2 <- gsub(",", "-", features$V2, fixed = TRUE)

## Set descriptive labels for all columns in dataset 

colnames(data) <- c("subject", "act", features$V2)

## convert activity into factor

data$activity <- factor(data$act, 
        levels=c(1,2,3,4,5,6),
        labels=c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'))

## drop column with activity numbers

data <- data[, (names(data) != "act")]


## extract only columns with mean or std

feauresWithMeanOrStd <- features$V2[
                            grepl("mean", features$V2, ignore.case=TRUE) | grepl("std", features$V2, ignore.case=TRUE)]

data.meanOrSTd <- data[c('subject', 'activity', feauresWithMeanOrStd)]

## create tidy dataset for these data

library('plyr')
data.tidy <- ddply(data.meanOrSTd, .(subject,activity), colwise(mean))

# write file to the disk
write.table(data.tidy, "tidyData.txt", row.name=FALSE)







