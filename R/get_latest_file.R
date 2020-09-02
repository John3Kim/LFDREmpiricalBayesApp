# file: azure_store_demo.R 
# author: John3Kim 
# Gets the files and their corresponding dates
# Notes: Make sure that you set the permissions to read access to blobs (maybe containers too!)
# The creation date is equivalent to the upload date
# We assume that the last modified is the latest date that we want

library(AzureStor)
library(purrr)
library(tibble)
library(dplyr)
library(dotenv)


load_dot_env()

# Authenticate: Gain entry to Azure blob storage
blob_endpoint_key <- storage_endpoint(Sys.getenv('BLOB_STORAGE_ENDPOINT'), 
                                      key=Sys.getenv('BLOB_KEY'))

get_files_and_dates_in_blob <- function(name_container){ 
  
  # Access container storage
  container <- storage_container(blob_endpoint_key,name_container)
  # Get the names of all the files in the storage container
  file_name <- list_storage_files(container)[["name"]]
  # Get the crteated date and last-modified dates (based only on initial upload/changes in blob)
  last_modified_date <- flatten(map(file_name,function(name){get_storage_properties(container,name)["last-modified"]}))
  creation_date <- flatten(map(file_name,function(name){get_storage_properties(container,name)["x-ms-creation-time"]}))
  
  
  # Order by get_last_modified_date
  return(tibble(file_name,last_modified_date,creation_date) %>%
             arrange(desc(last_modified_date)))
  
}

# Get the url of the latest file (check to see which date it is)

latest_file <- paste(Sys.getenv('BLOB_STORAGE_URL'),
                   get_files_and_dates_in_blob('jksstoragecovid19')[["file_name"]][1],
                   sep='')

# Read the csv values 
data_df <- read.csv(latest_file)

# Process them so that they appear as a string of csvs 
lfdr1 <- paste(unlist(data_df[2][1]),collapse=', ')
lfdr2 <- paste(unlist(data_df[3][1]),collapse=', ')
