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

#Get levels assigned to the reference layer
bgc.names.LUT<-data.frame(BGC=levels.bgc[,1]) %>%
  mutate(id=row_number())

#BGC.pred.refX <- levels.bgc[,1][values(BGC.pred.ref)]

mapview(BGC.pred.ref)

studyarea<-'Wetzinkwa'
#levels.bgc <- read.csv("data/levels.bgc.csv")[,1]
levels.bgc <- read.csv(file.path(WetzinkData,"levels.bgc.csv"))[,1]
#bgc.pred.ref <- raster(paste("data/BGC.pred", studyarea, "ref.tif", sep="."))
bgc.pred.ref <- raster(file.path(WetzinkData,paste("BGC.pred", studyarea, "ref.tif", sep=".")))
X <- bgc.pred.ref
BGC.pred <- levels.bgc[values(X)]

#Subset data for testing
ws <- readRDS(file = 'tmp/ws') %>%
  st_intersection(AOI)

bec_sf <- readRDS(file= 'tmp/bec_sf') %>%
  st_intersection(AOI)
saveRDS(bec_sf, file = 'tmp/bec_sf')

BEC1970<-readRDS(file= 'tmp/BEC1970PS') %>%
  mask(AOI) %>%
  crop(AOI)
saveRDS(BEC1970, file = 'tmp/BEC1970')
writeRaster(BEC1970, filename=file.path(spatialOutDir,paste("BEC1970",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)

BEC2080<-readRDS(file= 'tmp/BEC2080PS') %>%
  mask(AOI) %>%
  crop(AOI)
saveRDS(BEC2080, file = 'tmp/BEC2080')
writeRaster(BEC2080, filename=file.path(spatialOutDir,paste("BEC2080",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)

####Other load stuff
#if(!is.null(subzones)){
#  bec_sf <- dplyr::filter(bec_sf, as.character(MAP_LABEL) %in% subzones)
#  study_area <- st_intersection(study_area, bec_sf) %>% # The AOI is trimmed according to the bec_sf zones included
#    summarise()
#  st_write(study_area, file.path(res_folder, "AOI.gpkg"), delete_layer = TRUE)
#}
