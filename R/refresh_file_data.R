# File: refresh_file_data.R 
# Author: John3Kim 
# Description: This script will run a cron job which
# will allow us to run a script periodically
# Since Unix doesn't have cron, we use taskschedulerR instead
# Don't forget to delete task scheduler in Windows afterwards


script <- "R/get_latest_file.R"
taskname <- "hourlyblobretrieval"

if(Sys.info()["sysname"] == "Windows"){ 
    
    if(!("taskscheduleR" %in% rownames(installed.packages()))){ 
        install.packages("taskscheduleR")
    }
    
    
    library(taskscheduleR)
    
    #script <- system.file("extdata","R/get_latest_file.R", package= "taskscheduleR", mustWork = TRUE)
    # every 5 minutes
    taskscheduler_create(taskname = taskname, 
                         rscript = script, 
                         schedule= "MINUTE", 
                         startdate = format(Sys.Date(), "%Y/%m/%d"),
                         starttime = format(Sys.time(), "%H:%M"), modifier = 2)
                         #starttime = format(Sys.time() + 60, 
                         #                "%H:%M"))

}else{ 
    # Unix based    
    # Need to install and run cron 
    # sudo apt-get update
    # sudo apt-get install -y cron
    #sudo cron start
    
    if(!("cronR" %in% rownames(installed.packages()))){ 
        install.packages("cronR")
    }
    
    
    library(cronR)
    
    cmd <- cron_rscript(script)
    cmd
    
    cron_add(cmd, frequency = "*/2 * * * *", id = taskname, at = format(Sys.time(), "%H:%M"))
    
}

