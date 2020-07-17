# Prepare data for example for MMIcalc.R;
#
# Scoring Thresholds
# MI EGLE 2020 - taken from Jessup et al. 2020
#
#
# ben.block@tetratech.com
# Created: 20200717
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Prep ####
# library(devtools)
wd <- getwd()
# assume wd is package root

# 1. Get data and Process #####
# 1.1. Import Data
myFile <- "metrics.scoring.tab"
data.import <- read.delim(file.path(".","data-raw",myFile))
# 1.2. Process Data
View(data.import)
names(data.import)
dim(data.import)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. Save as RDA for Use in Package ####
#
metrics_scoring <- data.import
devtools::use_data(metrics_scoring, overwrite = TRUE)


