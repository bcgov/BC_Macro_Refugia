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

Prov_crs<-crs(bcmaps::bc_bound())
#Prov_crs<-"+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"

#Provincial Raster to place rasters in the same reference
BCr_file <- file.path(spatialOutDir,"BCr.tif")
if (!file.exists(BCr_file)) {
  ProvRast<-raster(nrows=15744, ncols=17216, xmn=159587.5, xmx=1881187.5,
                   ymn=173787.5, ymx=1748187.5,
                   crs=Prov_crs,
                   res = c(100,100), vals = 1)
  BC<-bcmaps::bc_bound_hres(class='sf')
  saveRDS(BC,file='tmp/BC')
  BCr <- fasterize(BC,ProvRast)
  writeRaster(BCr, filename=BCr_file, format="GTiff", overwrite=TRUE)
  BCr_S <-st_as_stars(BCr)
  write_stars(BCr_S,dsn=file.path(spatialOutDir,'BCr_S.tif'))
  writeRaster(ProvRast, filename=file.path(spatialOutDir,'ProvRast'), format="GTiff", overwrite=TRUE)
} else {
  BCr_S <- read_stars(file.path(spatialOutDir,'BCr_S.tif'))
  BCr <- raster(BCr_file)
  BC <-readRDS('tmp/BC')
  ProvRast<-raster(file.path(spatialOutDir,'ProvRast.tif'))
}

#Ecosections
EcoS_file <- file.path("tmp/EcoS")
ESin <- read_sf(file.path(SpatialDir,'Ecosections/Ecosections.shp')) %>%
  st_transform(3005)
EcoS <- st_cast(ESin, "MULTIPOLYGON")
saveRDS(EcoS, file = EcoS_file)

#EcoRegions
EcoRegions<-bcmaps::ecoregions()


