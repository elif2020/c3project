library(dplyr)

#read all data files into a separate table
stest<-read.table("./test/subject_test.txt")
xtest<-read.table("./test/X_test.txt")
ytest<-read.table("./test/y_test.txt")

strain<-read.table("./train/subject_train.txt")
xtrain<-read.table("./train/X_train.txt")
ytrain<-read.table("./train/y_train.txt")

#merge train and test sets
s<-rbind(strain,stest)
x<-rbind(xtrain,xtest)
y<-rbind(ytrain,ytest)

#extract mean and standard deviation measurements
feat<-read.table("features.txt")
values<-feat[grep("mean\\(\\)-?[XYZ]?|std\\(\\)-?[XYZ]?$",feat$V2),]
smry_x<-x[,as.numeric(values$V1)]
names(smry_x)<-values$V2

#change activity names
act<-read.table("activity_labels.txt")
y <- left_join(y,act,by="V1")
y<-y[,2]
y<-as.data.frame(y)

#rename columns
names(s)<-"subject"
names(y)<-"activity"

#merge subject and activity data with summary data
syx<-cbind(s,y,smry_x)

#find mean of each variable in x by subject
mean_by_sa<-syx %>%
        group_by(subject,activity) %>%
        summarize_at(names(smry_x), mean)

write.table(mean_by_sa,"summary_by_group.txt",row.names = FALSE)
  