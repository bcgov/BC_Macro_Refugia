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

#Read layers generated from 03_analysis
BEC2021z<-raster(file.path(spatialOutDir,("BEC2021z.tif")))
BEC2050z<-raster(file.path(spatialOutDir,("BEC2050z.tif")))

#BEC1970<-raster(file.path(spatialOutDir,paste("BEC1970.tif",sep="")))
#BEC2080<-raster(file.path(spatialOutDir,paste("BEC2080.tif",sep="")))

#BEC1970P_LUT <- read.dbf(file.path(RefugiaSpatialDir, "BEC_zone_1970/BEC_zone.tif.vat.dbf"),as.is=TRUE)

#mapview(BEC1970z,maxpixels =  4308570)+mapview(BEC2080z,maxpixels =  4308570)
#Identify where BEC zones are the identical between 2080 and 1970
BECOverz <- BEC2050z==BEC2021z
writeRaster(BECOverz, filename=file.path(spatialOutDir,paste("BECOverz",sep="")), format="GTiff",overwrite=TRUE)

BECmacroRZ <- BECOverz*BEC2021z
writeRaster(BECmacroRZ, filename=file.path(spatialOutDir,paste("BECmacroRZ",sep="")), format="GTiff",overwrite=TRUE)

#BECmacroRZ_S <-st_as_stars(BECmacroRZ)
#BECmacroRZ<-raster(file.path(spatialOutDir,"BECmacroRZ.tif"))

#Identify where BEC sub zones are the identical between 2021 and 2050
BECOversz <- BEC2050sz==BEC2021sz
cellStats(BECOversz,sum)
writeRaster(BECOversz, filename=file.path(spatialOutDir,paste("BECOversz",sep="")), format="GTiff",overwrite=TRUE)
BECmacroRSZ <- BECOversz*BEC2021z
writeRaster(BECmacroRSZ, filename=file.path(spatialOutDir,paste("BECmacroRSZ",sep="")), format="GTiff",overwrite=TRUE)

#Identify where BEC bgc are the identical between 2021 and 2050
BECOverbgc <- BEC2050bgc==BEC2021bgc
cellStats(BECOverbgc,sum)
writeRaster(BECOverbgc, filename=file.path(spatialOutDir,paste("BECOverbgc",sep="")), format="GTiff",overwrite=TRUE)
BECmacroRbgc <- BECOverbgc*BEC2021z
writeRaster(BECmacroRbgc, filename=file.path(spatialOutDir,paste("BECmacroRbgc",sep="")), format="GTiff",overwrite=TRUE)

