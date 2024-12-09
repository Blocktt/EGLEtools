#### R script used to prepare GIS data for use in the package
# Developed by Ben Block, Tetra Tech; Ben.Block@tetratech.com
# Date created: 12/03/2024
# Date updated: 12/06/2024
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# R version 4.4.2 (2024-10-31) -- "Pile of Leaves"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Save GIS shapefiles as RDA
# saves space and should load quicker
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Prep ####
(wd <- getwd()) # assume is package directory
library(sf)
library(dplyr)
library(rmapshaper)
# Get data and process ####
fn_shp <- file.path(wd, "data-raw", "GIS_Data")

## Level 3 Ecoregions ####
L3_Eco_shp <- sf::st_read(dsn = fn_shp, layer = "L3_Eco_MI_20241203") %>%
  sf::st_transform('+proj=longlat +datum=WGS84') %>%
  dplyr::select(US_L3CODE, US_L3NAME)

object.size(L3_Eco_shp)

## P51 regions ####
P51_Classes_shp <- sf::st_read(dsn = fn_shp
                               , layer = "WRD_P51_Site_Classifications") %>%
  sf::st_transform('+proj=longlat +datum=WGS84') %>%
  rename(PctSlope = SlopePerc
         , PctWetlands = WetlandPer
         , SiteClass_tmp = SiteClassi)

P51_Classes_shp <- sf::st_make_valid(P51_Classes_shp) # fixes duplicate vertices error

# Save as RDA for use in package ####
GIS_layer_L3Eco <- L3_Eco_shp
usethis::use_data(GIS_layer_L3Eco, overwrite = TRUE)

GIS_layer_P51 <- P51_Classes_shp
usethis::use_data(GIS_layer_P51, overwrite = TRUE)

