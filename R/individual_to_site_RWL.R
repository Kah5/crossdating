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
sitename <- "UNI"#change this to the name of the folder you just created

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

# if it is 
list.files <- strsplit(full_filenames, "-")
TreeIDnum <- do.call(rbind, list.files)[,2]


# combine all the files into one rwl file for COFECHA crossdating
combined <- combine.rwl(files)

# special case to rename milabled core: ITA11111 should be ITA10111:
if(sitename == "ITA1"){
  labels <- colnames(combined)
  colnames(combined)<- ifelse(labels %in% "ITA11111", "ITA10111", labels)
}

#NOTE need to check MAP 3 and 4 for cores 1 and 11
if(sitename == "MAP3"){
  labels <- colnames(combined)
  colnames(combined)<- c("MAP3-1", "MAP3-10", "MAP3-11", "MAP3-12", "MAP3-2", "MAP3-4", "MAP35", "MAP3-6", "MAP3-8")
}

if(sitename == "MAP4"){
  labels <- colnames(combined)
  colnames(combined)<- c("MAP4-1", "MAP4-10", "MAP4-11", "MAP4-12", "MAP4-2", "MAP4-3", "MAP4-4", "MAP4-6", "MAP4-7",
                         "MAP4-8", "MAP4-9")
}
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
          
          
         }}}}else{ if(sitename == "GLL4"){
           new <- colnames(combined)
           
           for(i in 1:length(file_names)){
            
                 list.files <- strsplit(full_filenames, "-")
                 TreeIDnum <- do.call(rbind, list.files)
                 
                 core <- TreeIDnum[i,3]
                 tree <- TreeIDnum[i,2]
                 place <- substring(file_names[i], first = 1, 4)
                 new[i] <- paste0(place, tree, "-" ,core)
               colnames(combined) <- new
                 
               }}else{
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
                  
                  else{if(! sitename %in% c("COR", "PVC", "STC", "GLL4")){
                  
            colnames(combined)}}}}}
              



#this will write into the cofecha folder within the data folder
if(wood == "ring width"){
  
  write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
  }else{
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,wood,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
    
  }

ita.chron <- chron(combined)
plot(ita.chron)

# for outputting itasca only
if(sitename %in% "ITA1"){
  ID <- as.numeric(substr(colnames(combined), start = 4, stop = nchar(colnames(combined))-3))
  colnames(combined) <- sprintf("ITA%03d", ID)
  if(wood == "ring width"){
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
  }else{
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,wood,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
    
  }}



if(sitename %in% "GLL1"){
  ID <- as.numeric(substr(colnames(combined), start = 5, stop = nchar(colnames(combined))-2))
  colnames(combined) <- sprintf("GLL1%03d", as.numeric(TreeIDnum))
  
    labels <- colnames(combined)
    colnames(combined)<- ifelse(labels %in% "GLL1070", "GLL1020", labels)
  
  
    if(wood == "ring width"){
      
      write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
    }else{
      
      write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,wood,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
      
    }}

if(sitename %in% c("GLL2", "GLL2tilia")){
  ID <- as.numeric(substr(colnames(combined), start = 4, stop = nchar(colnames(combined))-3))
  colnames(combined) <- sprintf("GLL2%03d",  as.numeric(TreeIDnum))
  if(wood == "ring width"){
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
  }else{
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,wood,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
    
  }}

if(sitename %in% "GLL3"){
  ID <- as.numeric(substr(colnames(combined), start = 4, stop = nchar(colnames(combined))-3))
  colnames(combined) <- sprintf("GLL3%03d",  as.numeric(TreeIDnum))
  if(wood == "ring width"){
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
  }else{
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,wood,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
    
  }}


if(sitename %in% "ITAsm"){
  ID <- as.numeric(substr(colnames(combined), start = 4, stop = nchar(colnames(combined))-3))
  colnames(combined) <- sprintf("ITA%03d", ID)
  if(wood == "ring width"){
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
  }else{
    
    write.tucson(rwl.df = combined, fname = paste0("cofecha/",sitename,wood,".rwl"), format = "tucson", long.names = TRUE, prec = 0.001)
    
  }}


# output summary of rwl files:

report <- rwl.report(combined)
stats <- rwi.stats(combined)
site.summary <- data.frame(site = sitename,
           ntrees = stats$n.trees,
           Avg.age = report$segbar,
           TimeSpan = paste(report$yr0, "-", report$yr1),
           intercorrelation = report$interrbar,
           intercorrelation.sd = report$interrbar.sd, 
           AR.mean = report$interrbar, 
           AR.mean.sd = report$interrbar.sd, 
           eps = stats$eps, 
           rbar.eff = stats$rbar.eff)

write.csv(site.summary, paste0(getwd(),"/site_summaries/", sitename, "summary.csv"))

# some prelimiary cross dating:
#corr.rwl.seg(combined, seg.length=10, pcrit=0.01)

