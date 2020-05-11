library(dplyr)
# Download the Zip File
##download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip','wearable.zip')
##unzip('wearable.zip')

# load all of the data into individual dataframes
# first, load the labels
activity_labels <- read.csv('./UCI HAR Dataset/activity_labels.txt',sep = '',col.names = c('activity_id','activity_label'),header = FALSE)
features <- read.csv('./UCI HAR Dataset/features.txt',sep = '',header = FALSE, col.names = c('id','label'))
column_names <- features$label

# create a test dataframe
X_test <- read.csv('./UCI HAR Dataset/test/X_test.txt',sep = '',col.names = column_names,header = FALSE)
y_test <- read.csv('./UCI HAR Dataset/test/y_test.txt',sep = '',col.names = c('activity_id'),header = FALSE)
subject_test <- read.csv('./UCI HAR Dataset/test/subject_test.txt',sep = '',col.names = c('subject_id'),header = FALSE)

# create the training dataframes
X_train <- read.csv('./UCI HAR Dataset/train/X_train.txt',sep = '',col.names = column_names,header = FALSE)
y_train <- read.csv('./UCI HAR Dataset/train/y_train.txt',sep = '',col.names = c('activity_id'),header = FALSE)
subject_train <- read.csv('./UCI HAR Dataset/train/subject_train.txt',sep = '',col.names = c('subject_id'),header = FALSE)

#####################################################################
## 1. Merges the training and the test sets to create one data set.
#####################################################################

# create one test and one train dataframe
test <- cbind(subject_test,y_test,X_test)
train <- cbind(subject_train, y_train, X_train)

# union the two dataframes...add a column to tell us which dataset 
# the information came from (just for our own knowledge)
test$source = 'test'
train$source = 'train'
combined_df <- rbind(test,train)

####################################################################################################
### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
####################################################################################################

# grab only the mean and std-related columns, along with activity_id, subject_id, source (train/test)
mean_std <- combined_df[,names(combined_df)[grep('mean|std|activity_id|source|subject_id|activity_id',tolower(names(combined_df)))]]

####################################################################################################
### 3. Uses descriptive activity names to name the activities in the data set
####################################################################################################

# update the activity id to simply acitvity labels
activity_clean <- merge(activity_labels,mean_std)
activity_clean <- activity_clean[,names(activity_clean) != 'activity_id']

####################################################################################################
### 4. Uses descriptive activity names to name the activities in the data set
####################################################################################################

# modify the column names to remove periods, replace with _
# also separate lower case and upper case by _, 
# eventually set all columns to lower case
# remove any instances of __ and replace with _
modified_names <- gsub('[.]+','_',names(activity_clean))
modified_names <- gsub('[_]$','',modified_names)
modified_names <- gsub('([A-Z])','_\\1',modified_names)
modified_names <- tolower(modified_names)
modified_names <- gsub('__','_',modified_names)

# make the column names more descriptive for abbreviations
modified_names <- gsub('acc','accelerometer',modified_names)
modified_names <- gsub('gyro','gyroscope',modified_names)
modified_names <- gsub('^t_','time_',modified_names)
modified_names <- gsub('^f_','frequency_',modified_names)
modified_names <- gsub('_mag','_magnitude',modified_names)
modified_names <- gsub('_inds','_index',modified_names)
modified_names <- gsub('_t_','_time_',modified_names)
modified_names <- gsub('_body_body_','_body_',modified_names)
modified_names <- gsub('_std','_standard_deviation',modified_names)
#modified_names <- gsub('_mad','_median_abs_deviation',modified_names)
#modified_names <- gsub('_iqr','_interquartile_range',modified_names)
#modified_names <- gsub('_sma','_single_magnitude_area',modified_names)
#modified_names <- gsub('_ar_coeff','_autoregress_coefficient',modified_names)

# update the column names
names(activity_clean) = modified_names

#########################################################################################################
### 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
###    each variable for each activity and each subject.
#########################################################################################################

# mean for all columns 
summarized_df <- activity_clean %>%
  group_by(subject_id, activity_label) %>%
  summarise_at(.vars = names(activity_clean)[!names(activity_clean) %in% c('subject_id','activity_label','source')],.funs = "mean")

# write the dataframe to a text file
write.table(summarized_df,'means_and_std_by_subject_and_activity.txt',row.name = FALSE)

# checked to see if any of these values = 'NA'...answer: NO
#any(is.na(data.frame(summarized_df)))
