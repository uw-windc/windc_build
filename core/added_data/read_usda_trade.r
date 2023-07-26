## ----------------------------------------------------------------
## read state exports data from usda
## source: https://www.ers.usda.gov/data-products/state-export-data/
## ----------------------------------------------------------------

## set working directory
setwd("~/git/windc_build/build_files/new_data/usda/")

## add packages
list.of.packages <- c("readxl","tidyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
lapply(list.of.packages, library, character.only = TRUE)

## read in time series of aggregate agricultural exports
rawdata <- read_excel("commodity_detail_by_state_cy.xlsx", skip=2, sheet="Total exports",
                      col_names=TRUE)
rawdata <- data.frame(rawdata)

## keep the first 21 columns
rawdata <- rawdata[,c(1:21)]

## remove NAs
rawdata <- rawdata[complete.cases(rawdata),]

## reshape data
shaped_data <- rawdata %>% gather(year, exports, -c(States))

## rename years to be numeric
shaped_data$year <- as.numeric(substr(shaped_data$year, 2, 5))

## remove united staes from listing
shaped_data <- subset(shaped_data, !(States %in% c("United States")))

## rename column names
names(shaped_data)[1] <- "r"
names(shaped_data)[2] <- "y"
names(shaped_data)[3] <- "value"

## rename states to be abbreviations
shaped_data$r[shaped_data$r=="Alaska"] <- "ak"
shaped_data$r[shaped_data$r=="Alabama"] <- "al"
shaped_data$r[shaped_data$r=="Arkansas"] <- "ar"
shaped_data$r[shaped_data$r=="Arizona"] <- "az"
shaped_data$r[shaped_data$r=="California"] <- "ca"
shaped_data$r[shaped_data$r=="Colorado"] <- "co"
shaped_data$r[shaped_data$r=="Connecticut"] <- "ct"
shaped_data$r[shaped_data$r=="D.C."] <- "dc"
shaped_data$r[shaped_data$r=="Delaware"] <- "de"
shaped_data$r[shaped_data$r=="Florida"] <- "fl"
shaped_data$r[shaped_data$r=="Georgia"] <- "ga"
shaped_data$r[shaped_data$r=="Hawaii"] <- "hi"
shaped_data$r[shaped_data$r=="Iowa"] <- "ia"
shaped_data$r[shaped_data$r=="Idaho"] <- "id"
shaped_data$r[shaped_data$r=="Illinois"] <- "il"
shaped_data$r[shaped_data$r=="Indiana"] <- "in"
shaped_data$r[shaped_data$r=="Kansas"] <- "ks"
shaped_data$r[shaped_data$r=="Kentucky"] <- "ky"
shaped_data$r[shaped_data$r=="Louisiana"] <- "la"
shaped_data$r[shaped_data$r=="Massachusetts"] <- "ma"
shaped_data$r[shaped_data$r=="Maryland"] <- "md"
shaped_data$r[shaped_data$r=="Maine"] <- "me"
shaped_data$r[shaped_data$r=="Michigan"] <- "mi"
shaped_data$r[shaped_data$r=="Minnesota"] <- "mn"
shaped_data$r[shaped_data$r=="Missouri"] <- "mo"
shaped_data$r[shaped_data$r=="Mississippi"] <- "ms"
shaped_data$r[shaped_data$r=="Montana"] <- "mt"
shaped_data$r[shaped_data$r=="North Carolina"] <- "nc"
shaped_data$r[shaped_data$r=="North Dakota"] <- "nd"
shaped_data$r[shaped_data$r=="Nebraska"] <- "ne"
shaped_data$r[shaped_data$r=="New Hampshire"] <- "nh"
shaped_data$r[shaped_data$r=="New Jersey"] <- "nj"
shaped_data$r[shaped_data$r=="New Mexico"] <- "nm"
shaped_data$r[shaped_data$r=="Nevada"] <- "nv"
shaped_data$r[shaped_data$r=="New York"] <- "ny"
shaped_data$r[shaped_data$r=="Ohio"] <- "oh"
shaped_data$r[shaped_data$r=="Oklahoma"] <- "ok"
shaped_data$r[shaped_data$r=="Oregon"] <- "or"
shaped_data$r[shaped_data$r=="Pennsylvania"] <- "pa"
shaped_data$r[shaped_data$r=="Rhode Island"] <- "ri"
shaped_data$r[shaped_data$r=="South Carolina"] <- "sc"
shaped_data$r[shaped_data$r=="South Dakota"] <- "sd"
shaped_data$r[shaped_data$r=="Tennessee"] <- "tn"
shaped_data$r[shaped_data$r=="Texas"] <- "tx"
shaped_data$r[shaped_data$r=="Utah"] <- "ut"
shaped_data$r[shaped_data$r=="Virginia"] <- "va"
shaped_data$r[shaped_data$r=="Vermont"] <- "vt"
shaped_data$r[shaped_data$r=="Washington"] <- "wa"
shaped_data$r[shaped_data$r=="Wisconsin"] <- "wi"
shaped_data$r[shaped_data$r=="West Virginia"] <- "wv"
shaped_data$r[shaped_data$r=="Wyoming"] <- "wy"

## define year and value as numeric
shaped_data$y <- as.numeric(shaped_data$y)
shaped_data$value <- as.numeric(shaped_data$value)

## output dataset
write.csv(shaped_data, "usda_time_series_exports.csv", row.names=FALSE)
