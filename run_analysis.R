# Load Required Libraries
library(stringr)
library(reshape2)

## Read in Data

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

subs <- rbind(sub_train, sub_test)

activities <- rbind(sub_train, sub_test)
activitiesLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)

data <- rbind(x_train, x_test) # Combine training and test data
# Clean Data column names

tidyNames <- str_replace_all(names(data), "[[:punct:]]", "")

names(data) = features[, 2] # Add column names from features

means <- data[grep("mean()",names(data))] # Exract mean measures
stds <- data[grep("std()",names(data))] # Extract standard deviation measures.

summaryData <- cbind(activities,cbind(cbind(means, stds)))
names(summaryData)[1] = "Activity"
                 
summaryData$Activity[summaryData$Activity == 1] = 'Walking'
summaryData$Activity[summaryData$Activity == 2] = 'Walking_Upstairs'
summaryData$Activity[summaryData$Activity == 3] = 'Walking_Downstairs'
summaryData$Activity[summaryData$Activity == 4] = 'Sitting'
summaryData$Activity[summaryData$Activity == 5] = 'Standing'
summaryData$Activity[summaryData$Activity == 6] = 'Laying'

summaryData <- cbind(subs, summaryData)
names(summaryData)[1] = "Subject"


# Making Tidy Tables for subject and activity

dataSubMelt <- melt(summaryData, id=c("Subject"), measure.vars=names(summaryData)[3:81])
tidySubData<-dcast(dataSubMelt, Subject ~ variable , fun.aggregate=mean)

dataActMelt <- melt(summaryData, id=c("Activity"), measure.vars=names(summaryData)[3:81])
tidyActData<-dcast(dataActMelt, Activity ~ variable , fun.aggregate=mean)

rm(sub_test, sub_train, subs, x_test, x_train, activities, data, features, means, stds, dataActMelt, dataSubMelt)

