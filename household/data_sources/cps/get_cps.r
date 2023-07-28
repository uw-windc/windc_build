# ------------------------------------------------------------------------------
# title: grab time series of cps household data
# ------------------------------------------------------------------------------

# set working directory
setwd("~/git/windc_build/household/data_sources/cps")

# install needed packages
list.of.packages <- 
  c("tidyverse","cpsR","survey","bea.R")

new.packages <- 
  list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) 
  install.packages(new.packages, repos = "http://cran.rstudio.com/")

lapply(list.of.packages, library, character.only = TRUE)


# ------------------------------------------------------------------------------
# pull in cps data
# ------------------------------------------------------------------------------

# years of needed data (asec does not exist prior to 2001. estimates from 
# datasets between 2001 and 2004 are estimated.)
years = 2000:2021

# pick income upper bounds for categories to generate population information
upper_bounds = c(25000, 50000, 75000, 150000, Inf)

# cps and bea api keys
cps.key = "a69b1c9f95e30d420fcef94d191d649a340ca7f3"
bea.key = "12C8FE9E-DF75-4515-B170-296AB4E9AB93"

# income variables pre 2019 (retirement income variables redefined in 2019)
cps.vars.pre2019 = c("hwsval",  # "wages and salaries"
                     "hseval",  # "self-employment (nonfarm)"
                     "hfrval",  # "self-employment farm"
                     "hucval",  # "unemployment compensation"
                     "hwcval",  # "workers compensation"
                     "hssval",  # "social security"
                     "hssival", # "supplemental security"
                     "hpawval", # "public assistance or welfare"
                     "hvetval", # "veterans benefits"
                     "hsurval", # "survivors income"
                     "hdisval", # "disability"
                     "hretval", # "retirement income"
                     "hintval", # "interest"
                     "hdivval", # "dividends"
                     "hrntval", # "rents"
                     "hedval",  # "educational assistance"
                     "hcspval", # "child support"
                     "hfinval", # "financial assistance"
                     "hoival",  # "other income"
                     "htotval") # "total household income

#          "hcspval","hfinval","hoival"

# income variables post 2019 (retirement income variables redefined in 2019)
cps.vars.post2019 = c("hwsval",  # "wages and salaries"
                      "hseval",  # "self-employment (nonfarm)"
                      "hfrval",  # "self-employment farm"
                      "hucval",  # "unemployment compensation"
                      "hwcval",  # "workers compensation"
                      "hssval",  # "social security"
                      "hssival", # "supplemental security"
                      "hpawval", # "public assistance or welfare"
                      "hvetval", # "veterans benefits"
                      "hsurval", # "survivors income"
                      "hdisval", # "disability"
                      "hdstval", # "retirement distributions"
                      "hpenval", # "pension income"
                      "hannval", # "annuities"
                      "hintval", # "interest"
                      "hdivval", # "dividends"
                      "hrntval", # "rents"
                      "hedval",  # "educational assistance"
                      "hcspval", # "child support"
                      "hfinval", # "financial assistance"
                      "hoival",  # "other income"
                      "htotval") # "total household income
             
# added variables for weighting
cps.rw =   c("gestfips", # state fips
             "a_exprrp", # expanded relationship code
             "h_hhtype", # type of household interview
             "pppos",    # person identifier
             "marsupwt") # asec supplement final weight

# first verify that sum of income categories equals total household 
# income (commented out)

# year = 2021
# cpsasec <- get_asec(year+1, vars = c(cps.vars.post2019,cps.rw), key = cps.key, tibble=FALSE)
# cpsasec.total <- subset(cpsasec, select = c(htotval))
# cpsasec.cat <- subset(cpsasec, select = c(cps.vars.post2019)) 
# cpsasec.cat <- subset(cpsasec.cat, select = c(-htotval)) %>%
#    mutate(htotval_dis = rowSums(across())) %>%
#    select(htotval_dis)
# cpsasec.total = cbind(cpsasec.total,cpsasec.cat)
# cpsasec.total$diff = cpsasec.total$htotval - cpsasec.total$htotval_dis
# cpsasec.total$pct = 100 * cpsasec.total$diff / cpsasec.total$htotval
# max(cpsasec.total$pct)

## return the total reported income and share of total by income quantile for the
## specified year
get.shares = function(year) {

  # download and process the cps march supplement for the year after requested
  # since income questions on the supplement are for the previous year
  if (year < 2018) {
    cpsasec <- get_asec(year+1, vars = c(cps.vars.pre2019,cps.rw), key = cps.key, tibble=FALSE)
  } else {
    cpsasec <- get_asec(year+1, vars = c(cps.vars.post2019,cps.rw), key = cps.key, tibble=FALSE)
  }

  # add column for aggregate retirement distributions to align datasets
  # if (year >= 2018) {
  #   cpsasec$hretval = cpsasec$hdstval + cpsasec$hpenval + cpsasec$hannval
  #   cps.vars.post2019.add = c(cps.vars.post2019,"hretval")
  # }
  cps.vars.post2019.add = cps.vars.post2019

  # extract the household file with representative persons
  cpsasec = cpsasec[cpsasec$a_exprrp %in% c(1,2) & cpsasec$h_hhtype==1,]

  # extract the household file with representative persons
  cpsasec = cpsasec[cpsasec$pppos==41,]

  # survey design based on the replicate weights
  # svy = svrepdesign(data=cpsasec,weight=~marsupwt,repweights='pwwgt[0-9]+',
  #                   type='JK1',scale=4/60,rscales=rep(1, 161),mse=TRUE)

  # add household label to each entry
  bounds <- c(-Inf,upper_bounds)
  for (i in 1:length(bounds))
    cpsasec$hh[cpsasec$htotval>bounds[i] &
                 cpsasec$htotval<=bounds[i+1]] = paste0("hh",i)

  # scale income levels by the household weight
  if (year < 2018) {
    for (source in cps.vars.pre2019)
      cpsasec[,source] = cpsasec[,source]*cpsasec$marsupwt
  } else {
    for (source in cps.vars.post2019.add)
      cpsasec[,source] = cpsasec[,source]*cpsasec$marsupwt
  }

  # count observations in sample by quantile and state fips
  count <- cpsasec[,c("gestfips","hh")] %>% count(hh,gestfips)
  names(count)[2] <- "state"
  nat_count <- cpsasec[,c("gestfips","hh")] %>% count(hh)
  nat_count$state <- 0
  nat_count <- nat_count[,names(count)]
  count <- rbind(nat_count,count)

  # report number of households in millions by quantile and state fips
  numhh <- cpsasec[,c("gestfips","hh","marsupwt")] %>% group_by(gestfips,hh) %>%
    summarize(numhh = sum(marsupwt,na.rm=TRUE)*1e-6)
  names(numhh)[1] <- "state"

  # aggregate income by quantile and state fips
  if (year < 2018) {
  income = aggregate(
    cpsasec[,cps.vars.pre2019],by=list(hh=cpsasec$hh,state=cpsasec$gestfips),sum)
  nat_income = aggregate(
    cpsasec[,cps.vars.pre2019],by=list(hh=cpsasec$hh),sum)
  } else {
  income = aggregate(
    cpsasec[,cps.vars.post2019.add],by=list(hh=cpsasec$hh,state=cpsasec$gestfips),sum)
  nat_income = aggregate(
    cpsasec[,cps.vars.post2019.add],by=list(hh=cpsasec$hh),sum)
  }
  nat_income$state = 0
  nat_income = nat_income[,names(income)]
  income = rbind(nat_income,income)

  # convert income by quantile to share of total by state and quantile
  shares <- data.frame(income %>% group_by(state) %>% 
                       mutate(across(-c(hh), ~./sum(.))))

  # shift from wide to long format
  income = income %>% pivot_longer(!c(state,hh), names_to = "source", values_to = "value")
  shares = shares %>% pivot_longer(!c(state,hh), names_to = "source", values_to = "value")

  # add the data year
  income$year = year
  shares$year = year
  count$year = year
  numhh$year = year
  
  # function returns list of outputs
  return(list(income=income,shares=shares,count=count,numhh=numhh))

}

# mapping fips to state names
state_names = 
  c("Alabama","Alaska","Arizona","Arkansas","California","Colorado",
    "Connecticut","Delaware","District of Columbia","Florida","Georgia",
    "Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky",
    "Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota",
    "Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire",
    "New Jersey","New Mexico","New York","North Carolina","North Dakota",
    "Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina",
    "South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington",
    "West Virginia","Wisconsin","Wyoming","United States")

state_fips = 
  c("1","2","4","5","6","8","9","10","11","12","13","15","16","17","18",
    "19","20","21","22","23","24","25","26","27","28","29","30","31","32","33",
    "34","35","36","37","38","39","40","41","42","44","45","46","47","48","49",
    "50","51","53","54","55","56","0")

state_abbr = 
  c("AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN",
    "IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH",
    "NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT",
    "VT","VA","WA","WV","WI","WY","US")

statemap = data.frame(name = state_names, state = state_fips, r = state_abbr)


# for each requested year get the income totals, shares, and counts by quantile
# and state
income = NULL
shares = NULL
count = NULL
numhh = NULL
for (year in years) {
  output = get.shares(year)
  income = rbind(income,output[["income"]])
  shares = rbind(shares,output[["shares"]])
  count = rbind(count,output[["count"]])
  numhh = rbind(numhh,output[["numhh"]])
}

# merge state names into income and shares data.frames
shares$state <- as.character(shares$state)
income$state <- as.character(income$state)
count$state <- as.character(count$state)
numhh$state <- as.character(numhh$state)

income <- left_join(income, statemap, by="state")
shares <- left_join(shares, statemap, by="state")
count <- left_join(count, statemap, by="state")
numhh <- left_join(numhh, statemap, by="state")

# keep needed columns in data
income <- income %>% select(year,r,hh,source,value)
shares <- shares %>% select(year,r,hh,source,value)
count <- count %>% select(year,r,hh,n)
numhh <- numhh %>% select(year,r,hh,numhh)
numhh$state = NULL


# ------------------------------------------------------------------------------
# assess variable changes in retirement income
# ------------------------------------------------------------------------------

# combine variable ids with labels
cps.vars.plot = rbind(
                 c("hretval","retirement income"),
                 c("hdstval","retirement distributions"),
                 c("hpenval","pension income"),
                 c("hannval","annuities"))

cps.vars.plot = data.frame(source=cps.vars.plot[,1],
                           description=cps.vars.plot[,2],
                           stringsAsFactors=FALSE)

# add the income source descriptions
shares_plot = left_join(subset(shares,source %in% cps.vars.plot$source),
                        cps.vars.plot,by="source")
income_plot = left_join(subset(income,source %in% cps.vars.plot$source),
                        cps.vars.plot,by="source")

# set the ordering for the plot
shares_plot$description = factor(shares_plot$description,
                                 rev(cps.vars.plot$description))
shares_plot$year = factor(shares_plot$year)

income_plot$description = factor(income_plot$description,
                                 rev(cps.vars.plot$description))
income_plot$year = factor(income_plot$year)

categories <- factor(c("hh1","hh2","hh3","hh4","hh5"))
shares_plot$hh = factor(shares_plot$hh,rev(levels(categories)))
shares_plot$r = factor(shares_plot$r)

income_plot$hh = factor(income_plot$hh,rev(levels(categories)))
income_plot$r = factor(income_plot$r)

state_shares <- subset(shares_plot, r %in% "US")
state_income <- subset(income_plot, r %in% "US")

p = ggplot(state_shares)+
  geom_bar(aes(y=year,x=value,fill=hh),stat="identity")+
  scale_fill_brewer(palette="Set3") +
  facet_grid(r~description, scales="free") +
  labs(y="Year",x="Share of Total") +
#  xlim(0,1) +
  guides(fill=guide_legend(title="Household Categories",reverse=TRUE))+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)

p = ggplot(state_income)+
  geom_bar(aes(y=year,x=value/1e9,fill=hh),stat="identity")+
  scale_fill_brewer(palette="Set3") +
  facet_grid(r~description, scales="fixed") +
  labs(y="Year",x="billions $") +
#  xlim(0,1) +
  guides(fill=guide_legend(title="Household Categories",reverse=TRUE))+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)


# ------------------------------------------------------------------------------
# save cps results
# ------------------------------------------------------------------------------

# income totals
write.csv(income,
          paste0("cps_asec_income_totals_",min(years),"_",max(years),".csv"),
          row.names=F)

# income shares
write.csv(shares,
          paste0("cps_asec_income_shares_",min(years),"_",max(years),".csv"),
          row.names=F)

# count of observations
write.csv(count,
          paste0("cps_asec_income_counts_",min(years),"_",max(years),".csv"),
          row.names=F)

# number of households in u.s.
write.csv(numhh,
          paste0("cps_asec_numberhh_",min(years),"_",max(years),".csv"),
          row.names=F)


# ------------------------------------------------------------------------------
# download/reconcile/save nipa income data
# ------------------------------------------------------------------------------

# [1] "Personal income"
# 	[2] "Compensation of employees"
# 		[3] "Wages and salaries"
# 			[4] "Private industries"
# 			[5] "Government"
# 		[6] "Supplements to wages and salaries"
# 			[7] "Employer contributions for employee pension and insurance funds"
# 			[8] "Employer contributions for government social insurance"
# 	[9] "Proprietors' income with inventory valuation and capital consumption adjustments"
# 		[10] "Farm"
# 		[11] "Nonfarm"
# 	[12] "Rental income of persons with capital consumption adjustment"
# 	[13] "Personal income receipts on assets"
# 		[14] "Personal interest income"
# 		[15] "Personal dividend income"
# 	[16] "Personal current transfer receipts"
# 		[17] "Government social benefits to persons"
# 	    [18] "Social security"
# 		  [19] "Medicare"
# 		  [20] "Medicaid"
# 		  [21] "Unemployment insurance"
# 		  [22] "Veterans' benefits"
# 		  [23] "Other"
# 	  [24] "Other current transfer receipts, from business (net)"
# 	[25] "Less: Contributions for government social insurance, domestic"
# [26] "Less: Personal current taxes"
# [27] "Equals: Disposable personal income"
# [28] "Less: Personal outlays"
# 	[29] "Personal consumption expenditures"
# 	[30] "Personal interest payments"
# 	[31] "Personal current transfer payments"
# 		[32] "To government"
# 		[33] "To the rest of the world (net)"
# [34] "Equals: Personal saving"
# 	[35] "Personal saving as a percentage of disposable personal income"

# download bea nipa data
specs <- list(
  'UserID' = bea.key,
  'Method' = 'GetData',
  'datasetname' = 'NIPA',
  'TableName' = 'T20100',
  'Frequency' = 'A',
  'Year' = '2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021',
  'ResultFormat' = 'json'
)
beadata <- data.frame(beaGet(specs))

# convert data to long format
beadata <- pivot_longer(
  beadata, 
  -c(TableName,SeriesCode,LineNumber,LineDescription,METRIC_NAME,CL_UNIT,UNIT_MULT),
  names_to = "year", values_to = "value")

beadata$year = as.numeric(str_replace(beadata$year,"DataValue_",""))

# keep all data, using gams to piece together needed components
write.csv(beadata, "nipa_income_outlays_2000_2021.csv", row.names=FALSE)


# ------------------------------------------------------------------------------
# read in windc totals from core database
# ------------------------------------------------------------------------------

system('gdxdump ../../core/WiNDCdatabase.gdx output=ld0_windc.csv symb=ld0_ format=csv')
system('gdxdump ../../core/WiNDCdatabase.gdx output=kd0_windc.csv symb=kd0_ format=csv')

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

ld0 = read.csv(file=file.path("ld0_windc.csv")) %>%
  group_by(yr,r) %>%
  summarize(value = sum(Val,na.rm=TRUE)*1e9) %>%
  rename("year"="yr") %>%
  left_join(abbr)

kd0 = read.csv(file=file.path("kd0_windc.csv")) %>%
  group_by(yr,r) %>%
  summarize(value = sum(Val,na.rm=TRUE)*1e9) %>%
  rename("year"="yr") %>%
  left_join(abbr)

ld0_windc = ld0 %>% group_by(year) %>% summarize(windc = sum(value))
kd0_windc = kd0 %>% group_by(year) %>% summarize(windc = sum(value))


# ------------------------------------------------------------------------------
# compare cps and windc totals with nipa accounts
# ------------------------------------------------------------------------------

# plot for comparison with nipa and cps/windc

# aggregate cps data to national totals
cps_totals = subset(income, r %in% "US") %>%
  group_by(year,source) %>%
  summarize(cps = sum(value))

# link cps categories and nipa accounts

# [1] "Personal income"
#     "htotval"

nipa_cps_totinc = subset(beadata, LineNumber %in% "1") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "htotval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "total income") %>%
  select(-source)

# 	[2] "Compensation of employees"
# 		[3] "Wages and salaries"
#         "hwsval"

nipa_cps_wages = subset(beadata, LineNumber %in% "3") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "hwsval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "wages and salaries") %>%
  select(-source)

# 			[4] "Private industries"
# 			[5] "Government"
# 		[6] "Supplements to wages and salaries"
# 			[7] "Employer contributions for employee pension and insurance funds"
# 			[8] "Employer contributions for government social insurance"
# 	[9] "Proprietors' income with inventory valuation and capital consumption adjustments"
# 		[10] "Farm"
#          "hfrval"

nipa_cps_farm = subset(beadata, LineNumber %in% "10") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "hfrval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "proprietor's income: farm") %>%
  select(-source)

# 		[11] "Nonfarm"
#          "hseval"

nipa_cps_nonfarm = subset(beadata, LineNumber %in% "11") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "hseval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "proprietor's income: non-farm") %>%
  select(-source)

# 	[12] "Rental income of persons with capital consumption adjustment"
#        "hrntval"

nipa_cps_rent = subset(beadata, LineNumber %in% "12") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "hrntval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "rental income") %>%
  select(-source)

# 	[13] "Personal income receipts on assets"
# 		[14] "Personal interest income"
#          "hintval"

nipa_cps_interest = subset(beadata, LineNumber %in% "14") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "hintval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "personal interest income") %>%
  select(-source)

# 		[15] "Personal dividend income"
#          "hdivval"

nipa_cps_div = subset(beadata, LineNumber %in% "15") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "hdivval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "personal divident income") %>%
  select(-source)

# 	[16] "Personal current transfer receipts"
# 		[17] "Government social benefits to persons"
# 	    [18] "Social security"
#            "hssval","hssival","hdisval"

cps_socsec = subset(cps_totals, source %in% c("hssval","hssival","hdisval")) %>%
  group_by(year) %>% summarize(cps = sum(cps))
nipa_cps_socsec = subset(beadata, LineNumber %in% "18") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(cps_socsec) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "government benefits: social security")

# 		  [19] "Medicare"
# 		  [20] "Medicaid"
# 		  [21] "Unemployment insurance"
#            "hucval"

nipa_cps_uc = subset(beadata, LineNumber %in% "21") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "hucval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "government benefits: unemployment insurance") %>%
  select(-source)

# 		  [22] "Veterans' benefits"
#            "hvetval"

nipa_cps_vet = subset(beadata, LineNumber %in% "22") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(subset(cps_totals, source %in% "hvetval")) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "government benefits: veterans' benefits") %>%
  select(-source)

# 		  [23] "Other"
#            "hwcval","hpawval","hsurval","hedval",

cps_othtran = subset(cps_totals, source %in% c("hwcval","hpawval","hsurval","hedval")) %>%
  group_by(year) %>% summarize(cps = sum(cps))
nipa_cps_othtran = subset(beadata, LineNumber %in% "23") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(cps_othtran) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "government benefits: other")

# 	  [24] "Other current transfer receipts, from business (net)"
#          "hcspval","hfinval","hoival"

# hoival: household income - other income: (such as foster child care, alimony, 
#         jury duty, armed forces reserves, severance pay, hobbies, or any other 
#         source
# hfinval:household income - financial assistance income
# hcspval:household income - child support

cps_nongovtran = subset(cps_totals, source %in% c("hcspval","hfinval","hoival")) %>%
  group_by(year) %>% summarize(cps = sum(cps))
nipa_cps_nongovtran = subset(beadata, LineNumber %in% "24") %>%
  rename("nipa"="value","desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(cps_nongovtran) %>%
  mutate(pct_diff = 100 * (cps / nipa - 1),
         category = "non-government transfer income")

# plot and report differences (for reference on what drives differences -- 
# https://www.census.gov/topics/income-poverty/income/guidance/data-sources/cps-vs-other.html)
nipa_cps = rbind(nipa_cps_totinc, nipa_cps_wages,nipa_cps_farm, nipa_cps_nonfarm,
                 nipa_cps_rent, nipa_cps_interest, nipa_cps_div,
                 nipa_cps_socsec, nipa_cps_uc, nipa_cps_vet,
                 nipa_cps_othtran, nipa_cps_nongovtran)
nipa_cps$category = factor(nipa_cps$category,
                           levels = unique(nipa_cps$category))
nipa_cps$year = factor(nipa_cps$year)
p = ggplot(nipa_cps)+
  geom_bar(aes(x=year,y=pct_diff,fill=category),position="dodge",stat="identity",color="black")+
  scale_fill_brewer(palette="Set3") +
  labs(title="CPS vs. NIPA: Aggregate Income Categories", 
       x="Year",y="% Difference from NIPA")+
  guides(fill=guide_legend(title="Income Category",reverse=FALSE))+
  facet_wrap(~category, ncol=4, scales="fixed")+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        axis.text.x      = element_text(angle=90),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)
ggsave(file.path("cps_vs_nipa_income_categories.png"),device="png",width=14,
      height=6, limitsize=FALSE)

write.csv(nipa_cps,"cps_vs_nipa_income_categories.csv",row.names=FALSE)


# link windc categories and nipa accounts
# ld0 = [2] "Compensation of employees"
# kd0 = [9] "Proprietors' income with inventory valuation and capital consumption adjustments"
#       [12] "Rental income of persons with capital consumption adjustment"
#       [13] "Personal income receipts on assets"

nipa_windc_labor = subset(beadata, LineNumber %in% "2") %>%
  rename("nipa"="value", "desc"="LineDescription") %>%
  select(year,nipa) %>%
  mutate(nipa = nipa * 1e6) %>%
  left_join(ld0_windc) %>%
  mutate(pct_diff = 100 * (windc / nipa - 1),
         category = "labor")

nipa_windc_capital = subset(beadata, LineNumber %in% c("9","12","13")) %>%
  group_by(year) %>%
  summarize(nipa = sum(value)*1e6) %>%
  select(year,nipa) %>%
  left_join(kd0_windc) %>%
  mutate(pct_diff = 100 * (windc / nipa - 1),
         category = "capital")

# plot and report difference between windc and nipa
nipa_windc = rbind(nipa_windc_labor, nipa_windc_capital)
p = ggplot(subset(nipa_windc, !(windc %in% NA)))+
  geom_bar(aes(x=year,y=pct_diff,fill=category),position="dodge",stat="identity",color="black")+
  scale_fill_brewer(palette="Set3") +
  labs(title="WiNDC vs. NIPA: Aggregate Income Categories", 
       x="Year",y="% Difference from NIPA",
       subtitle="Difference in capital income -- foreign capital ownership, capital gains.") +
  guides(fill=guide_legend(title="Income Category",reverse=TRUE))+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)
ggsave(file.path("windc_vs_nipa_income_categories.png"),device="png",width=10,
      height=6, limitsize=FALSE)

write.csv(nipa_windc,"windc_vs_nipa_income_categories.csv",row.names=FALSE)


# ------------------------------------------------------------------------------
# plot the time series of cps data (counts and shares)
# ------------------------------------------------------------------------------

# combine variable ids with labels
cps.vars.plot = rbind(
  c("hwsval","wages and salaries"),
  c("hseval","self-employment (nonfarm)"),
  c("hfrval","self-employment farm"),
  c("hucval","unemployment compensation"),
  c("hwcval","workers compensation"),
  c("hssval","social security"),
  c("hssival","supplemental security"),
  c("hpawval","public assistance or welfare"),
  c("hvetval","veterans benefits"),
  c("hsurval","survivors income"),
  c("hdisval","disability"),
  c("hretval","retirement income"),
  c("hdstval","retirement distributions"),
  c("hpenval","pension income"),
  c("hannval","annuities"),
  c("hintval","interest"),
  c("hdivval","dividends"),
  c("hrntval","rents"),
  c("hedval","educational assistance"),
  c("hcspval","child support"),
  c("hfinval","financial assistance"),
  c("hoival","other income"),
  c("htotval","total household income"))

cps.vars.plot = data.frame(
  source=cps.vars.plot[,1],
  description=cps.vars.plot[,2],
  stringsAsFactors=FALSE)

# add the income source descriptions
shares_plot = left_join(shares,cps.vars.plot,by="source")

# set the ordering for the plot
shares_plot$description = factor(shares_plot$description,
                                 rev(cps.vars.plot$description))

shares_plot$year = factor(shares_plot$year)

categories <- factor(c("hh1","hh2","hh3","hh4","hh5"))
shares_plot$hh = factor(shares_plot$hh,rev(levels(categories)))
shares_plot$r = factor(shares_plot$r)

# separate shares
state_shares <- subset(shares_plot, !(r %in% "US"))
nation_shares <- subset(shares_plot, (r %in% "US"))

# plot the shares by income source, decile and state
p = ggplot(state_shares)+
  geom_bar(aes(y=r,x=value,fill=hh),stat="identity")+
  scale_fill_brewer(palette="Set3") +
  facet_grid(year~description, scales="free") +
  labs(y="State",x="Share of Total") +
#  xlim(0,1) +
  guides(fill=guide_legend(title="Household Categories",reverse=TRUE))+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)
ggsave(file.path("cps_asec_income_shares_state.png"),device="png",width=50,
      height=60, limitsize=FALSE)

# plot the shares by income source and decile
p = ggplot(nation_shares)+
  geom_bar(aes(y=year,x=value,fill=hh),stat="identity")+
  facet_wrap(~description,nrow=4) +
  scale_fill_brewer(palette="Set3") +
  labs(y="years",x="Share of Total") +
#   xlim(0,1.1) +
  guides(fill=guide_legend(title="Household Categories",reverse=TRUE))+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)
ggsave(file.path("cps_asec_income_shares_nation.png"),device="png",width=20,
      height=15)

## define plotting parameter
count_plot <- count

## characterize factors
categories <- factor(c("hh1","hh2","hh3","hh4","hh5"))
count_plot$hh = factor(count_plot$hh,rev(levels(categories)))
count_plot$r = factor(count_plot$r)
count_plot$year = factor(count_plot$year)

## separate shares
state_count <- subset(count_plot, !(r %in% "US"))
nation_count <- subset(count_plot, (r %in% "US"))

# plot the counts by income source, decile and state
p = ggplot(state_count)+
  geom_bar(aes(y=r,x=n,fill=hh),stat="identity")+
  scale_fill_brewer(palette="Set3") +
  labs(y="State",x="Number of Observations") +
  facet_wrap(~year,nrow=1) +
  guides(fill=guide_legend(title="Quintile",reverse=TRUE))+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)
ggsave(file.path("cps_asec_countobs_state.png"),device="png",width=25,
       height=20)

# plot the counts by income source and decile
p = ggplot(nation_count)+
  geom_bar(aes(y=year,x=n,fill=hh),stat="identity")+
  scale_fill_brewer(palette="Set3") +
  labs(y="Year",x="N") +
  guides(fill=guide_legend(title="Quintiles",reverse=TRUE))+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)
ggsave(file.path("cps_asec_countobs_nation.png"),device="png",width=12,
       height=8)


# ------------------------------------------------------------------------------
# end
# ------------------------------------------------------------------------------