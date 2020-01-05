# Course-Project

The script run_analysis.R works by joining the columns in 
subject_xxx.txt and y_XXX.txt and binding those columns to 
the data in X_xxx.txt, where 'xxx' can be either 'test' or
'train'. The two datasets are then combined using rbind to
bind them together by rows. This occurs in lines 52 through
59.

The columns with names that include 'mean()' or 'std()' are 
then selected in lines 61 through 67.

In line 69, the data set is split by activity and subject
so that each activity for each subject is a separate split 
of the data. The data in each column is then averaged to 
produce a single row of data for each variable for each 
activity and subject.

The columns of the averaged data are then relabeled with 
better descriptions and the descriptive names of the variables
are bound to the output as the first column in lines 74
through 78.