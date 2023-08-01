# -----------------------------------------------------------------
# title: grab information on commuting flows
# -----------------------------------------------------------------

# set working directory
setwd("~/git/windc_build/household/data_sources/acs")

# set data directory
data.dir = getwd()

# install needed packages
list.of.packages <- 
  c("tidyverse","readxl","dplyr")

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
# download and read in acs data
# ------------------------------------------------------------------------------

# year of data
year <- 2020

# define url and file name before downloading
url = paste0("https://www2.census.gov/programs-surveys/demo/tables/metro-micro/",
             year,"/commuting-flows-",year,"/")
file.name = "table1.xlsx"
download_file(url,file.name,dir=data.dir)
  
# read and pivot to longer machine readable format
data <- read_excel(file.name, skip = 7)
names(data) <- c("home_fips","home_cntyfips","home_state","home_county",
                 "work_fips","work_cntyfips","work_state","work_county",
                 "workers","error")

# drop NA values
data <- data[complete.cases(data),]

# aggregate over home and work states
data <- data %>% group_by(home_state,work_state) %>%
  summarize(workers = sum(workers))

# calculate average wage by state using CPS
cps <- read.csv(file="../cps/cps_asec_income_totals_2000_2021.csv")
cps_hh <- read.csv(file="../cps/cps_asec_numberhh_2000_2021.csv")
cps <- left_join(subset(cps, source %in% "hwsval"),cps_hh)
cps <- cps[complete.cases(cps),] %>%
  group_by(year,r) %>%
  summarize(wages = (sum(value)/1e6) / sum(numhh))

# grab data from 2020
cps_wages <- subset(cps, year %in% "2020")

# approximate value of commuter wages (upperbound because assuming household 
# wages = person wages)
abbr <- data.frame(
  r = c("US","AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL",
        "IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT",
        "NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI",
        "SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"),
  sname = c("united states","alabama","alaska","arizona","arkansas","california",
            "colorado","connecticut","delaware","district of columbia","florida",
            "georgia","hawaii","idaho","illinois","indiana","iowa","kansas",
            "kentucky","louisiana","maine","maryland","massachusetts","michigan",
            "minnesota","mississippi","missouri","montana","nebraska","nevada",
            "new hampshire","new jersey","new mexico","new york","north carolina",
            "north dakota","ohio","oklahoma","oregon","pennsylvania","rhode island",
            "south carolina","south dakota","tennessee","texas","utah","vermont",
            "virginia","washington","west virginia","wisconsin","wyoming"))
data$home_state = tolower(data$home_state)
data$work_state = tolower(data$work_state)
data <- merge(data,abbr, by.x="home_state",by.y="sname")
data <- merge(data,abbr, by.x="work_state",by.y="sname")
names(data)[4] <- "r"
names(data)[5] <- "rr"
data <- data %>% dplyr::select(r,rr,workers) %>%
  arrange(r,rr)

# add wages
data <- merge(data,cps_wages,by="r")
data$workers <- as.numeric(data$workers)
data$value <- data$workers * data$wages

data <- data %>% dplyr::select(r,rr,value)

# dump into a csv file
write.csv(data, 
          paste0("acs_commuting_data.csv"), 
          row.names=FALSE)

# remove downloaded file
file.remove(file.name)


# ------------------------------------------------------------------------------
# end
# ------------------------------------------------------------------------------
