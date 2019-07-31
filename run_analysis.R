### 1. Making the test and training set data
#Create the data set of training and test

 #Reading training tables - xtrain / ytrain, subject train
 xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
 ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
 subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)

#Reading the testing tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)

#Read the features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)

#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)
#Create Sanity and Column Values to the Train Data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

#Create Sanity and column values to the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')


### 2. Extracting only the measurements on the mean and standard deviation for each measurement
#Read all the values that are available
colNames = colnames(setAllInOne)

#get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#Create a subtset has  to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

### 3. Use descriptive activity names to name the activities in the data set
#activity naming
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

###4. Appropriately labels the data set with descriptive variable names
###5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# create new tidy set  
 secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
 secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
 
#write the ouput to a text file 
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
