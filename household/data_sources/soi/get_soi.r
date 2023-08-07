# -----------------------------------------------------------------
# title: grab time series of soi data
# -----------------------------------------------------------------

# set working directory
setwd("~/git/windc_build/household/data_sources/soi")

# set data directory
data.dir = getwd()

# install needed packages
list.of.packages <- 
  c("tidyverse","cpsR","survey","bea.R")

new.packages <- 
  list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) 
  install.packages(new.packages, repos = "http://cran.rstudio.com/")

lapply(list.of.packages, library, character.only = TRUE)


# ------------------------------------------------------------------------------
# function for downloading files
# ------------------------------------------------------------------------------

download_file = function(url,file.name,dir=".",check.file=NA) {

  library(httr)

  # create the directory if needed
  if (!dir.exists(dir))
    dir.create(dir)

  # if no check file name is provided use the remote file name
  if (is.na(check.file))
    check.file = file.name

  # if the check file is present then do nothing further
  if (file.exists(file.path(dir,check.file)))
    return()

  # download the file
  cat(paste0("downloading ",file.name,"... \n"))
  GET(paste0(url,file.name),
      write_disk(file.path(dir,file.name),overwrite=TRUE),
      progress())

  # if the file is a zip archive extract the contents and delete the archive
  if (tools::file_ext(file.name)=="zip") {
    cat("extracting zip file...\n")
    unzip(file.path(dir,file.name),exdir=dir)
    file.remove(file.path(dir,file.name))
  }

  cat("\n")

}


# ------------------------------------------------------------------------------
# download and read in soi data from 2014-2017
# ------------------------------------------------------------------------------

# initialize data container
soidata <- data.frame()

# static address housing csv files
url = "https://www.irs.gov/pub/irs-soi/"

# years of data
years <- c("14","15","16","17")

for (y in years) {

  # download the file
  file.name = paste0(y,"in54cmcsv.csv")
  download_file(url,file.name,dir=data.dir)
  
  # read and pivot to longer machine readable format
  temp <- read.csv(file=file.name)
  temp <- gather(temp, soicat, value, -c(STATE,AGI_STUB), factor_key=TRUE)
  names(temp) <- c("r","h","soicat","value")
  temp$yr <- paste0("20",y)
  temp <- temp %>% select(yr,r,h,soicat,value)
  soidata <- rbind(soidata,temp)
  
  # remove from ram and hardrive
  rm(temp)
  file.remove(file.name)

}

# convert value to numeric
soidata$value = as.numeric(str_replace_all(soidata$value,",",""))

# dump into a csv file
write.csv(soidata, 
          paste0("soi_income_totals_20",min(years),"_20",max(years),".csv"), 
          row.names=FALSE)


# ------------------------------------------------------------------------------
# end
# ------------------------------------------------------------------------------
