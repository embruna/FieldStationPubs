############################################
# Code to import, organize, and analyze data from STRI and La Selva.
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
# AD=ORG TROP STUDIES = 209 BUT AD=ORG TROP STUDIES and CU=Costa Rica drops to 148. AD=ORG TROP STUDIES NOT CU=Costa Rica  TelPANAMA you why (N=61): ORG TROP STUDIES was using Miami, Raleigh, etc. as address
# 
# Turns out Enhanced Organization name for OTS is: ORG TROP STUDIES
# OE=ORG TROP STUDIES 170
# AD=Palo Verde AND CU=Costa Rica* = 14
# AD=La Selva AND CU=Costa Rica* = 62 (note above)
# 
# AD=WiPANAMAon* AND CU=Costa Rica* =13
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

sessionInfo()

######################
# Load the data
######################

# StationPubs_refsEB<-references_read(data = './data/EB', dir = T)

PANAMA_refs<-references_read(data = './data/PANAMA', dir = T)
STRI_refs<-references_read(data = './data/STRI', dir = T)
BOTH_refs<-references_read(data = './data/STRIPAN', dir = T)
# this will save a CSV version of the references (1 reference per line) - it's easier to scan this wat
write.csv(PANAMA_refs,"./output/PANAMA_refs.csv")
write.csv(STRI_refs,"./output/STRI_refs.csv")
# write.csv(CR_refs,"./output/CR_refs.csv")
# write.csv(PA_refs,"./output/PA_refs.csv")

######################

######################
# This will process the data & disambiaguate the author names
PANAMA_clean<-authors_clean(PANAMA_refs)
STRI_clean<-authors_clean(STRI_refs)
BOTH_clean<-authors_clean(BOTH_refs)
# CR_clean<-authors_clean(CR_refs)
# PA_clean<-authors_clean(PA_refs)

# this will save the "preliminary" disambiguation done by refsplitr as a csv file
write.csv(PANAMA_clean$prelim,"./output/PANAMA_prelim.csv")
write.csv(STRI_clean$prelim,"./output/STRI_prelim.csv")
# write.csv(CR_clean$prelim,"./output/CR_prelim.csv")
# write.csv(PA_clean$prelim,"./output/PA_prelim.csv")

# save the names refsplitr suggests you review as a csv file
write.csv(PANAMA_clean$review,"./output/PANAMA_review.csv")
write.csv(STRI_clean$review,"./output/STRI_review.csv")
# write.csv(CR_clean$review,"./output/CR_review.csv")
# write.csv(PA_clean$review,"./output/PA_review.csv")
# Unless the data you are reading in have changed, you don't have to load the 
# data from the raw text files every time....
# Just skip straight to this and load the csv!
PANAMA_prelim<-read.csv("./output/PANAMA_prelim.csv")
STRI_prelim<-read.csv("./output/STRI_prelim.csv")
# CR_prelim<-read.csv("./output/CR_prelim.csv")
# PA_prelim<-read.csv("./output/PA_prelim.csv")

# You can also load the "review" file as a dataframe
PANAMA_review<-read.csv("./output/PANAMA_review.csv")
STRI_review<-read.csv("./output/STRI_review.csv")
# CR_review<-read.csv("./output/CR_review.csv")
# PA_review<-read.csv("./output/PA_review.csv")
######################

######################
# TO ACCEPT THE disambiguation WITHOUT MERGING ANY CORRECTIONS 
PANAMA_refined <- authors_refine(PANAMA_clean$review, 
                                       PANAMA_clean$prelim)

STRI_refined <- authors_refine(STRI_clean$review, 
                             STRI_clean$prelim)

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
write.csv(PANAMA_refined,"./output/PANAMA_refined.csv")
write.csv(STRI_refined,"./output/STRI_refined.csv")
# write.csv(CR_refined,"./output/CR_refined.csv")
# write.csv(PA_refined,"./output/PA_refined.csv")
######################

STRI_refined<-read_csv("./output/STRI_refined.csv")
PANAMA_refined<-read_csv("./output/PANAMA_refined.csv")
PANAMA_refined<-PANAMA_refined %>% select(-X1,-X21,-X22)
STRI_refined_pan1<-STRI_refined %>%  filter (country=="panama" & author_order==1) %>% select(refID)
STRI_refined_pan1<-STRI_refined_pan1 %>% left_join(STRI_refined,STRI_refined_pan1,by="refID") %>% arrange(refID, author_order) %>% select(-X1)

######################
# Georeference the author locations
PANAMA_georef <-authors_georef(data=PANAMA_refined,address_column = "address")
save(PANAMA_georef, file = "./output/PANAMA_georef.RData")
load("./output/PANAMA_georef.RData")

STRI_georef <-authors_georef(data=STRI_refined,address_column = "address")
save(STRI_georef, file = "./output/STRI_georef.RData")
######################
STRI_refined_pan1<-authors_georef(data=STRI_refined_pan1,address_column = "address")


######################
# Visualizations

# Plot No. pf authors x country
PANAMA_plot_addresses_country <- plot_addresses_country(PANAMA_georef$addresses)

STRI_plot_addresses_country <- plot_addresses_country(STRI_georef$addresses)

STRI_refined_plot_addresses_country <- plot_addresses_country(STRI_refined_pan1$addresses)

# Plot author location
PANAMA_plot_addresses_points <- plot_addresses_points(PANAMA_georef$addresses)
PANAMA_plot_addresses_points

STRI_plot_addresses_points <- plot_addresses_points(STRI_georef$addresses)
STRI_plot_addresses_points

STRI_refined__plot_addresses_points <- plot_addresses_points(STRI_refined_pan1$addresses)
STRI_refined__plot_addresses_points

# # Plot social network x country
PANAMA_plot_net_coauthor <- plot_net_coauthor(PANAMA_georef$addresses)

STRI_plot_net_coauthor <- plot_net_coauthor(STRI_georef$addresses)

# Plot coauthorships x country
PANAMA_plot_net_country <- plot_net_country(PANAMA_georef$addresses)
PANAMA_plot_net_country$plot

STRI_georef$addresses$country<-gsub("papua n guinea","papua new guinea",STRI_georef$addresses$country)
STRI_georef$addresses$country<-as.factor(STRI_georef$addresses$country)
STRI_georef$addresses$country[STRI_georef$addresses$country=="cz"]<-"panama"
# STRI_georef$addresses$country[STRI_georef$addresses$country=="papua n guinea"]<-"papua new guinea"
STRI_georef$addresses$country<-as.character(STRI_georef$addresses$country)

STRI_plot_net_country <- plot_net_country(STRI_georef$addresses)
STRI_plot_net_country$plot


# Plot coauthorships x locality
PANAMA_plot_net_address <- plot_net_address(PANAMA_georef$addresses)
PANAMA_plot_net_address$plot


STRI_plot_net_address <- plot_net_address(STRI_georef$addresses, lineAlpha = 0.2)
STRI_plot_net_address$plot
######################

mat_data<-STRI_refined %>% select(groupID,refID)

# Create an incidence Matrix
mat_data_inc<-PANAMA_refined %>% # select from which data set
  select(refID,groupID) %>%   # select the columns needed MUST BE IN THIS ORDER
  group_by(refID,groupID) %>% # group and summarize to add a 1
  summarize(Freq=n()) %>% 
  spread(refID,Freq) %>% # "spread" it into an incidence matrix 
  replace(is.na(.), 0) %>% #replace all of the NA with "0"
  select(-groupID) # delete the 1st colummn

# convert the dataframe to a matrix
mat_data_inc<-as.matrix(mat_data_inc)

# Calclulate the crossproduct of the incidence matrix 
# to get the co-occurrence matrix
mat_data_co <- crossprod(mat_data_inc)
# Set the main diagonal to zero
diag(mat_data_co) <- 0

mat_data_co


library(slam)
object.size(mat_data_co)
object.size(mat_data_co<-simple_triplet_zero_matrix(mat_data_co))



foo<-as.data.frame(table(mat_data_inc[1:2]))
# can see what it looks like
head(mat_data_inc,10) 
# Create an 
mat_data_co <- crossprod(table(mat_data_inc[1:2]))
diag(mat_data_co) <- 0

dim(mat_data_co)

authors_P<-PANAMA_refined %>% distinct(groupID)



mat_data<-data.matrix(mat_data)



# mat_data_inc<-mat_data_inc %>% spread(groupID,Freq) %>% select(-refID)


library(igraph)
# change it to a Boolean matrix
mat_data[mat_data>=1] <- 1
# transform into a term-term adjacency matrix
termMatrix <- mat_data %*% t(mat_data)
# inspect terms numbered 5 to 10
termMatrix[5:10,5:10]


%>% replace_na(0)




head(mat_data,10)
# mat_data$groupID2<-mat_data$groupID
# head(mat_data,10)
mat_data<-mat_data %>% select(refID,groupID,Freq) %>% arrange(refID,groupID,Freq) %>% spread(groupID,Freq)



library(cooccur)
cooccur.finches <- cooccur(mat = mat_data, type = "spp_site",thresh = TRUE, spp_names = TRUE)
mat_data<-mat_data %>% select(refID,groupID,Freq) %>% group_by(refID,groupID) %>% spread(key = groupID, value=Freq)
mytable <- table(refID,groupID)




foo2<-foo2 %>% select(groupID,groupID2,Freq) %>% group_by(groupID,groupID2) %>% summarize(sum(Freq)) %>% arrange(groupID,groupID2)

adj_mat <- mat_data %>%  
  group_by(groupID,refID) %>%
  summarise(weight = n()) %>% 
  ungroup()
adj_mat
