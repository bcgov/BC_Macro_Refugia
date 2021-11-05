
OutDir <- 'out'
dataOutDir <- file.path(OutDir,'data')
StrataOutDir <- file.path(dataOutDir,'Strata')
figsOutDir <- file.path(OutDir,'figures')
SpatialDir <- file.path('data','spatial')
DataDir <- file.path('data')
spatialOutDir <- file.path(OutDir,'spatial')
WetspatialDir <- file.path('/Users/darkbabine/Dropbox (BVRC)/Projects/ESI/Wetlands/Assessment/Data')
WetzinkData <- file.path('/Users/darkbabine/Dropbox (BVRC)/Projects/LUP/Wetzinkwa/Data/ColinCCWebAppData')
GISLibrary<- file.path('/Users/darkbabine/ProjectLibrary/Library/GISFiles/BC')
NALibrary<- file.path('/Users/darkbabine/Dropbox (BVRC)/_dev/Biodiversity/data')

RefugiaSpatialDir <- file.path('/Users/darkbabine/Dropbox (BVRC)/Projects/ClimateChange/BiodiversityCC/ClimateRefugia')
ESIDir <- file.path('/Users/darkbabine/Dropbox (BVRC)/Projects/ESI')
RoadDir <- file.path('/Users/darkbabine/Dropbox (BVRC)/_dev/Biodiversity/bc-raster-roads/data')

dir.create(file.path(OutDir), showWarnings = FALSE)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
dir.create(file.path(StrataOutDir), showWarnings = FALSE)
dir.create(file.path(spatialOutDir), showWarnings = FALSE)
dir.create(file.path(figsOutDir), showWarnings = FALSE)
dir.create(DataDir, showWarnings = FALSE)
dir.create("tmp", showWarnings = FALSE)
dir.create("tmp/AOI", showWarnings = FALSE)


