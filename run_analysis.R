## loading useful packages

library(tidyverse)

## set working directory

setwd()

##loading all the recquired datasets and changing the column names

features <- read.table("features.txt", col.names = c("n", "functions"))
activities <- read.table("activity_labels.txt", col.names = c("activity_id", "activity"))
subject_test <- read.table("subject_test.txt", col.names = "sub_id")
test_x <- read.table("X_test.txt", col.names = features$functions)
test_y <- read.table("Y_test.txt", col.names = "activity_id")
subject_train <- read.table("subject_train.txt", col.names = "sub_id")
train_x <- read.table("X_train.txt", col.names = features$functions)
train_y <- read.table("Y_train.txt", col.names = "activity_id")

##creating a complete dataset with all the observations and the different variables

x_train_and_test <- rbind(train_x, test_x)
y_train_and_test <- rbind(train_y, test_y)
subjects <- rbind(subject_test, subject_train)
complete_data <- cbind(x_train_and_test, y_train_and_test, subjects)
final_data <- complete_data %>%
  select(activity_id, contains("std"), contains("mean"))

##change the activity ID for activiy names

final_data$activity_id <- activities[final_data$activity_id, 2]

##make the variable names comprehensible

names(final_data)<-gsub("Acc", "Accelerometer", names(final_data))
names(final_data)<-gsub("Gyro", "Gyroscope", names(final_data))
names(final_data)<-gsub("BodyBody", "Body", names(final_data))
names(final_data)<-gsub("Mag", "Magnitude", names(final_data))
names(final_data)<-gsub("^t", "Time", names(final_data))
names(final_data)<-gsub("^f", "Frequency", names(final_data))
names(final_data)<-gsub("tBody", "TimeBody", names(final_data))
names(final_data)<-gsub("-mean()", "Mean", names(final_data), ignore.case = TRUE)
names(final_data)<-gsub("-std()", "STD", names(final_data), ignore.case = TRUE)
names(final_data)<-gsub("-freq()", "Frequency", names(final_data), ignore.case = TRUE)
names(final_data)<-gsub("angle", "Angle", names(final_data))
names(final_data)<-gsub("gravity", "Gravity", names(final_data))

##new dataset with averages and creates new dataset

summarized_data <- final_data %>%
  group_by(activity_id) %>%
  summarise_all(mean)
write.table(summarized_data, "summarized_data.txt", row.name=FALSE)