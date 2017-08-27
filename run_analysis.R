#Intialization
library(plyr)

#Read and merge the training and test sets 
xtrain = read.table("train/X_train.txt")
ytrain = read.table("train/y_train.txt")
strain = read.table("train/subject_train.txt")

xtest = read.table("test/X_test.txt")
ytest = read.table("test/y_test.txt")
stest = read.table("test/subject_test.txt")

xdata = rbind(xtrain, xtest)
ydata = rbind(ytrain, ytest)
sdata = rbind(strain, stest)

#Cleanup workspace
rm(xtrain, ytrain , strain, xtest, ytest, stest)

# Read feature and activity labels
features = read.table("features.txt")
activities = read.table("activity_labels.txt")

# Extract only the measurements on the mean and standard deviation
onlyfeatures = grep("(mean|std)\\(\\)", features[, 2])
xdata = xdata[, onlyfeatures]
names(xdata) = features[onlyfeatures, 2]

# Use descriptive activity names to name the activities in the data set
ydata[, 1] = activities[ydata[, 1], 2]
names(ydata) = "activities"
names(sdata) = "subject"

# Merge data tables and cleanup workspace
data = cbind(sdata, xdata, ydata)
rm(sdata, xdata, ydata, activities, features)

# Appropriately label the data set with descriptive variable names
data$activities = tolower(data$activities)
names(data) = gsub("^t", "Time", names(data))
names(data) = gsub("^f", "Frequency", names(data))
names(data) = gsub("-", "", names(data))
names(data) = gsub("std\\(\\)", "StdDev", names(data))
names(data) = gsub("mean\\(\\)", "Mean", names(data))
data$activities = gsub("_","", data$activities)

# Create a second, independent tidy data set with the average of each variable, activity and subject
summary = ddply(data, .(subject, activities), numcolwise(mean))
write.csv(summary, "tidy mean.csv", row.names=FALSE)
