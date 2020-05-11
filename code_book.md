
# getting_and_cleaning_data_project_samsung
Coursera Data Science Specialization - Getting and Cleaning Data Project
**Data Source for Code:**
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

In this repository, you will find R code (run_analysis.R) which successfully does the following with the UCI Human Activity Recognition Using Smartphones Data Set:
 1) Merges the training and the test sets to create one data set.
 2) Extracts only the measurements on the mean and standard deviation for each measurement.
 3) Uses descriptive activity names to name the activities in the data set
 4) Appropriately labels the data set with descriptive variable names.
 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Within the code, there are comments pertaining to each step. Having said this, the script proceeds in the following manner:
- First, I downloaded all of the data. This code is commented out, but I downloaded it as a zip to my current working directory. I then unzipped the data. The folder resultant from the zip file was called /UCI HAR Dataset/.
- Next, I loaded the unzipped data into R by reading in each of the test and training csvs (X, y, and subjects). Since each of the datasets in the train folder contained the same number of rows and each file pertains to the other on a same-row basis, I simply need to column bind the datasets together to create a consolidated training dataset ("**train**"). The same is done for the test datasets (see "**test**"). I then row binded the two datasets to finally **merge the training and test sets into one data set (called combined_df)**.
- Next, I extract only the columns I need: measurements on the mean and standard deviation for each measurement. This was completed by looking for all columns in the dataset that captured the mean() or std() (standard deviation). The dataframe created from this was **mean_std**. 
- In the next step, I needed to generate more value (more description) from the activity_id column. Since each of the activity_id values can be linked to values in the activity_labels.txt, I merge the two datasets in here on activity_id. I create a dataframe from this that is subsetted to not include the activity_id column but rather the activity_label column (see **activity_clean**).
- In the final step of data cleansing, I provide more description to the column headers (associated with means and standard deviations). Since I have a dictionary (see features_info.txt) with information related to the features, I was able to provide more description to abbreviated column names. I was also able to remove things like periods and spaces in columns. See the **modified_names** vector for more information on how the column names were changed.
- Lastly, I created a second, independent tidy data set with the average of each mean and std variable, after grouping by activity and subject. See **summarized_df**. This dataframe was then outputted as a text file into the same working directory. The filename is called **means_and_std_by_subject_and_activity.txt**.
