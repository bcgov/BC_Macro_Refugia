# Copyright 2021 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

source('header.R')
source('packages.R')

#Load general layers
source("01_load.R")

#Load BEC current and projected
source("01_load_BEC.R")

#Load Velocity from U of A
source("01_load_Velocity.R")

#Clips input too AOI - current options include:
#AOI <- ws %>%
#  filter(SUB_SUB_DRAINAGE_AREA_NAME == "Bulkley")
AOI <- BC
#AOI <- ESI
AOI <- EcoRegions %>%
 filter(ECOREGION_NAME == "EASTERN HAZELTON MOUNTAINS")
#NASS RANGES, COASTAL GAP

#resolution of analysis -
#pixSize<-10 #in hectares - changes resolution of grids but will maintain OmniRadius

source("02_clean.R")

source("03_analysis.R")

source("04_output.R")


