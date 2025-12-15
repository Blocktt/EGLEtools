# Shiny Global File

# Version ----
pkg_version <- "v1.1.1.9001"

# Packages----
library(BioMonTools)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus) # only using for footer
library(shinyjs)
library(shinyBS)
library(DT)
library(dplyr)
library(readxl)
library(httr)
library(reshape2)
library(knitr)
library(zip)
library(shinyalert)
library(readr)
library(rmarkdown)
library(tools)
library(openxlsx)
library(sf)
library(kableExtra)
library(tidyr)

# Metrics ----
MichMetrics <- c("nt_CruMol", "nt_EPT", "nt_ffg_pred", "nt_NonIns", "nt_POET"
                 , "nt_total", "pi_ffg_pred", "pi_ffg_scrap", "pi_ffg_shred"
                 , "pi_habit_climb", "pi_habit_swim", "pi_OligoHiru"
                 , "pi_tv_toler6", "pt_ffg_col", "pt_ffg_pred", "pt_ffg_scrap"
                 , "pt_habit_burrow", "pt_habit_sprawl", "pt_habit_swim"
                 , "pt_Insect", "pt_NonIns", "pt_POET", "pt_tv_ntol"
                 , "pt_tv_toler", "pt_tv_toler6")# END MichMetrics

# Source ----
# Helper Functions ----
source(file.path("scripts", "helper_functions.R"))

## tabs ----
# sourced in global.R
# ref in db_main_body.R
# menu in db_main_sb.R
db_main_sb                     <- source("external/db_main_sb.R"
                                         , local = TRUE)$value
db_main_body                   <- source("external/db_main_body.R"
                                        , local = TRUE)$value
tab_code_about                 <- source("external/tab_about.R"
                                         , local = TRUE)$value
tab_code_filebuilder_intro    <- source("external/tab_filebuilder_intro.R"
                                         , local = TRUE)$value
tab_code_filebuilder_outsideapp   <- source("external/tab_filebuilder_outsideapp.R"
                                         , local = TRUE)$value
tab_code_filebuilder_taxatrans <- source("external/tab_filebuilder_taxatrans.R"
                                         , local = TRUE)$value
tab_code_calc              <- source("external/tab_calc.R"
                                         , local = TRUE)$value
tab_code_resources             <- source("external/tab_resources.R"
                                         , local = TRUE)$value

# Console Message ----
message(paste0("Interactive: ", interactive()))

# File Size ----
# By default, the file size limit is 5MB.
mb_limit <- 200
options(shiny.maxRequestSize = mb_limit * 1024^2)

# Folders----
path_data <- file.path("data")
path_results <- file.path("results")

# ensure results folder exists
if (dir.exists(path_results) == FALSE) {
  dir.create(path_results)
} else {
  message(paste0("Directory already exists; ", path_data))
}## IF ~ dir.exists

# File and Folder Names ----
abr_filebuilder <- "FileBuilder"
abr_agency      <- "EGLE"
abr_calc        <- "P51_Scores"
abr_results     <- "results"

dn_files_input  <- "_user_input"
dn_files_ref    <- "reference"
dn_files_qc     <- "quality_control"

# Taxa translator file ----
fn_pick_taxoff <- "EGLEtools_Pick_Files.csv"
df_pick_taxoff <- read.csv(file = file.path("data", fn_pick_taxoff))

# BMT, Metric Names ----
# references latest BioMonTools metric names file
url_bmt_pkg <- "https://github.com/leppott/BioMonTools/raw/main/inst/extdata"
url_metricnames <- file.path(url_bmt_pkg, "MetricNames.xlsx")
temp_metricnames <- tempfile(fileext = ".xlsx")
httr::GET(url_metricnames, httr::write_disk(temp_metricnames))

df_metricnames <- readxl::read_excel(temp_metricnames
                                     , sheet = "MetricMetadata"
                                     , skip = 4)

# BMT, Metric Scoring ----
# references latest BioMonTools metric scoring file
url_bmt_pkg <- "https://github.com/leppott/BioMonTools/raw/main/inst/extdata"
url_metricscoring <- file.path(url_bmt_pkg, "MetricScoring.xlsx")
temp_metricscoring <- tempfile(fileext = ".xlsx")
httr::GET(url_metricscoring, httr::write_disk(temp_metricscoring))

# Site Classification ----
# Geospatial data for site classification
# load(file.path(".","Data", "GIS_layer_L3Eco.rda"))
load(file.path(".","data", "GIS_layer_P51.rda"))

