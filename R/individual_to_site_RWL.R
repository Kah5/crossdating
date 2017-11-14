# This R script concatenates individual .rwl files from cores (exported from tellervo v. 1.2.1) and outputs a .rwl file for each site, which can be used in cofecha
# Author: Kelly Heilman
# Date: November 3/4/16
#########################

# before running this script, export the rwl sites of choice to this working directory (preferred). 
# to export, go into tellervo -> export data/metadata -> select Tucson (unstacked) and save into this directory
##############################
# NEED TO CHANGE FOR EACH SITE
# name the site folder & include '/' before
##############################

#note you need the front slash before the folder name
sitename <- "UNC"#change this to the name of the folder you just created

sitefolder <- paste0("/", sitename) 

library(dplR)
# read in all files that have "whole wood"
#set the working directory:

#setwd("C:/Documents and Settings/user/My Documents/crossdating/data")
setwd("/Users/kah/Documents/crossdating/data")
workingdir <- getwd()



wood <- "ring width" # this can be changed if we want to do 

# get all the file names with "ring width"
# we can do this for earlywood & latewood too, by changing the wood to earlywood/latewood width

file_names = list.files(paste0(workingdir, sitefolder))
file_names = file_names[ grepl(paste0( wood ,".rwl"),file_names)]
full_filenames <- paste0(workingdir, sitefolder,'/',file_names)



# read all the files in the directory in as rwl files
files = lapply(full_filenames, read.rwl, header=T) 

# combine all the files into one rwl file for COFECHA crossdating
combined <- combine.rwl(files)

# special case to rename the PVC values
if(sitename == "PVC"){
  new <- colnames(combined)
  
    for(i in 1:length(file_names)){
      if(i < 8){
        
      core <- substring(file_names[i], first = 13, 13)
      tree <- substring(file_names[i], first = 5, 6)
      place <- substring(file_names[i], first = 1, 3)
      new[i] <- paste0(place, tree, core)
      

      }else{
        if(i > 8){
          
        core <- substring(file_names[i], first = 12, 12)
        tree <- substring(file_names[i], first = 5, 5)
        place <- substring(file_names[i], first = 1, 3)
        new[i] <- paste0(place, tree, core)
        
        }else{
          new[i] <- NA
          
          
         }}}}else{
            if(sitename == "COR"){
                new <- colnames(combined)
          
            for(i in 1:length(file_names)){
           
              
                core <- substring(file_names[i], first = 14, 14)
                tree <- substring(file_names[i], first = 6, 8)
                place <- substring(file_names[i], first = 1, 3)
                new[i] <- paste0(place, tree, core)
              
          }
          
            colnames(combined) <- new
                }else{
                  if(sitename == "STC"){
                  combined <- combined[ row.names(combined)>= 1879, ] }
                  
                  else{if(! sitename %in% c("COR", "PVC", "STC")){
                  
            colnames(combined)}}}}
              



#this will write into the cofecha folder within the data folder
if(wood == "ring width"){
  
  write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
  }else{
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,wood,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
    
  }


