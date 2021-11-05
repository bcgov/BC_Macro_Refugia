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

#Updated BEC
BEC_file<-'tmp/BEC2021'
if (!file.exists(BEC_file)) {
#BECin<-bcdc_get_data("WHSE_FOREST_VEGETATION.BEC_BIOGEOCLIMATIC_POLY")
BECin<-readRDS(file='tmp/BEC')
BEC<- BECin %>%
  mutate(NDTn=as.integer(substr(NATURAL_DISTURBANCE,4,4))) %>%
  mutate(BGC=gsub(" ", "", MAP_LABEL, fixed = TRUE))
saveRDS(BEC,file='tmp/BEC')
BEC<-readRDS(file='tmp/BEC')

BEC_ng<-BEC %>%
  st_drop_geometry() %>%
  group_by(BGC) %>%
  dplyr::summarise(id=first(BGC),ZONE=first(ZONE),SUBZONE=first(SUBZONE),
  VARIANT=first(VARIANT),PHASE=first(PHASE),NATURAL_DISTURBANCE=first(NATURAL_DISTURBANCE))

BEC2021_LUT <- BEC_ng %>%
  mutate(BEC_id=as.numeric(rownames(BEC_ng))) %>%
  dplyr::select(BGC,BEC_id,ZONE,SUBZONE,VARIANT, PHASE,NATURAL_DISTURBANCE)

#set index for adding new BEC units
maxBEC_id<-max(BEC2021_LUT$BEC_id)

#2050 BEC
BEC2050_gdb <- file.path(SpatialDir,'BECprojections2021', 'EC-Earth_rcp245_2050s.gpkg')
BEC_list <- st_layers(BEC2050_gdb)
BEC2050 <- read_sf(BEC2050_gdb, layer = "EC-Earth_rcp245_2050s") %>%
  dplyr::filter(!is.na(BGC))
saveRDS(BEC2050,file='tmp/BEC2050')
BEC2050<-readRDS('tmp/BEC2050')

BEC2050_ng<- BEC2050 %>%
  st_drop_geometry() %>%
  mutate(BGC=gsub(" ", "", BGC, fixed = TRUE)) %>%
  full_join(BEC2021_LUT, by='BGC') %>%
  dplyr::filter(is.na(BEC_id))

#pull apart the novel labels and assign them to the subzone and variant attributes
BEC2050_LUT<- BEC2050_ng %>%
  mutate(BEC_id=maxBEC_id+as.numeric(rownames(BEC2050_ng))) %>%
  mutate(ZONE=str_extract(BGC, "[A-Z]+")) %>%
  mutate(SUBZONE=str_extract(BGC, "[a-z]+")) %>%
  mutate(VARIANT=str_extract(BGC, "(?<=_).*"))

BEC_LUT<-rbind(BEC2021_LUT,BEC2050_LUT) %>%
  mutate(SubZone=paste0(ZONE,SUBZONE))

BEC_LUTZ<-BEC_LUT %>%
  group_by(ZONE) %>%
  dplyr::summarise(NumBECz=n()) %>%
  mutate(ZoneN=row_number())

BEC_LUTSZ<-BEC_LUT %>%
  group_by(SubZone) %>%
  dplyr::summarise(NumBECsz=n()) %>%
  mutate(SubZoneN=row_number())

BEC_LUTbgc<-BEC_LUT %>%
  group_by(BGC) %>%
  dplyr::summarise(NumBECbgc=n()) %>%
  mutate(bgcN=row_number())

BEC_LUT<- BEC_LUT %>%
  left_join(BEC_LUTZ) %>%
  left_join(BEC_LUTSZ) %>%
  left_join(BEC_LUTbgc)
saveRDS(BEC_LUT,'tmp/BEC_LUT')

BEC2050 <- BEC2050 %>%
  dplyr::select(BGC) %>%
  #st_drop_geometry()
  left_join(BEC_LUT)
saveRDS(BEC2050,'tmp/BEC2050')
#failed??? write_sf(BEC2050, file.path(spatialOutDir,"BEC2050.gpkg"))

BEC2050r<-BEC2050 %>%
  st_cast("MULTIPOLYGON") %>%
  fasterize(ProvRast,field='BEC_id')
writeRaster(BEC2050r, filename=file.path(spatialOutDir,'BEC2050r'), format="GTiff", overwrite=TRUE)

BEC2021 <- BEC %>%
  dplyr::select(BGC) %>%
  left_join(BEC_LUT)
saveRDS(BEC2021,'tmp/BEC2021')
write_sf(BEC2021, file.path(spatialOutDir,"BEC2021.gpkg"))

BEC2021r<-BEC2021 %>%
  st_cast("MULTIPOLYGON") %>%
  fasterize(ProvRast,field='BEC_id')
writeRaster(BEC2021r, filename=file.path(spatialOutDir,'BEC2021r'), format="GTiff", overwrite=TRUE)

} else {
  BEC2021<-readRDS('tmp/BEC2021')
  BEC2021r<-raster(file.path(spatialOutDir,'BEC2021r.tif'))
  BEC2050<-readRDS('tmp/BEC2050')
  BEC2050r<-raster(file.path(spatialOutDir,'BEC2050r.tif'))
  BEC_LUT<-readRDS('tmp/BEC_LUT')
}

