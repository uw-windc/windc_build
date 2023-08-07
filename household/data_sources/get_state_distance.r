# --------------------------------------------------------------------
# get bilateral state distances
# --------------------------------------------------------------------

# set working directory
setwd("~/git/windc_build/household/data_sources")

# install needed packages
list.of.packages <- 
  c("tidyverse","cpsR","survey","bea.R","raster","sp","sf","tigris","rgeos",
    "geosphere")

new.packages <- 
  list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) 
  install.packages(new.packages, repos = "http://cran.rstudio.com/")

lapply(list.of.packages, library, character.only = TRUE)


# ------------------------------------------------------------------------------
# pull in state geometries
# ------------------------------------------------------------------------------

crs_wgs84 <- CRS(SRS_string = "EPSG:4326")
states <- states(cb=FALSE, resolution="20m", year=2016)
states <- as(states, Class = "Spatial")
states <- spTransform(states, crs_wgs84)

# restrict to states
states$GEOID <- as.numeric(states$GEOID)
states <- subset(states, GEOID < 57)

# ------------------------------------------------------------------------------
# calculate spatial centroids of states
# ------------------------------------------------------------------------------

state.centroids <- gCentroid(states, byid=TRUE)
states.df <- data.frame(r=states$STUSPS)


# ------------------------------------------------------------------------------
# calculate pairwise distances in 1000 kms between all states
# ------------------------------------------------------------------------------

# generate distances in meters (haversine considers curvature of the earth)
dist <- distm(state.centroids,state.centroids,fun = distHaversine)

# convert to 100s of kms
dist <- dist / (1000 * 100)

# convert to machine readable format and output
dist <- as.data.frame(dist)
names(dist) <- states$STUSPS
dist$r <- states$STUSPS
dist <- dist %>% pivot_longer(-c("r"), names_to = "rr", values_to = "value")
write.csv(dist, "state_distances.csv", row.names=FALSE)


# ------------------------------------------------------------------------------
# end
# ------------------------------------------------------------------------------