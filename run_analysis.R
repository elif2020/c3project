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
smry_x<-select(x,V1:V6,V41:V46,V81:V86,V121:V126,V161:V166,V201,V202,V214,
               V215,V227,V228,V240,V241,V253,V254,V266:V271,V345:V350,
               V424:V429,V503,V504,V516,V517,V529,V530,V542,V543)

#change activity names
y[y==1]<-"walking"
y[y==2]<-"walking_upstairs"
y[y==3]<-"walking_downstairs"
y[y==4]<-"sitting"
y[y==5]<-"standing"
y[y==6]<-"laying"

#rename columns
names(s)<-"subject"
names(y)<-"activity"

feat<-read.table("features.txt")
values<-feat[grep("mean\\(\\)|mean\\(\\)-[XYZ]|std\\(\\)|std\\(\\)-[XYZ]$",feat$V2),]
names(smry_x)<-values$V2

#merge subject and activity data with summary data
syx<-cbind(s,y,smry_x)

#find mean of each variable in x by subject
mean_by_s<-syx %>%
        group_by(subject) %>%
        summarize_at(names(smry_x), mean)

#find mean of each variable by activity
mean_by_a<-syx %>%
        group_by(activity) %>%
        summarize_at(names(smry_x), mean)

mean_by_sa<-list(mean_by_s,mean_by_a)

mean_by_sa
  
          