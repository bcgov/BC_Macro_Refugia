# Copyright 2020 Province of British Columbia
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

#Compare BEC from 2021 to 2050 - Full Label, Zone and Sub-Zone (Variant inconsistent label on 2050 BEC)

### Zone
#Compare Zone from 2021 to 2050
#Change rasters to be of Zone instead of default Variant
subsBEC<-BEC_LUT[!(is.na(BEC_LUT$BEC_id)),] %>%
  dplyr::select(BEC_id, ZoneN)
BEC2021z<- raster::subs(BEC2021r, subsBEC, by='BEC_id', which='ZoneN')
writeRaster(BEC2021z, filename=file.path(spatialOutDir,paste("BEC2021z",sep="")), format="GTiff",overwrite=TRUE)

BEC2021z<-raster(file.path(spatialOutDir,("BEC2021z.tif")))

BEC2050z<- raster::subs(BEC2050r, subsBEC, by='BEC_id', which='ZoneN')
writeRaster(BEC2050z, filename=file.path(spatialOutDir,paste("BEC2050z",sep="")), format="GTiff",overwrite=TRUE)
#BEC2050z2<- raster::subs(BEC2050r, subsBEC, by='BEC_id', which='ZoneN',subsWithNA=TRUE)
#writeRaster(BEC2050z2, filename=file.path(spatialOutDir,paste("BEC2050z2",sep="")), format="GTiff",overwrite=TRUE)

BEC2050z<-raster(file.path(spatialOutDir,("BEC2050z.tif")))

#Crosstab to see extent of overlap
#create LUT for each year
BEC2021z_LUT<-BEC2021z %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(ZoneN = '.') %>%
  left_join(BEC_LUT) %>%
  group_by(ZoneN.1=ZoneN) %>%
  dplyr::summarise(ZONE=first(ZONE)) %>%
  rbind(data.frame(ZoneN.1=NA, ZONE=NA))

BEC2050z_LUT<-BEC2050z %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(ZoneN ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(ZoneN.2=ZoneN) %>%
  dplyr::summarise(ZONE=first(ZONE)) %>%
  rbind(data.frame(ZoneN.2=NA, ZONE=NA))

#need to add NA case since many non-analogue between years
BEC2021_2050z1<-raster::crosstab(BEC2021z, BEC2050z, long=TRUE, useNA=FALSE)
#BEC2021_2050z1wNA-raster::crosstab(BEC2021z, BEC2050z, long=TRUE, useNA=TRUE)

  BEC2021_2050z <- BEC2021_2050z1 %>%
  dplyr::rename(ZoneN.1=BEC2021z) %>%
  left_join(BEC2021z_LUT) %>%
  dplyr::rename(BEC2021=ZONE) %>%
  dplyr::rename(ZoneN.2=BEC2050z) %>%
  left_join(BEC2050z_LUT) %>%
  dplyr::rename(BEC2050=ZONE) %>%
  dplyr::select(BEC2021, BEC2021n=ZoneN.1, BEC2050, BEC2050n=ZoneN.2, Freq)

#Find which and the number of overlaps between years
macroRefugiaZ <- BEC2021_2050z %>%
  dplyr::filter_(~as.character(BEC2021) == as.character(BEC2050))
#Calculate % of overlap between 2021 and 2050
sum(macroRefugiaZ$Freq)/sum(BEC2021_2050z$Freq[!is.na(BEC2021_2050z$BEC2021n)])*100
WriteXLS(macroRefugiaZ,file.path(dataOutDir,'macroRefugiaZ.xlsx'))


### Sub-Zone
#Compare sub Zone from 2021 to 2050
#Change rasters to be of Zone instead of default Variant
subsBEC<-BEC_LUT[!(is.na(BEC_LUT$BEC_id)),] %>%
  dplyr::select(BEC_id, SubZoneN)
BEC2021sz<- raster::subs(BEC2021r, subsBEC, by='BEC_id', which='SubZoneN')
writeRaster(BEC2021sz, filename=file.path(spatialOutDir,paste("BEC2021z",sep="")), format="GTiff",overwrite=TRUE)
#BEC2021sz<-raster(file.path(spatialOutDir,("BEC2021sz.tif")))

BEC2050sz<- raster::subs(BEC2050r, subsBEC, by='BEC_id', which='SubZoneN')
writeRaster(BEC2050sz, filename=file.path(spatialOutDir,paste("BEC2050sz",sep="")), format="GTiff",overwrite=TRUE)
#BEC2050z2<- raster::subs(BEC2050r, subsBEC, by='BEC_id', which='ZoneN',subsWithNA=TRUE)
#writeRaster(BEC2050z2, filename=file.path(spatialOutDir,paste("BEC2050z2",sep="")), format="GTiff",overwrite=TRUE)
#BEC2050z<-raster(file.path(spatialOutDir,("BEC2050z.tif")))

#Crosstab to see extent of overlap
#create LUT for each year
BEC2021sz_LUT<-BEC2021sz %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(SubZoneN = '.') %>%
  left_join(BEC_LUT) %>%
  group_by(SubZoneN.1=SubZoneN) %>%
  dplyr::summarise(SubZone=first(SubZone)) %>%
  rbind(data.frame(SubZoneN.1=NA, SubZone=NA))

BEC2050sz_LUT<-BEC2050sz %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(SubZoneN ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(SubZoneN.2=SubZoneN) %>%
  dplyr::summarise(SubZone=first(SubZone)) %>%
  rbind(data.frame(SubZoneN.2=NA, SubZone=NA))

#need to add NA case since many non-analogue between years
BEC2021_2050sz1<-raster::crosstab(BEC2021sz, BEC2050sz, long=TRUE, useNA=FALSE)
#BEC2021_2050z1wNA-raster::crosstab(BEC2021z, BEC2050z, long=TRUE, useNA=TRUE)

BEC2021_2050sz <- BEC2021_2050sz1 %>%
  dplyr::rename(BEC2050sz=SubZoneN) %>%
  dplyr::rename(SubZoneN.1=BEC2021sz) %>%
  left_join(BEC2021sz_LUT) %>%
  dplyr::rename(BEC2021=SubZone) %>%
  dplyr::rename(SubZoneN.2=BEC2050sz) %>%
  left_join(BEC2050sz_LUT) %>%
  dplyr::rename(BEC2050=SubZone) %>%
  dplyr::select(BEC2021, BEC2021n=SubZoneN.1, BEC2050, BEC2050n=SubZoneN.2, Freq)

#Find which and the number of overlaps between years
macroRefugiaSZ <- BEC2021_2050sz %>%
  dplyr::filter_(~as.character(BEC2021) == as.character(BEC2050))
#Calculate % of overlap between 2021 and 2050
sum(macroRefugiaSZ$Freq)/sum(BEC2021_2050sz$Freq[!is.na(BEC2021_2050sz$BEC2021n)])*100
WriteXLS(macroRefugiaSZ,file.path(dataOutDir,'macroRefugiaSZ.xlsx'))

### BGC
#Compare BGC from 2021 to 2050
#subsBEC<-BEC_LUT[!(is.na(BEC_LUT$BEC_id)),] %>%
#  dplyr::select(BEC_id, BEC_id)
BEC2021bgc<- BEC2021r
#writeRaster(BEC2021bgc, filename=file.path(spatialOutDir,paste("BEC2021bgc",sep="")), format="GTiff",overwrite=TRUE)

BEC2050bgc<- BEC2050r
#writeRaster(BEC2050bgc, filename=file.path(spatialOutDir,paste("BEC2050bgc",sep="")), format="GTiff",overwrite=TRUE)

#Crosstab to see extent of overlap
#create LUT for each year
BEC2021bgc_LUT<-BEC2021r %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(bgcN ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(BEC_id) %>%
  dplyr::summarise(BGC=first(BGC)) %>%
  dplyr::rename(bgcN.1=BEC_id) %>%
  rbind(data.frame(bgcN.1=NA, BGC=NA))

BEC2050bgc_LUT<-BEC2050r %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(bgcN ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(BEC_id) %>%
  dplyr::summarise(BGC=first(BGC)) %>%
  dplyr::rename(bgcN.2=BEC_id) %>%
  rbind(data.frame(bgcN.2=NA, BGC=NA))

#need to add NA case since many non-analogue between years
BEC2021_2050bgc1<-raster::crosstab(BEC2021bgc, BEC2050bgc, long=TRUE, useNA=FALSE)

BEC2021_2050bgc <- BEC2021_2050bgc1 %>%
  dplyr::rename(bgcN.1=BEC2021r) %>%
  dplyr::rename(bgcN.2=BEC2050r) %>%
  left_join(BEC2021bgc_LUT) %>%
  dplyr::rename(BEC2021=BGC) %>%
  left_join(BEC2050bgc_LUT) %>%
  dplyr::rename(BEC2050=BGC) %>%
  dplyr::select(BEC2021n=bgcN.1, BEC2021, BEC2050n=bgcN.2, BEC2050, Freq)

#Find which and the number of overlaps between years
macroRefugiabgc <- BEC2021_2050bgc %>%
  dplyr::filter_(~as.character(BEC2021) == as.character(BEC2050))
#Calculate % of overlap between 2021 and 2050
sum(macroRefugiabgc$Freq)/sum(BEC2021_2050bgc$Freq[!is.na(BEC2021_2050bgc$BEC2021n)])*100

WriteXLS(macroRefugiabgc,file.path(dataOutDir,'macroRefugiabgc.xlsx'))

#Output data as a multi-tabbed spreadsheet
XtabSummary<- data.frame(c('Zone','SubZone','Variant'),
                         c(sum(macroRefugiaZ$Freq)/sum(BEC2021_2050z$Freq)*100,
                           sum(macroRefugiaSZ$Freq)/sum(BEC2021_2050sz$Freq)*100,
                           sum(macroRefugiabgc$Freq)/sum(BEC2021_2050bgc$Freq)*100))
colnames(XtabSummary)<-c('BECscale','pcOverlap')

#Write out results into a multi-tab spreadsheet
BECxData<-list(XtabSummary, BEC2021_2050bgc,macroRefugiabgc, BEC2021_2050sz,macroRefugiaSZ, BEC2021_2050z,macroRefugiaZ)
BECDataNames<-c('XtabSummary','VariantXtab','VariantOverlap','SubZoneXtab','SubZoneOverlap','ZoneXtab','ZoneOverlap')

WriteXLS(BECxData,file.path(dataOutDir,paste('BECxData.xlsx',sep='')),SheetNames=BECDataNames)



