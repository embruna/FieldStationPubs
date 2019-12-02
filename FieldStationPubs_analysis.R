############################################
# Code to import, organize, and analyze data from BCI and La Selva.
# Group Project for SciWri19
############################################


############################################
# SEARCHING FOR THE DATA
############################################

# The search strings used were: 
# FOR STRI
# Web of Science Core Collection (1900-2017) 
# June 29, 2017 
# Advanced Search with following strings: 
#   1)    OG=(Smithsonian Tropical Research Institute) (MAY INCLUDE PANAMA, KENYA, AND MANAUS): 5443. Need to filter out the ones that include STRI-BDFFP and STRI-Mpala or other.
#   2)    TS=Smithsonian Trop*: 69 (0 after removing dupes)
#   3)    AD=STRI 306 (0 after removing dupes)
#   4)    TS=Barro Colorado Isla* = 903 (563 after removing dupes)

# FOR OTS
# Web of Science Core Collection (1900-2017) 
# June 29, 2017 
# Advanced Search with following strings: 
#   
#   OO=Organization for Tropical Stud* = 0
# AD=Organization for Tropical Stud* = 0
# AD=OTS and CU=Costa Rica = 11
# AD=OET and CU=Costa Rica = 2
# AD=La Selva Biolo* = 0
# AD=La Selva* = 170 But greatly reduced if you ad Costa Rica: AD=La Selva* and CU=Costa Rica
# AD=ORG TROP STUDIES = 209 BUT AD=ORG TROP STUDIES and CU=Costa Rica drops to 148. AD=ORG TROP STUDIES NOT CU=Costa Rica  Tells you why (N=61): ORG TROP STUDIES was using Miami, Raleigh, etc. as address
# 
# Turns out Enhanced Organization name for OTS is: ORG TROP STUDIES
# OE=ORG TROP STUDIES 170
# AD=Palo Verde AND CU=Costa Rica* = 14
# AD=La Selva AND CU=Costa Rica* = 62 (note above)
# 
# AD=Wilson* AND CU=Costa Rica* =13
# AD=Las Cruc* AND CU=Costa Rica* = 45 CAN'T DO – GET NMSU and Jornada (in Las Cruces)
# AD=Las Cruces Biol* AND CU=Costa Rica*=33
# 
# TOTAL of above without DUPES = 253



############################################
# PROCESSING THE DATA
############################################

# This will install the refsplitr package from GITHUB (it's not on CRAN yet)
library(devtools)
devtools::install_github("embruna/refsplitr", force=FALSE)

# load the required libraries
library(refsplitr)
library(tidyverse)


######################
# Load the data
######################

# StationPubs_refsEB<-references_read(data = './data/EB', dir = T)

LS_refs<-references_read(data = './data/LS', dir = T)
BCI_refs<-references_read(data = './data/BCI', dir = T)
# CR_refs<-references_read(data = './data/LS', dir = T)
# PA_refs<-references_read(data = './data/LS', dir = T)

# this will save a CSV version of the references (1 reference per line) - it's easier to scan this wat
write.csv(LS_refs,"./output/LS_refs.csv")
write.csv(BCI_refs,"./output/BCI_refs.csv")
# write.csv(CR_refs,"./output/CR_refs.csv")
# write.csv(PA_refs,"./output/PA_refs.csv")

######################

######################
# This will process the data & disambiaguate the author names
LS_clean<-authors_clean(LS_refs)
BCI_clean<-authors_clean(BCI_refs)
CR_clean<-authors_clean(CR_refs)
PA_clean<-authors_clean(PA_refs)

# this will save the "preliminary" disambiguation done by refsplitr as a csv file
write.csv(LS_clean$prelim,"./output/LS_prelim.csv")
write.csv(BCI_clean$prelim,"./output/BCI_prelim.csv")
# write.csv(CR_clean$prelim,"./output/CR_prelim.csv")
# write.csv(PA_clean$prelim,"./output/PA_prelim.csv")

# save the names refsplitr suggests you review as a csv file
write.csv(LS_clean$review,"./output/LS_review.csv")
write.csv(BCI_clean$review,"./output/BCI_review.csv")
# write.csv(CR_clean$review,"./output/CR_review.csv")
# write.csv(PA_clean$review,"./output/PA_review.csv")
# Unless the data you are reading in have changed, you don't have to load the 
# data from the raw text files every time....
# Just skip straight to this and load the csv!
LS_prelim<-read.csv("./output/LS_prelim.csv")
BCI_prelim<-read.csv("./output/BCI_prelim.csv")
# CR_prelim<-read.csv("./output/CR_prelim.csv")
# PA_prelim<-read.csv("./output/PA_prelim.csv")

# You can also load the "review" file as a dataframe
LS_review<-read.csv("./output/LS_review.csv")
BCI_review<-read.csv("./output/BCI_review.csv")
# CR_review<-read.csv("./output/CR_review.csv")
# PA_review<-read.csv("./output/PA_review.csv")
######################

######################
# TO ACCEPT THE disambiguation WITHOUT MERGING ANY CORRECTIONS 
LS_refined <- authors_refine(LS_clean$review, 
                                       LS_clean$prelim)

BCI_refined <- authors_refine(BCI_clean$review, 
                             BCI_clean$prelim)

# 
# CR_refined <- authors_refine(CR_clean$review, 
#                              CR_clean$prelim)
# 
# PA_refined <- authors_refine(PA_clean$review, 
#                              PA_clean$prelim)


# # OR 
# StationPubs_refined <- authors_refine(StationPubs_review, 
#                                       StationPubs_prelim)

# IF YOU MADE CORRECTIONS TO THE "REVIEW" FILE, 
# MAKE THE CORRECTIONS AND SAVE THE FILE AS "StationPubs_review_corrections.csv" 
# LOAD THE CORRRECTIONS
# StationPubs_review_corrections<-read.csv("./output/StationPubs_review_corrections.csv")
# # THEN MERGE THE CORRECTIONS
# StationPubs_refined <- authors_refine(StationPubs_review_corrections, 
#                                       StationPubs_prelim)


######################
# save the disambiguated data set
write.csv(LS_refined,"./output/LS_refined.csv")
write.csv(BCI_refined,"./output/BCI_refined.csv")
# write.csv(CR_refined,"./output/CR_refined.csv")
# write.csv(PA_refined,"./output/PA_refined.csv")
######################


######################
# Georeference the author locations
LS_georef <-authors_georef(data=LS_refined,address_column = "address")



BCI_georef <-authors_georef(data=BCI_refined, 
                                    address_column = "address")

######################



######################
# Visualizations

# Plot No. pf authors x country
LS_plot_addresses_country <- plot_addresses_country(LS_georef$addresses)

BCI_plot_addresses_country <- plot_addresses_country(BCI_georef$addresses)


# Plot author location
LS_plot_addresses_points <- plot_addresses_points(LS_georef$addresses)
LS_plot_addresses_points

BCI_plot_addresses_points <- plot_addresses_points(BCI_georef$addresses)
BCI_plot_addresses_points

# # Plot social network x country
LS_plot_net_coauthor <- plot_net_coauthor(LS_georef$addresses)
BCI_plot_net_coauthor <- plot_net_coauthor(BCI_georef$addresses)

# Plot coauthorships x country
LS_plot_net_country <- plot_net_country(LS_georef$addresses)
LS_plot_net_country$plot

BCI_georef$addresses$country<-gsub("papua n guinea","papua new guinea",BCI_georef$addresses$country)
BCI_georef$addresses$country<-as.factor(BCI_georef$addresses$country)
BCI_georef$addresses$country[BCI_georef$addresses$country=="cz"]<-"panama"
# BCI_georef$addresses$country[BCI_georef$addresses$country=="papua n guinea"]<-"papua new guinea"
BCI_georef$addresses$country<-as.character(BCI_georef$addresses$country)

BCI_plot_net_country <- plot_net_country(BCI_georef$addresses)
BCI_plot_net_country$plot


# Plot coauthorships x locality
LS_plot_net_address <- plot_net_address(LS_georef$addresses)
LS_plot_net_address$plot


BCI_plot_net_address <- plot_net_address(BCI_georef$addresses)
BCI_plot_net_address$plot
######################



