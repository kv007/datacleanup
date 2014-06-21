#read features
features <- read.table("./UCI HAR Dataset/features.txt")
#read activity_labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#read X_train as numeric
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt",comment.char = "",colClasses="numeric",col.names=features$V2)
#read Y_train as factor
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt",comment.char = "",colClasses="factor",col.names="activity_label")
#read subject_train
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",comment.char = "",colClasses="factor",col.names="subject")

#change labels in activity_labels factor 
Y_train$activity_label <- factor(Y_train$activity_label,levels=c(1,2,3,4,5,6),labels=activity_labels$V2)
#bind subject_train,Y_train,X_train
train <- cbind(subject_train,Y_train,X_train)
names(train)

##
#read X_test as numeric
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",comment.char = "",colClasses="numeric",col.names=features$V2)
#read Y_test as factor
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt",comment.char = "",colClasses="factor",col.names='activity_label')
#read subject_test
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",comment.char = "",colClasses="factor",col.names="subject")
#change labels in activity_labels factor 
Y_test$activity_label <- factor(Y_test$activity_label,levels=c(1,2,3,4,5,6),labels=activity_labels$V2)
#bind subject_test,Y_test,X_test
test <- cbind(subject_test,Y_test,X_test)
names(test)

#bind train, test
total <- rbind(train,test)
colnames(total)

#generate sub_total with only mean,std columns
mean_std_vector <- grepl('mean|std', names(total))
#sub_total <- total[,mean_std_vector]
#names(sub_total)

#generate sub_total with only subject,activity, mean,std columns
sub_totalx <- total[,c(TRUE,TRUE,mean_std_vector)]
names(sub_totalx)

#writedata in text file
write.table(sub_totalx,"tidydata.txt",row.names=FALSE)

library(reshape2)
#sub_totalx$subject <- as.numeric(sub_totalx$subject)
#sub_totalx$activity_label <- as.character(sub_totalx$activity_label)
##molten_sub_totalx <- melt(sub_totalx, id=C(subject,activity_label))

#default Using subject, activity_label as id variables
molten_sub_totalx <- melt(sub_totalx)
#mean on activity
cast_sub_totalx <- dcast(molten_sub_totalx, activity_label ~ variable,mean)
dim(cast_sub_totalx)
#mean on activity,subject
cast2_sub_totalx <- dcast(molten_sub_totalx, activity_label + subject ~ variable,mean)
dim(cast2_sub_totalx)

#writedata in text file
write.table(cast2_sub_totalx,"mean_tidydata.txt",row.names=FALSE)
