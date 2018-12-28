   ### Install and load libraries 
   ### Assuming that packages 'reshape2', 'stringr' and 'dplyr' are already installed
   ### If it is not, install those package by uncomment line 5, 6, 7
 
   #install.packages("reshape2")
   #install.packages("dplyr")
   #install.packages("stringr")

   library(reshape2)
   library(dplyr)
   library(stringr)
   library(data.table)

   ### Download and extract
   ### Smart phones Human Activity Recognition Dataset zip file
   zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   download.file(zip_url, "shar_dataset.zip")
   unzip("shar_dataset.zip")


   ### This function to get the experiment ( training or test) data as reshaped tidy data 
   ### 1.read the data files ( subject, y or activity )
   ### 2.read the data file ( x or raw ) in a fixed length format 
   ###   of 561 ( number of features / measurement ) columns
   ###   each column with 16 characters
   ### 3.change the column name of the data to as feature / measurement numbers
   ### 4.add the subject and activity as two separate column to the data
   ### 5.melt the data, and make each feature / measurement columns as a row.
   ### 6.add the experiment_type column
   ### 7.return the reshaped data

   get_experiment_data <- function(experiment, measurements, activities ){
      experiment_subjects <- read.csv(paste0("UCI HAR Dataset/", experiment, "/subject_", experiment,".txt"), header=FALSE)
      experiment_activity <- read.csv(paste0("UCI HAR Dataset/", experiment, "/y_", experiment, ".txt"),  header=FALSE)
      
      for(i in 1:nrow(activities) ) {
         experiment_activity <- replace(experiment_activity, experiment_activity==i, activities[i,2])    
      }
         

      fixed_widths <- rep.int(16, nrow(measurements))
      experiment_data <- read.fwf(paste0("UCI HAR Dataset/", experiment, "/X_", experiment, ".txt"), 
                                fixed_widths, header=FALSE, colClasses=c('character'), strip.white=TRUE)


      measurement_column_names <- c(1:nrow(measurements))
      colnames(experiment_data) <- measurement_column_names
   
    
      experiment_data[ , "subject"] <- experiment_subjects[,1]
      experiment_data[ , "activity"] <- experiment_activity[,1]

      experiment_tidy_data <- melt(experiment_data, id.vars=c("subject", "activity"), 
                                            variable.name=c('measurements'), value.name = 'value')

      experiment_type <- rep(experiment, nrow(experiment_tidy_data))
      experiment_tidy_data$experiment_type <- experiment_type

      experiment_tidy_data
   }

   ### Read raw data files
   measurements <-  read.csv("UCI HAR Dataset/features.txt", sep=" ", header=FALSE)
   activities <-  read.csv("UCI HAR Dataset/activity_labels.txt", sep=" ", header=FALSE, stringsAsFactors =FALSE)
   train_tidy_data = get_experiment_data("train", measurements, activities  )
   test_tidy_data = get_experiment_data("test", measurements, activities  )

   ### merge train and test data
   shar_tidy_data <- rbind(train_tidy_data, test_tidy_data)

   ### convert data types
   shar_tidy_data$activity <- as.factor(shar_tidy_data$activity )
   shar_tidy_data$value <- as.numeric(shar_tidy_data$value)
   
   ### write the data to the txt file
   write.table(shar_tidy_data, "shar_tidy_data.txt", row.name=FALSE)

   ### Calculate mean and std data
   mean_std_data <- shar_tidy_data %>% 
            group_by(subject, activity, experiment_type, measurements) %>% 
                summarise_all(funs(mean, sd))

   ### Write mean and std data
   write.table(mean_std_data, "shar_tidy_mean_std.txt", row.name=FALSE )

   ### Clean raw data files
   file.remove("shar_dataset.zip")
   unlink("UCI HAR Dataset", recursive = TRUE, force = TRUE)   
