features <- read.table("./features.txt", col.names = c("f_id","functions"))
activities <- read.table("./activity_labels.txt", col.names = c("code", "activity"))

x_train <- read.table('./train/X_train.txt',col.names = features$functions)
x_test <- read.table('./test/X_test.txt',col.names = features$functions)

y_train <- read.table('./train/y_train.txt', col.names = "code")
y_test <- read.table('./test/y_test.txt', col.names = "code")

subject_train <- read.table('./train/subject_train.txt', col.names = "subject")
subject_test <- read.table('./test/subject_test.txt', col.names = "subject")

# 1. Merges the training and the test sets to create one data set.

x_merge <- rbind(x_train, x_test)
y_merge <- rbind(y_train, y_test)
subject_merge  <- rbind(subject_train, subject_test)

dataset <- cbind(subject_merge, y_merge, x_merge)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.

mean_std <- dataset %>% select(subject, code, contains("mean"), contains("std"))

# 3.Uses descriptive activity names to name the activities in the data set

dataset2 <- activities[mean_std$code, 2]

#4. Appropriately labels the data set with descriptive variable names.

names(dataset)[2] = "activity"
names(dataset)<-gsub("^t", "Time", names(dataset))
names(dataset)<-gsub("^f", "Frequency", names(dataset))
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("-mean()", "Mean", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-std()", "STD", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-freq()", "Frequency", names(dataset), ignore.case = TRUE)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data <- dataset %>%    group_by(subject, activity) %>%   summarise_all(list(mean))
write.table(tidy_data, "tidy_data2.txt", row.name=FALSE)

