###
# 
# The original data table is split into two sets of rows, test and train. Each
# set of rows has two columns split from it, activity and subject.
#
# The plan is to column bind the activities and subjects to the two sets
# of rows and then row bind the two sets of rows together to form a single
# dataset.
#
# The file 'features.txt' contains variable names. These names are used to
# add descriptive names to the variables. The names uniformly use 
# mean() and std() to indicate the means and standard deviations for the 
# accelerometer measurements during the measurements. A regular expression 
# is used to find these names, and subset the data.
#
# Finally, the average for each subject across all activities and the
# average for each activity across all subjects is computed and saved.
#
###

# This function reads in a data set and its split columns and binds them.

readdata <- function(maindata, subjects, activities) {
        testdata <- read.table(maindata, header = FALSE)
        names(testdata) <- features$V2
        testsubjects <- read.table(subjects, header = FALSE)
        testactivities <- read.table(activities, header = FALSE)
        testdata <- cbind(testactivities,testsubjects,testdata)
        names(testdata)[1] <- "activities"
        names(testdata)[2] <- "subjects"
        return(testdata)
}

# This function converts factor levels into factor labels for the final output

makecolname <- function(colname) {
        indexes <- strsplit(colname,"\\.") %>% unlist %>% as.numeric
        activityindex <- indexes[1]
        subjectindex <- indexes [2]
        name <- paste0( activitylabels[activityindex],".",
                        subjectlabels[subjectindex])
        return(name)
}

library(dplyr)

setwd("data")
features <- read.table("features.txt",header=F)
activitylabels <- read.table("activity_labels.txt",header=F)$V2
subjectlabels <- paste0("subject",as.character(1:30))

setwd("test")
testdata <- readdata("X_test.txt", "subject_test.txt", "y_test.txt")

setwd("../train")
traindata <- readdata("X_train.txt", "subject_train.txt","y_train.txt")

setwd("../..")
data <- rbind(testdata,traindata)
desiredcolumns <- 
        c("activities",
          "subjects",
          grep("mean\\(\\)|std\\(\\)",names(data),value=TRUE))
desireddatacols <- data[desiredcolumns]
desireddata <-
        desireddatacols %>%
        split(list(desireddatacols$activities,desireddatacols$subjects)) %>%
        sapply(colMeans)
betternames <- colnames(desireddata) %>% sapply(makecolname)
attr(betternames,"names") <- NULL
colnames(desireddata) <- betternames
outputdata <- desireddata[c(-1,-2),]
write.table(outputdata,file="output.txt",row.names=FALSE)
