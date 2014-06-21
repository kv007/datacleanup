Readme.md
========================================================

This file explains how the run.analysis.R script works
The script assumes that the data we work on has been already unzipped in a directory ./UCI HAR Dataset in the working dir

These are the steps followed1
# 1 read features.txt
features <- read.table("./UCI HAR Dataset/features.txt")
# 2 read activity_labels.txt
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 3 read X_train.txt as numeric
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt",comment.char = "",colClasses="numeric",col.names=features$V2)
# 4 read Y_train.txt as factor
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt",comment.char = "",colClasses="factor",col.names="activity_label")
# 5 read subject_train.txt as factor
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",comment.char = "",colClasses="factor",col.names="subject")
# 6 change labels in activity_labels factor 
Y_train$activity_label <- factor(Y_train$activity_label,levels=c(1,2,3,4,5,6),labels=activity_labels$V2)
# 7 bind subject_train,Y_train,X_train
train <- cbind(subject_train,Y_train,X_train)
names(train)
# 8 read X_test as numeric
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",comment.char = "",colClasses="numeric",col.names=features$V2)
# 9 read Y_test as factor
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt",comment.char = "",colClasses="factor",col.names='activity_label')
# 10 read subject_test as factor
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",comment.char = "",colClasses="factor",col.names="subject")
# 11 change labels in activity_labels factor 
Y_test$activity_label <- factor(Y_test$activity_label,levels=c(1,2,3,4,5,6),labels=activity_labels$V2)
# 12 bind subject_test,Y_test,X_test
test <- cbind(subject_test,Y_test,X_test)
names(test)
# 13 bind train, test
total <- rbind(train,test)
colnames(total)
# 14 generate sub_total with only mean,std columns
mean_std_vector <- grepl('mean|std', names(total))
# 15 generate sub_totalx with only subject,activity, mean,std columns
sub_totalx <- total[,c(TRUE,TRUE,mean_std_vector)]
names(sub_totalx)
# 16 writedata in tidydata.txt file
write.table(sub_totalx,"tidydata.txt",row.names=FALSE)
# 17 load reshape2 package
library(reshape2)
# 18 default Using subject, activity_label as id variables
molten_sub_totalx <- melt(sub_totalx)
# 19 generate mean on activity df
cast_sub_totalx <- dcast(molten_sub_totalx, activity_label ~ variable,mean)
dim(cast_sub_totalx)
# 20 generate mean on activity,subject df
cast2_sub_totalx <- dcast(molten_sub_totalx, activity_label + subject ~ variable,mean)
dim(cast2_sub_totalx)
# 21 writedata in text file
write.table(cast2_sub_totalx,"mean_tidydata.txt",row.names=FALSE)
