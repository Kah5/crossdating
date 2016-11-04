# This R script concatenates individual .rwl files from cores (exported from tellervo v. 1.2.1) and outputs a .rwl file for each site, which can be used in cofecha
# Author: Kelly Heilman
# Date: November 3/4/16
#########################

# before running this script, export the rwl sites of choice to this working directory (preferred). 
# to export, go into tellervo -> export data/metadata -> select Tucson (unstacked) and save into this directory

library(dplR)
# read in all files that have "whole wood"
#set the working directory:

setwd("C:/Users/JMac/Documents/Kelly/crossdating/data")
workingdir <- getwd()

##############################
# NEED TO CHANGE FOR EACH SITE
# name the site folder & include '/' before
##############################

sitefolder <- "/COR"

wood <- "ring width"

# get all the file names with "ring width"
# we can do this for earlywood & latewood too, by changing the wood to earlywood/latewood width

file_names = list.files(paste0(workingdir, sitefolder))
file_names = file_names[ grepl(paste0( wood ,".rwl"),file_names)]
full_filenames <- paste0(workingdir, sitefolder,'/',file_names)


combined <- combine.rwl(files)

files = lapply(full_filenames, read.rwl, header=T)

write.tucson(rwl.df = combined, fname = "COR.rwl", format = "tucson", append = FALSE, prec = 0.001)



