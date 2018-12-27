# Convert raw 'Human Activity Recognition Using Smartphones Dataset' to tidy data set

This utility programs creates tidy data from the given raw data (Human Activity Recognition Using Smart phones Dataset)
by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.

It creates two data files, one with all raw data in the tidy format and another one as summarized with mean and std 
of the training and test data.

## Getting Started

Clone this project into your local computed and run the R script to reproduce the data sets

### Prerequisites

R language and required libraries. Optional: RStudio
The following r packages are required.
   reshape2
   dplyr
   stringr
   data.table
   
If you have not installed already, the script can install by un commenting the lines 5,6 and 7   


### Installing

After successfully cloned the project to local computed.
Change the working directory in the R shell or 
copy these files into current working directory.

## Running the script

To run the R script, type the following command in the R shell

> source("shar_tidy.R")


## Process / logical flow
 Steps:-
   1. Install and load libraries 
   2. Download and extract the raw data files bundle
   3. Read raw data files
       * read the data files ( subject, y or activity )
       * read the data file ( x or raw ) in a fixed length format 
          of 561 ( number of features / measurement ) columns
          each column with 16 characters
       * change the column name of the data to as feature / measurement numbers
       * add the subject and activity as two separate column to the data
       * melt the data, and make each feature / measurement columns as a row.
       * add the empty missing ('train' column in 'test' experiment and 
                         'test' column in 'train experiment)
       * return the reshaped data
   4. Merge train and test data
   5. Convert data types as required as numeric or factor
   6. Write the reshaped tidy data to the txt file 
   7. Calculate mean and std data for each measurement
   8. Write the mean and std tidy data to the txt file 
   9. Clean raw data


## Results

Once the scripts is successfully complete the following files will be created in the
current working directory

'shar_tidy_data.txt' - The merged complete training and test data
'shar_tidy_mean_std.txt' - The mean and standard deviation of each measurement per subject per activity

Please refer the "code_book.pdf" file for the detail data information on both tidy data set files