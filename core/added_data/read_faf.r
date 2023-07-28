# ------------------------------------------------------------------------------
# title: grab time series of freight analysis framework trade data
# in future iterations, may be able to leverage mode to get at margin markup?
# ------------------------------------------------------------------------------

# set working directory
setwd("~/git/windc_build/core/added_data")

# set data directory
data.dir = getwd()

# install needed packages
list.of.packages <- 
  c("httr","tidyverse","readxl")

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
# download faf data -- https://www.bts.gov/faf
# ------------------------------------------------------------------------------

# historical state data (1997-2012)
url = "https://faf.ornl.gov/faf5/data/download_files/"
file.name = "FAF5.5_Reprocessed_1997-2012_State"
download_file(url,paste0(file.name,".zip"),dir=data.dir)
faf_hist = read.csv(file=paste0(file.name,".csv"))
file.remove(paste0(file.name,".csv"))

# 2017-2050 projections state data
file.name = "FAF5.5_State"
download_file(url,paste0(file.name,".zip"),dir=data.dir)
faf_cur = read.csv(file=paste0(file.name,".csv"))
file.remove(paste0(file.name,".csv"))

# read in the data dictionary elements
datadict.file = "FAF5_metadata.xlsx"
dict = read_excel(datadict.file,sheet="Data Dictionary",range="A3:B19")

states = read_excel(datadict.file,sheet="State")
faf_zone_dom = read_excel(datadict.file,sheet="FAF Zone (Domestic)")
faf_zone_for = read_excel(datadict.file,sheet="FAF Zone (Foreign)")
sctg = read_excel(datadict.file,sheet="Commodity (SCTG2)")
mode = read_excel(datadict.file,sheet="Mode")
trd = read_excel(datadict.file,sheet="Trade Type")
dist_band = read_excel(datadict.file,sheet="Distance Band")
file.remove(datadict.file)


# ------------------------------------------------------------------------------
# string together time series, aggregating by origin-destination pairs
# ------------------------------------------------------------------------------

# only keep domestic trade flows
faf_cur = faf_cur %>% filter(trade_type %in% 1) %>% 
  select(-c(fr_orig,fr_dest,fr_inmode,fr_outmode,trade_type)) %>%
  select(-contains(c("current_value","tons","tmiles")))
faf_hist = faf_hist %>% filter(trade_type %in% 1) %>%
  select(-c(fr_orig,fr_dest,fr_inmode,fr_outmode,trade_type)) %>%
  select(-contains(c("current_value","tons","tmiles")))

# pivot the data to be in long format
faf_cur = faf_cur %>%
  pivot_longer(-c("dms_origst","dms_destst","dms_mode","sctg2","dist_band"),
               values_to="value",
               names_to="years")
faf_cur$years = as.numeric(str_replace(faf_cur$years,"value_",""))

faf_hist = faf_hist %>%
  pivot_longer(-c("dms_origst","dms_destst","dms_mode","sctg2"),
               values_to="value",
               names_to="years")
faf_hist$years = as.numeric(str_replace(faf_hist$years,"value_",""))

# aggregate values by orig-dest, sctg2, year
faf_cur = faf_cur %>% group_by(dms_origst,dms_destst,sctg2,years) %>%
  summarize(value = sum(value,na.rm=TRUE))

faf_hist = faf_hist %>% group_by(dms_origst,dms_destst,sctg2,years) %>%
  summarize(value = sum(value,na.rm=TRUE))

# bind together
faf = rbind(faf_hist,faf_cur)

# restrict data to latest year that isn't a projection
faf = faf %>% filter(years <= 2021) %>%
  arrange(dms_origst,dms_destst,sctg2,years)

# map state numeric identifiers to abbreviations
state_names = 
  c("Alabama","Alaska","Arizona","Arkansas","California","Colorado",
    "Connecticut","Delaware","District of Columbia","Florida","Georgia",
    "Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky",
    "Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota",
    "Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire",
    "New Jersey","New Mexico","New York","North Carolina","North Dakota",
    "Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina",
    "South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington",
    "West Virginia","Wisconsin","Wyoming")

state_fips = 
  c("01","02","04","05","06","08","09","10","11","12","13","15","16","17","18",
    "19","20","21","22","23","24","25","26","27","28","29","30","31","32","33",
    "34","35","36","37","38","39","40","41","42","44","45","46","47","48","49",
    "50","51","53","54","55","56")

state_abbr = 
  c("AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN",
    "IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH",
    "NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT",
    "VT","VA","WA","WV","WI","WY")

statemap = data.frame(names = state_names, fips = state_fips, r = state_abbr)

# pad state identifier to be character vectors
faf = faf %>% 
  mutate(orig = str_pad(dms_origst,2,side="left","0"),
         dest = str_pad(dms_destst,2,side="left","0"))

# link to state abbreviations
faf = merge(faf, statemap, by.x="orig", by.y ="fips")
faf$orig = faf$r
faf$dms_origst = NULL
faf$names = NULL
faf$r = NULL

faf = merge(faf, statemap, by.x="dest", by.y ="fips")
faf$dest = faf$r
faf$dms_destst = NULL
faf$names = NULL
faf$r = NULL


# ------------------------------------------------------------------------------
# dump into a csv file
# ------------------------------------------------------------------------------

write.csv(faf,"faf_data_1997_2021.csv",row.names=FALSE)


# ------------------------------------------------------------------------------
# end
# ------------------------------------------------------------------------------
