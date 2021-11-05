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

# Add unique zone and subzone numbers











#Get levels assigned to the reference layer
#bgc.names.LUT<-data.frame(BGC=levels.bgc[,1]) %>%
#  mutate(id=row_number())

#BGC.pred.refX <- levels.bgc[,1][values(BGC.pred.ref)]

#################


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

parks2017<-readRDS(file= 'tmp/parks2017') %>%
  st_buffer(dist=0) %>%
  st_intersection(AOI)
saveRDS(parks2017, file = 'tmp/AOI/parks2017')

HillShade <-raster(file.path(GISLibrary,'GRIDS/hillshade_BC.tif')) %>%
  mask(AOI) %>%
  crop(AOI)

lakes<-readRDS(file= 'tmp/lakes') %>%
  st_buffer(dist=0) %>%
  st_intersection(AOI)
saveRDS(lakes, file = 'tmp/AOI/lakes')

rivers<-readRDS(file= 'tmp/rivers') %>%
  st_buffer(dist=0) %>%
  st_intersection(AOI)
saveRDS(rivers, file = 'tmp/AOI/rivers')



####Other load stuff
#if(!is.null(subzones)){
#  bec_sf <- dplyr::filter(bec_sf, as.character(MAP_LABEL) %in% subzones)
#  study_area <- st_intersection(study_area, bec_sf) %>% # The AOI is trimmed according to the bec_sf zones included
#    summarise()
#  st_write(study_area, file.path(res_folder, "AOI.gpkg"), delete_layer = TRUE)
#}
