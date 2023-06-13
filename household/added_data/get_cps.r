# ------------------------------------------------------------------------------
# title: grab time series of cps household data
# ------------------------------------------------------------------------------

# set working directory
setwd("~/git/windc_build/household/added_data")

# install needed packages
list.of.packages <- 
  c("tidyverse","cpsR","survey")

new.packages <- 
  list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) 
  install.packages(new.packages, repos = "http://cran.rstudio.com/")

lapply(list.of.packages, library, character.only = TRUE)


# ------------------------------------------------------------------------------
# pull in cps data
# ------------------------------------------------------------------------------

# pick income upper bounds for categories to generate population information
bounds = c(25000, 50000, 75000, 150000, Inf)

# cps api key
cps.key = "a69b1c9f95e30d420fcef94d191d649a340ca7f3"

# income variables
cps.vars = c("hwsval",  # "wages and salaries"
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
             
# added variables for weighting
cps.rw =   c("gestfips", # state fips
             "a_exprrp", # ?
             "h_hhtype", # ?
             "pppos",    # ?
             "marsupwt") # ?

# function for computing shares
comp.shares <- function(x, na.rm = TRUE) (x/htotval)

## return the total reported income and share of total by income quantile for the
## specified year
get.shares = function(year) {
year = 2017

  # dowload dataset
  cpsasec <- get_asec(year, vars = c(cps.vars,cps.rw), key = cps.key, tibble=FALSE)

  # extract the household file with representative persons
  cpsasec = cpsasec[cpsasec$a_exprrp %in% c(1,2) & cpsasec$h_hhtype==1,]

  # extract the household file with representative persons
  cpsasec = cpsasec[cpsasec$pppos==41,]

  # survey design based on the replicate weights
  # svy = svrepdesign(data=cpsasec,weight=~marsupwt,repweights='pwwgt[0-9]+',
  #                   type='JK1',scale=4/60,rscales=rep(1, 161),mse=TRUE)

  # add lower bound
  bounds = c(-Inf,bounds)

  # add household label to each entry
  for (i in 1:length(bounds))
    cpsasec$hh[cpsasec$htotval>bounds[i] &
                 cpsasec$htotval<=bounds[i+1]] = paste0("hh",i)


  # scale income levels by the household weight
  for (source in cps.vars)
    cpsasec[,source] = cpsasec[,source]*cpsasec$marsupwt

  # count observations in sample by quantile and state fips
  count <- cpsasec[,c("gestfips","hh")] %>% count(hh,gestfips)
  names(count)[2] <- "state"
  nat_count <- cpsasec[,c("gestfips","hh")] %>% count(hh)
  nat_count$state <- 0
  nat_count <- nat_count[,names(count)]
  count <- rbind(nat_count,count)

  # aggregate income by quantile and state fips
  income = aggregate(cpsasec[,cps.vars],by=list(hh=cpsasec$hh,state=cpsasec$gestfips),sum)
  nat_income = aggregate(cpsasec[,cps.vars],by=list(hh=cpsasec$hh),sum)
  nat_income$state = 0
  nat_income = nat_income[,names(income)]
  income = rbind(nat_income,income)

  # convert income by quantile to share of total by state and quantile
  shares <- data.frame(income %>% group_by(state,hh) %>% 
                       mutate_at(vars(-group_cols()), comp.shares))

  # shift from wide to long format
  income = gather_(income,"source","value",cps.vars)
  shares = gather_(shares,"source","share",cps.vars)

  # add the data year
  income$year = year
  shares$year = year
  count$year = year

}


fips <- data.frame(
  state = c("0","1","2","4","5","6","8","9","10","11","12","13","15","16","17",
            "18","19","20","21","22","23","24","25","26","27","28","29","30",
            "31","32","33","34","35","36","37","38","39","40","41","42","44",
            "45","46","47","48","49","50","51","53","54","55","56"),
  sname = c("united states","alabama","alaska","arizona","arkansas","california",
            "colorado","connecticut","delaware","district of columbia","florida",
            "georgia","hawaii","idaho","illinois","indiana","iowa","kansas",
            "kentucky","louisiana","maine","maryland","massachusetts","michigan",
            "minnesota","mississippi","missouri","montana","nebraska","nevada",
            "new hampshire","new jersey","new mexico","new york","north carolina",
            "north dakota","ohio","oklahoma","oregon","pennsylvania","rhode island",
            "south carolina","south dakota","tennessee","texas","utah","vermont",
            "virginia","washington","west virginia","wisconsin","wyoming"))


## for each requested year get the income totals, shares and counts by quantile
## and state
income = NULL
shares = NULL
count = NULL
for (year in years) {
  output = get.shares(year)
  income = rbind(income,output[["income"]])
  shares = rbind(shares,output[["shares"]])
  count = rbind(count,output[["count"]])
}

## merge state names into income and shares data.frames
shares$state <- as.character(shares$state)
income$state <- as.character(income$state)
count$state <- as.character(count$state)
income <- left_join(income, fips, by="state")
shares <- left_join(shares, fips, by="state")
count <- left_join(count, fips, by="state")

## compute the average shares over the years processed
shares_avg = aggregate(list(share=income$value),
                       by=list(hh=income$hh,state=income$sname,source=income$source),sum)
shares_avg <- data.frame(
  shares_avg %>% group_by(state,source) %>% mutate_at(vars(-group_cols(),-hh),funs(./sum(.))))



## ------------------------------------------------------------------------------
## save results
## ------------------------------------------------------------------------------

write.csv(income,paste0("cps_asec_income_totals_",min(years),"_",max(years),".csv"),row.names=F)
write.csv(shares,paste0("cps_asec_income_shares_",min(years),"_",max(years),".csv"),row.names=F)
write.csv(count,paste0("cps_asec_income_counts_",min(years),"_",max(years),".csv"),row.names=F)
write.csv(shares_avg,paste0("cps_asec_income_shares_avg_",min(years),"_",max(years),".csv"),row.names=F)


## ------------------------------------------------------------------------------
## plot average shares for states and the nation
## ------------------------------------------------------------------------------

## add the income source descriptions
shares_plot = merge(shares_avg,cps.vars)

## set the ordering for the plot
shares_plot$description = factor(shares_plot$description,
                                 rev(cps.vars$description))

categories <- factor(c("hh1","hh2","hh3","hh4","hh5"))
shares_plot$hh = factor(shares_plot$hh,rev(levels(categories)))
shares_plot$state = factor(shares_plot$state)

## separate shares
state_shares <- subset(shares_plot, !(state %in% "united states"))
nation_shares <- subset(shares_plot, (state %in% "united states"))

# plot the shares by income source, decile and state
p = ggplot(state_shares)+
  geom_bar(aes(y=state,x=share,fill=hh),stat="identity")+
  scale_fill_brewer(palette="Set3") +
  facet_wrap(~description, nrow=1) +
  labs(y="State",x="Share of Total") +
  xlim(0,1) +
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
## ggsave(file.path("cps_asec_income_shares_state.png"),device="png",width=30,
##        height=20)
ggsave(file.path("cps_asec_income_shares_state_2014.png"),device="png",width=30,
       height=20)

# plot the shares by income source and decile
p = ggplot(nation_shares)+
  geom_bar(aes(y=description,x=share,fill=hh),stat="identity")+
  scale_fill_brewer(palette="Set3") +
  labs(y="Income Sources",x="Share of Total") +
  xlim(0,1.1) +
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
## ggsave(file.path("cps_asec_income_shares_nation.png"),device="png",width=10,
##        height=8)
ggsave(file.path("cps_asec_income_shares_nation_2014.png"),device="png",width=10,
       height=8)


## ------------------------------------------------------------------------------
## plot observation counts
## ------------------------------------------------------------------------------

## define plotting parameter
count_plot <- count

## characterize factors
categories <- factor(c("hh1","hh2","hh3","hh4","hh5"))
count_plot$hh = factor(count_plot$hh,rev(levels(categories)))
count_plot$sname = factor(count_plot$sname)
count_plot$year = factor(count_plot$year)

## separate shares
state_count <- subset(count_plot, !(sname %in% "united states"))
nation_count <- subset(count_plot, (sname %in% "united states"))

# plot the counts by income source, decile and state
p = ggplot(state_count)+
  geom_bar(aes(y=sname,x=n,fill=hh),stat="identity")+
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
## ggsave(file.path("cps_asec_countobs_state.png"),device="png",width=12,
##        height=8)
ggsave(file.path("cps_asec_countobs_state_2014.png"),device="png",width=12,
       height=8)

# plot the counts by income source and decile
p = ggplot(nation_count)+
  geom_bar(aes(y=n,x=hh,fill=year),stat="identity")+
  scale_fill_brewer(palette="Set3") +
  labs(y="Number of Observations",x="Quintiles") +
  guides(fill=guide_legend(title="Year",reverse=TRUE))+
  theme(axis.line.x      = element_line(colour="black"),
        axis.line.y      = element_line(colour="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border     = element_blank(),
        panel.background = element_blank(),
        legend.box.just  = "left",
        legend.key       = element_blank())
print(p)
## ggsave(file.path("cps_asec_countobs_nation.png"),device="png",width=12,
##        height=8)
ggsave(file.path("cps_asec_countobs_nation_2014.png"),device="png",width=12,
       height=8)


# ------------------------------------------------------------------------------
# end
# ------------------------------------------------------------------------------