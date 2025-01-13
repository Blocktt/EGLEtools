library(shiny)

shinyServer(function(input, output, session) {
  # Modal ####
  showModal(modalDialog(
    title = h3("Michigan EGLE P51 Score Calculator (EGLEtools)")
    , h4("Welcome to the EGLEtools R Shiny app!")
    , br()
    , br()
    , HTML('<center><img src="EGLE_Logo_Primary_Green.png" height="100"></center>')
    , br()
    , paste("This app is used to calculate macroinvertebrate IBI scores using"
            , "EGLE Water Resources Division, Great Lakes Watersheds Assessment,"
            , "Restoration, and Management Section Procedure 51- Qualitative"
            , "Biological and Habitat Survey Protocols for Wadeable Streams and"
            , "Rivers (P51). Please refer to the 'About' tab for details and"
            , "the 'Resources' tab for additional documentation. This app was"
            , "funded by EGLE and developed by Tetra Tech.")
    , easyClose = TRUE
    , footer = NULL
    , size = "m"
  ))

  # ~~~~IMPORT~~~~----
  # IMPORT ----
  file_watch_calc <- reactive({
    input$fn_input_calc
  })## file_watch

  file_watch_taxatrans <- reactive({
    input$fn_input_taxatrans
  })## file_watch

  ## IMPORT, df_import, calc ####
  df_import_calc <- eventReactive(file_watch_calc(), {

    inFile <- input$fn_input_calc

    if (is.null(inFile)) {
      return(NULL)
    }##IF~is.null~END

    sep_user <- input$sep_calc

    # Define file
    fn_inFile <- inFile$datapath

    #message(getwd())
    message(paste0("Import, separator: '", input$sep_calc,"'"))
    message(paste0("Import, file name: ", input$fn_input_calc$name))

    # Remove existing files in "results"
    clean_results()

    # Read input file
    df_input <- read.delim(fn_inFile
                           , header = TRUE
                           , sep = sep_user
                           , stringsAsFactors = FALSE
                           , na.strings = c("", "NA")
                           , check.names = FALSE)


    # Copy user files to results sub-folder
    copy_import_file(import_file = input$fn_input_calc)

    ## button, enable, calc ----
    shinyjs::enable("b_calc_ibi")

    return(df_input)

  })##output$df_import ~ END

  ## IMPORT, df_import, taxatrans ####

  df_import_taxatrans <- eventReactive(file_watch_taxatrans(), {

    inFile <- input$fn_input_taxatrans

    if (is.null(inFile)) {
      return(NULL)
    }##IF~is.null~END

    sep_user <- input$sep_taxatrans

    # Define file
    fn_inFile <- inFile$datapath

    #message(getwd())
    message(paste0("Import, separator: '", input$sep_taxatrans,"'"))
    message(paste0("Import, file name: ", input$fn_input_taxatrans$name))

    # Remove existing files in "results"
    clean_results()

    # Read input file
    df_input <- read.delim(fn_inFile
                           , header = TRUE
                           , sep = sep_user
                           , stringsAsFactors = FALSE
                           , na.strings = c("", "NA")
                           , check.names = FALSE)


    # Copy user files to results sub-folder
    copy_import_file(import_file = input$fn_input_taxatrans)

    ## button, enable, calc ----
    shinyjs::enable("b_calc_taxatrans")

    return(df_input)

  })##output$df_import ~ END

  ## IMPORT, df_import_DT ----
  ### taxa trans ----
  output$df_import_DT_taxatrans <- DT::renderDT({
    df_data <- df_import_taxatrans()
    }##expression~END
    , filter = "top"
    , caption = "Table. Imported data."
    , options = list(scrollX = TRUE
                     , pageLength = 5
                     , lengthMenu = c(5, 10, 25, 50, 100, 1000)
                     , autoWidth = TRUE)
    )##df_import_DT~END

  ### calc ----
  output$df_import_DT_calc <- DT::renderDT({
    df_data <- df_import_calc()
  }##expression~END
  , filter = "top"
  , caption = "Table. Imported data."
  , options = list(scrollX = TRUE
                   , pageLength = 5
                   , lengthMenu = c(5, 10, 25, 50, 100, 1000)
                   , autoWidth = TRUE)
  )##df_import_DT~END

  ## IMPORT, col names ----
  ### taxa trans ----
  col_import <- eventReactive(file_watch_taxatrans(), {

    inFile <- input$fn_input_taxatrans

    if (is.null(inFile)) {
      return(NULL)
    }##IF~is.null~END

    # temp df
    df_temp <- df_import()
    # Column Names
    input_colnames <- names(df_temp)
    #
    return(input_colnames)

  })## col_import

  ### calc ----
  col_import <- eventReactive(file_watch_calc(), {

    inFile <- input$fn_input_calc

    if (is.null(inFile)) {
      return(NULL)
    }##IF~is.null~END

    # temp df
    df_temp <- df_import()
    # Column Names
    input_colnames <- names(df_temp)
    #
    return(input_colnames)

  })## col_import

  # ~~~~FILE BUILDER~~~~ ----
  # TaxaTrans/SiteClass, UI ----

  observe({
    req(df_import_taxatrans())
    updateSelectInput(session, "taxatrans_user_col_sampid"
                      , choices = c("", names(df_import_taxatrans())))

    updateSelectInput(session, "siteclass_user_col_siteid"
                      , choices = c("", names(df_import_taxatrans())))

    updateSelectInput(session, "siteclass_user_col_lat"
                      , choices = c("", names(df_import_taxatrans())))

    updateSelectInput(session, "siteclass_user_col_long"
                      , choices = c("", names(df_import_taxatrans())))

    updateSelectInput(session, "siteclass_user_col_width"
                      , choices = c("", names(df_import_taxatrans())))

    if (input$fn_input_format == "Wide") {
      updateSelectInput(session, "taxatrans_user_col_taxaid"
                        , choices = "TAXA_ID")
    } else {
      updateSelectInput(session, "taxatrans_user_col_taxaid"
                        , choices = c("", names(df_import_taxatrans())))
    }# IF/ELSE ~ END

    if (input$fn_input_format == "Wide") {
      updateSelectInput(session, "taxatrans_user_col_n_taxa"
                        , choices = "N_TAXA")
    } else {
      updateSelectInput(session, "taxatrans_user_col_n_taxa"
                        , choices = c("", names(df_import_taxatrans())))
    }# IF/ELSE ~ END

    updateSelectInput(session, "taxatrans_user_col_groupby"
                      , choices = c("", names(df_import_taxatrans())))

  })# END ~ observe

  # TaxaTrans/SiteClass, combine ----
  ## b_Calc_TaxaTrans
  observeEvent(input$b_calc_taxatrans, {
    shiny::withProgress({

      # time, start
      tic <- Sys.time()

      ### Calc, 00, Initialize ----
      prog_detail <- "Taxa Translator..."
      message(paste0("\n", prog_detail))

      # Number of increments
      prog_n <- 7
      prog_sleep <- 0.25

      ## Calc, 01, Import User Data ----
      prog_detail <- "Import Data, User"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Remove existing files in "results"
      clean_results()

      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input_taxatrans)

      # Add "reference" folder if missing
      path_results_ref <- file.path(path_results, dn_files_ref)
      boo_Results <- dir.exists(file.path(path_results_ref))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_ref))
      }
      # Add "Results" folder based on user selection later in this step

      # Add "QC" folder if missing
      path_results_qc <- file.path(path_results, dn_files_qc)
      boo_Results <- dir.exists(file.path(path_results_qc))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_qc))
      }

      # button, disable, download
      shinyjs::disable("b_download_taxatrans")

      # Import data
      # data
      inFile <- input$fn_input_taxatrans
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      FB_input_format <- input$fn_input_format
      message(paste0("Import, file name, base: ", fn_input_base))

      if(FB_input_format == "Wide") {
        # wide format temporary file
        df_input_wide <- read.delim(inFile$datapath
                                    , header = TRUE
                                    , sep = input$sep_taxatrans
                                    , stringsAsFactors = FALSE
                                    , check.names = FALSE)
      } else {
        # long format straight to df_input
        df_input <- read.delim(inFile$datapath
                               , header = TRUE
                               , sep = input$sep_taxatrans
                               , stringsAsFactors = FALSE
                               , check.names = FALSE)

      } # IF/ELSE ~ END

      # QC, FAIL if TRUE
      # if (is.null(df_input_wide)) {
      #   return(NULL)
      # }

      ## Calc, 02, Gather and Test Inputs  ----
      prog_detail <- "QC Inputs"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Fun Param, Define
      # sel_proj <- input$taxatrans_pick_official
      sel_proj <- "EGLE"
      sel_user_sampid <- input$taxatrans_user_col_sampid
      # sel_user_taxaid <- "TAXAID" # defined in pivot_longer below
      # sel_user_ntaxa <- "N_TAXA" # defined in pivot_longer below
      sel_user_taxaid <- input$taxatrans_user_col_taxaid
      sel_user_ntaxa <- input$taxatrans_user_col_n_taxa
      sel_user_siteid <- input$siteclass_user_col_siteid
      sel_user_lat <- input$siteclass_user_col_lat
      sel_user_long <- input$siteclass_user_col_long
      sel_user_width <- input$siteclass_user_col_width
      sel_user_groupby <- unlist(input$taxatrans_user_col_groupby)

      # convert to NULL if no input given
      if (sel_user_sampid == "Imported file necessary for selection...") {
        sel_user_sampid <- "User_Missing"
      }# if statement ~ END

      if (sel_user_siteid == "Imported file necessary for selection...") {
        sel_user_siteid <- "User_Missing"
      }# if statement ~ END

      if (sel_user_lat == "Imported file necessary for selection...") {
        sel_user_lat <- "User_Missing"
      }# if statement ~ END

      if (sel_user_long == "Imported file necessary for selection...") {
        sel_user_long <- "User_Missing"
      }# if statement ~ END

      if (sel_user_width == "Imported file necessary for selection...") {
        sel_user_width <- "User_Missing"
      }# if statement ~ END

      # Pivot Longer (wide-format only)
      if(FB_input_format == "Wide"){
        myChoices <- c(sel_user_sampid, sel_user_siteid, sel_user_lat
                       , sel_user_long, sel_user_width, sel_user_groupby)

        df_input <- df_input_wide %>%
          pivot_longer(!c(all_of(myChoices)), names_to = sel_user_taxaid
                       , values_to = sel_user_ntaxa
                       , values_drop_na = TRUE) %>%
          rename_with(~ gsub(" ", "_", .))
      }

      # Remove spaces in field names
      sel_user_sampid <- gsub(" ", "_", sel_user_sampid)
      sel_user_taxaid <- gsub(" ", "_", sel_user_taxaid)
      sel_user_ntaxa <- gsub(" ", "_", sel_user_ntaxa)
      sel_user_siteid <- gsub(" ", "_", sel_user_siteid)
      sel_user_lat <- gsub(" ", "_", sel_user_lat)
      sel_user_long <- gsub(" ", "_", sel_user_long)
      sel_user_width <- gsub(" ", "_", sel_user_width)
      sel_user_groupby <- gsub(" ", "_", sel_user_groupby)

      # Pull data
      fn_taxoff <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                  , "filename"]
      fn_taxoff_meta <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                       , "metadata_filename"]
      col_taxaid_official_match <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                                  , "taxaid"]
      col_taxaid_official_project <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                                    , "calc_taxaid"]
      fn_taxoff_attr <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                       , "attributes_filename"]
      fn_taxoff_attr_meta <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                       , "attributes_metadata_filename"]
      col_taxaid_attr <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                        , "attributes_taxaid"]
      sel_taxaid_drop <-  df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                     , "taxaid_drop"]
      dir_proj_results <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                         , "dir_results"]

      # include = yes; unique(sel_user_groupby)
      # include sampid, taxaid, and n_taxa so not dropped
      user_col_keep <- names(df_input)[names(df_input) %in% c(sel_user_groupby
                                                              , sel_user_sampid
                                                              , sel_user_taxaid
                                                              , sel_user_ntaxa
                                                              , sel_user_siteid
                                                              )]
      # flip to col_drop
      user_col_drop <- names(df_input)[!names(df_input) %in% user_col_keep]

      # Fun Param, Test

      if (sel_proj == "User_Missing") {
        # end process with pop up
        msg <- "'Calculation' is missing!"
        shinyalert::shinyalert(title = "Taxa Translate"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)

      }## IF ~ sel_proj

      if (sel_user_sampid == "User_Missing") {
        # end process with pop up
        msg <- "'SampleID' column name is missing!"
        shinyalert::shinyalert(title = "Taxa Translator/Site Classification"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)

      }## IF ~ sel_user_sampid

      if (sel_user_siteid == "User_Missing") {
        # end process with pop up
        msg <- "'SiteID' column name is missing!"
        shinyalert::shinyalert(title = "Site Classification"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)

      }## IF ~ sel_user_siteid

      if (sel_user_lat == "User_Missing") {
        # end process with pop up
        msg <- "'Latitude' column name is missing!"
        shinyalert::shinyalert(title = "Site Classification"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)

      }## IF ~ sel_col_lat

      if (sel_user_long == "User_Missing") {
        # end process with pop up
        msg <- "'Longitude' column name is missing!"
        shinyalert::shinyalert(title = "Site Classification"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)

      }## IF ~ sel_col_lon

      if (sel_user_width == "User_Missing") {
        # end process with pop up
        msg <- "'Width' column name is missing!"
        shinyalert::shinyalert(title = "Site Classification"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)

      }## IF ~ sel_user_width

      if (is.na(fn_taxoff_meta) | fn_taxoff_meta == "") {
        # set value to NULL
        df_official_metadata <- NULL
      }## IF ~ fn_taxaoff_meta

      if (is.na(sel_user_ntaxa) | sel_user_ntaxa == "") {
        sel_user_ntaxa <- NULL
      }## IF ~ fn_taxaoff_meta

      if (sel_taxaid_drop == "NULL") {
        sel_taxaid_drop <- NULL
      }## IF ~ sel_taxaid_drop

      # dir_proj_results <- paste("EGLE", dir_proj_results, sep = "_")
      #
      # dn_files <- paste(abr_results, dir_proj_results, , sep = "_")

      # Add "Results" folder if missing
      dn_file_builder <- paste(abr_results, abr_agency, abr_filebuilder
                               , "Output", sep = "_")

      path_results_sub <- file.path(path_results, dn_file_builder)

      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }

      ## Calc, 03, Import Official Data (and Metadata)  ----
      prog_detail <- "Import Data, Official and Metadata"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      ### Data,  Official Taxa ----
      temp_taxoff <- tempfile(fileext = ".csv")
      df_taxoff <- read.csv(file.path("data", fn_taxoff))

      ### Data, Official Taxa, Meta Data----
      if (!is.null(fn_taxoff_meta)) {
        temp_taxoff_meta <- tempfile(fileext = ".csv")
        df_taxoff_meta <- read.csv(file.path("data", fn_taxoff_meta))
      }## IF ~ fn_taxaoff_meta

      ### Data, Official Attributes----
      if (!is.null(fn_taxoff_attr)) {
        temp_taxoff_attr <- tempfile(fileext = ".csv")
        df_taxoff_attr <- read.csv(file.path("data", fn_taxoff_attr))
      }## IF ~ fn_taxoff_attr

      ### Data, Official Attributes, Meta Data----
      if (!is.null(fn_taxoff_meta)) {
        temp_taxoff_attr_meta <- tempfile(fileext = ".csv")
        df_taxoff_attr_meta <- read.csv(file.path("data", fn_taxoff_attr_meta))
      }## IF ~ fn_taxaoff_meta


      ## Calc, 04, Run Function ----

      prog_detail <- "Calculate, Taxa Trans"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # function parameters
      df_user                 <- df_input
      df_official             <- df_taxoff
      df_official_metadata    <- df_taxoff_meta
      taxaid_user             <- sel_user_taxaid
      taxaid_official_match   <- col_taxaid_official_match
      taxaid_official_project <- col_taxaid_official_project
      taxaid_drop             <- sel_taxaid_drop
      col_drop                <- user_col_drop #NULL #sel_col_drop
      sum_n_taxa_boo          <- TRUE
      sum_n_taxa_col          <- sel_user_ntaxa
      sum_n_taxa_group_by     <- c(sel_user_sampid
                                   , sel_user_taxaid
                                   , sel_user_siteid
                                   , sel_user_groupby)

      ### run the function ----
      taxatrans_results <- BioMonTools::taxa_translate(df_user
                                                       , df_official
                                                       , df_official_metadata
                                                       , taxaid_user
                                                       , taxaid_official_match
                                                       , taxaid_official_project
                                                       , taxaid_drop
                                                       , col_drop
                                                       , sum_n_taxa_boo
                                                       , sum_n_taxa_col
                                                       , sum_n_taxa_group_by
                                                       , trim_ws = TRUE
                                                       , match_caps = TRUE)

      ### Munge ----

      # Remove non-project taxaID cols
      # Specific to shiny project, not a part of the taxa_translate function

      # Attributes if have 2nd file
      if (!is.na(fn_taxoff_attr)) {

        df_ttrm <- taxatrans_results$merge
        # drop translation file columns
        col_keep_ttrm <- names(df_ttrm)[names(df_ttrm) %in% c(sel_user_sampid
                                                            , sel_user_taxaid
                                                            , sel_user_siteid
                                                            , sel_user_ntaxa
                                                            , "Match_Official"
                                                            , sel_user_groupby)]
        df_ttrm <- df_ttrm[, col_keep_ttrm]

        # merge with attributes
        df_merge_attr <- merge(df_ttrm
                               , df_taxoff_attr
                               , by.x = taxaid_user
                               , by.y = col_taxaid_attr
                               , all.x = TRUE
                               , sort = FALSE
                               , suffixes = c("_xDROP", "_yKEEP"))

        # Drop duplicate names from Trans file (x)
        col_keep <- names(df_merge_attr)[!grepl("_xDROP$"
                                                , names(df_merge_attr))]
        df_merge_attr <- df_merge_attr[, col_keep]
        # KEEP and rename duplicate names from Attribute file (y)
        names(df_merge_attr) <- gsub("_yKEEP$", "", names(df_merge_attr))
        # Save back to results list
        taxatrans_results$merge <- df_merge_attr

      }## IF ~ !is.na(fn_taxoff_attr)

      # Reorder by SampID and TaxaID
      taxatrans_results$merge <- taxatrans_results$merge[
           order(taxatrans_results$merge[, sel_user_sampid]
                   , taxatrans_results$merge[, sel_user_taxaid]), ]

      # Add input filenames
      taxatrans_results$merge[, "file_taxatrans"] <- fn_taxoff
      taxatrans_results$merge[, "file_attributes"] <- fn_taxoff_attr


      # Resort columns
      col_start <- c(sel_user_sampid
                     , sel_user_taxaid
                     , sel_user_ntaxa
                     , "file_taxatrans"
                     , "file_attributes")
      col_other <- names(taxatrans_results$merge)[!names(taxatrans_results$merge)
                                                  %in% col_start]
      taxatrans_results$merge <- taxatrans_results$merge[, c(col_start
                                                             , col_other)]

      # Convert required file names to standard
      ## do at end so don't have to modify any other variables
      boo_req_names <- TRUE
      if (boo_req_names == TRUE) {
        names(taxatrans_results$merge)[names(taxatrans_results$merge)
                                       %in% sel_user_sampid] <- "SampleID"
        names(taxatrans_results$merge)[names(taxatrans_results$merge)
                                       %in% sel_user_taxaid] <- "TaxaID"
        names(taxatrans_results$merge)[names(taxatrans_results$merge)
                                       %in% sel_user_ntaxa] <- "N_Taxa"
      }## IF ~ boo_req_names

      ## Calc, 05, Site Classification ----
      prog_detail <- "Site Classification"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      #### Pull sites ----
      df_sites <- df_input[, names(df_input) %in% c(sel_user_siteid
                                                  , sel_user_lat
                                                  , sel_user_long
                                                  , sel_user_width)]

      df_sites <- unique(df_sites) %>%
        rename(SiteID = all_of(sel_user_siteid)
               , Latitude = all_of(sel_user_lat)
               , Longitude = all_of(sel_user_long)
               , Width = all_of(sel_user_width)) %>%
        group_by(SiteID, Latitude, Longitude) %>%
        summarize(Width = mean(Width))

      #### QC ----
      # Test assumed values and field types
      # Test duplicates SiteID
      if (length(unique(df_sites$SiteID)) < nrow(df_sites)) {
        msg <- "There are duplicate SiteID values! Check for non-unique coordinates."
        shinyalert::shinyalert(title = "Coordinate Check",
                               text = msg,
                               type = "error",
                               closeOnEsc = TRUE,
                               closeOnClickOutside = TRUE)
      }# shinyalert ~ END

      # Test Latitude bounds
      if (any(df_sites$Latitude < 41.0000 | df_sites$Latitude > 49.0000)) {
        msg <- "Latitude is out of bounds!"
        shinyalert::shinyalert(title = "Coordinate Check"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
      }# shinyalert ~ END

      # Test Longitude bounds
      if (any(df_sites$Longitude < -91.0000 | df_sites$Longitude > -82.0000)) {
        msg <- "Longitude is out of bounds!"
        shinyalert::shinyalert(title = "Coordinate Check"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
      }# shinyalert ~ END

      # Test if Width field is numeric
      if (!is.numeric(df_sites$Width)) {
        msg <- "'Width' field must be numeric!"
        shinyalert::shinyalert(title = "Field Check"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
      }# shinyalert ~ END

      # App will crash if there are duplicate named fields
      ## Remove StreamCat variable fields if included in input file
      flds_new <- c("COMID"
                    , "PctSlope"
                    , "PctWetlands"
                    , "SiteClass_tmp"
                    , "Width_CAT"
                    , "INDEX_CLASS")
      boo_dup <- toupper(names(df_sites)) %in% toupper(flds_new)
      if (sum(boo_dup) > 0) {
        names_dup <- names(df_sites)[boo_dup]
        names_old <- paste0(names(df_sites), "_OLD")
        names(df_sites)[boo_dup] <- names_old[boo_dup]
      }## IF ~ boo_dup

      #### Join P51 Classes ----
      polygon_crs <- st_crs(GIS_layer_P51)
      df_sites_sf <- st_as_sf(df_sites, coords = c("Longitude", "Latitude")
                              , crs = 4326) %>% st_transform(crs = polygon_crs)

      df_results <- st_join(df_sites_sf, GIS_layer_P51) %>%
        st_drop_geometry()

      #### Site Classes ----
      df_SiteClass <- df_results %>%
        mutate(Width_CAT = case_when(Width < 13 ~ "Very Narrow"
                                     , Width < 21.270001 ~ "Narrow"
                                     , Width < 68.3670001 ~ "Mid"
                                     , TRUE ~ "Wide")#END ~ Width_CAT
               , INDEX_CLASS = case_when(SiteClass_tmp == "East" ~ "East"
                                         , (SiteClass_tmp == "North- Wetland > 40%"
                                            | SiteClass_tmp == "North- Wetland < 40%")
                                            & Width_CAT == "Very Narrow"
                                            ~ "VeryNarrow"
                                         , (SiteClass_tmp == "North- Wetland > 40%"
                                            | SiteClass_tmp == "North- Wetland < 40%")
                                            & Width_CAT == "Narrow"
                                            ~ "Narrow"
                                         , SiteClass_tmp == "North- Wetland < 40%"
                                            & Width_CAT == "Mid"
                                            ~ "MidSizeDry"
                                         , (SiteClass_tmp == "North- Wetland > 40%"
                                            & Width_CAT %in% c("Mid", "Wide"))
                                            |(SiteClass_tmp == "North- Wetland < 40%"
                                            & Width_CAT == "Wide")
                                            ~ "WetWide"
                                         , SiteClass_tmp == "Southwest Flat"
                                            ~ "WestFlat"
                                         , SiteClass_tmp == "Southwest Steep"
                                            ~ "WestSteep"
                                         , TRUE ~ "FLAG")#END ~ INDEX_CLASS
               )#END ~ mutate

      # Fix names to match user input
      names(df_SiteClass)[names(df_SiteClass) == "SiteID"] <- sel_user_siteid
      names(df_SiteClass)[names(df_SiteClass) == "Latitude"] <- sel_user_lat
      names(df_SiteClass)[names(df_SiteClass) == "Longitude"] <- sel_user_long
      names(df_SiteClass)[names(df_SiteClass) == "Width"] <- sel_user_width

      #### Join to taxa data ----

      # trim site class data
      df_SiteClass_trim <- df_SiteClass[, c(sel_user_siteid, "INDEX_CLASS")]

      # join to taxa data
      taxatrans_results$merge <- taxatrans_results$merge %>%
        left_join(df_SiteClass_trim, by = sel_user_siteid)


      ### Calc, 06, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Save files

      ## File version names
      df_save <- data.frame(Calculation = sel_proj
                            , OperationalTaxonomicUnit = col_taxaid_official_project
                            , TranslationTable = fn_taxoff
                            , AttributeTable = fn_taxoff_attr)

      fn_part <- "IBI_TaxaTranslator_source.csv"
      write.csv(df_save
                , file.path(path_results_qc, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)

      ## Taxa Official
      file.copy(file.path("data", fn_taxoff)
                , file.path(path_results_ref, fn_taxoff))

      ## Taxa Official, meta data
      file.copy(file.path("data", fn_taxoff_meta)
                , file.path(path_results_ref, fn_taxoff_meta))

      ## Taxa Official, Attributes
      file.copy(file.path("data", fn_taxoff_attr)
                , file.path(path_results_ref, fn_taxoff_attr))

      ## Taxa Official, Attributes, meta data
      file.copy(file.path("data", fn_taxoff_attr_meta)
                , file.path(path_results_ref, fn_taxoff_attr_meta))

      ## translate - crosswalk
      df_save <- taxatrans_results$taxatrans_unique
      fn_part <- "IBI_TaxaTranslator_modify.csv"
      write.csv(df_save
                , file.path(path_results_qc, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)

      ## Non Match
      df_save <- data.frame(taxatrans_results$nonmatch)
      fn_part <- "IBI_TaxaTranslator_nonmatch.csv"
      write.csv(df_save
                , file.path(path_results_qc, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)

      ## Site classification
      # Save Results
      fn_siteclass <- "IBI_StreamClassification.csv"
      dn_siteclass <- path_results_qc
      pn_siteclass <- file.path(dn_siteclass, fn_siteclass)
      write.csv(df_SiteClass, pn_siteclass, row.names = FALSE)

      ## Taxa Trans
      df_save <- taxatrans_results$merge
      fn_part <- "IBI_FileBuilder_CompleteInput.csv"
      write.csv(df_save
                , file.path(path_results_sub, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)

      ## Calc, 07, Create Zip ----
      prog_detail <- "Create Zip File For Download"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Create zip file for download
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)

      ## Calc, 08, Clean Up ----
      prog_detail <- "Clean Up"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # button, enable, download
      shinyjs::enable("b_download_taxatrans")

      # time, end
      toc <- Sys.time()
      duration <- difftime(toc, tic)

      # pop up
      # Inform user about number of taxa mismatches
      ## calc number of mismatch
      df_mismatch <- data.frame(taxatrans_results$nonmatch)
      n_taxa_mismatch <- nrow(df_mismatch)
      msg <- paste0("Number of mismatch taxa = ", n_taxa_mismatch, "\n\n"
                    , "Any mismatched taxa in 'mismatch' file in results download.")
      shinyalert::shinyalert(title = "Task Complete"
                             , text = msg
                             , type = "success"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      }## expr ~ withProgress ~ END
      , message = "Progress:"
      )## withProgress
    }##expr ~ ObserveEvent
    )##observeEvent ~ b_taxatrans_calc

  ## b_download_TaxaTrans ----
  output$b_download_taxatrans <- downloadHandler(

    filename = function() {
      inFile <- input$fn_input_taxatrans
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      fn_abr <- abr_filebuilder
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START

      file.copy(file.path(path_results, "results.zip"), fname)

    }##content~END
  )##download ~ TaxaTrans

  #~~~~CALC~~~~----
  # Calc, IBI ----
  ## b_Calc_IBI
  observeEvent(input$b_calc_ibi, {
    shiny::withProgress({

      # time, start
      tic <- Sys.time()

      ### Calc, 0, Set Up Shiny Code ----

      prog_detail <- "Calculation, IBI..."
      message(paste0("\n", prog_detail))

      # Number of increments
      prog_n <- 7
      prog_sleep <- 0.25

      ## Calc, 1, Initialize ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Remove existing files in "results"
      clean_results()

      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input_calc)

      # result folder and files
      fn_abr <- paste(abr_agency, abr_calc, sep = "_")
      fn_abr_save <- paste0("_", fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }

      # reference folder
      path_results_ref <- file.path(path_results, dn_files_ref)

      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_ref))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_ref))
      }

      # Add "QC" folder if missing
      path_results_qc <- file.path(path_results, dn_files_qc)
      boo_Results <- dir.exists(file.path(path_results_qc))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_qc))
      }

      # button, disable, download
      shinyjs::disable("b_download_ibi")

      # data
      inFile <- input$fn_input_calc
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      message(paste0("Import, file name, base: ", fn_input_base))
      df_input <- read.delim(inFile$datapath
                             , header = TRUE
                             , sep = input$sep_calc
                             , stringsAsFactors = FALSE)
      # QC, FAIL if TRUE
      if (is.null(df_input)) {
        return(NULL)
      }

      # QC, names to upper case
      names(df_input) <- toupper(names(df_input))

      # QC, specify "INDEX_NAME"
      df_input$INDEX_NAME <- "MIEGLE_2020"

      # QC, required input fields
      required_columns <- c("INDEX_NAME", "INDEX_CLASS", "SAMPLEID"
                            ,"TAXAID", "N_TAXA", "NONTARGET", "PHYLUM"
                            ,"SUBPHYLUM", "CLASS", "SUBCLASS", "ORDER"
                            , "FAMILY", "FFG", "TOLVAL", "HABIT")

      column_names <- colnames(df_input)

      # QC Check for column names
      col_req_match <- required_columns %in% column_names
      col_missing <- required_columns[!col_req_match]

      if (length(col_missing) > 0) {
        shinyalert(
          title = "Missing Columns",
          text = paste("You may have missing required columns for IBI calculation!\n"
                       , "Required columns missing from the data:\n"
                       , paste("* ", col_missing, collapse = "\n"))
          , type = "error")
        req(length(col_missing) == 0)# This will stop the function if there are missing columns
      }# END ~ shinyalert

      ## Calc, 2, Exclude Taxa ----
      prog_detail <- "Calculate, Exclude Taxa"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Calc
      message(paste0("User response to generate ExclTaxa = ", input$ExclTaxa))

      if (input$ExclTaxa) {
        phylo_all <- c("Kingdom"
                       , "Phylum"
                       , "SubPhylum"
                       , "Class"
                       , "SubClass"
                       , "Order"
                       , "SubOrder"
                       , "InfraOrder"
                       , "SuperFamily"
                       , "Family"
                       , "SubFamily"
                       , "Tribe"
                       , "Genus"
                       , "SubGenus"
                       , "Species"
                       , "Variety")
        phylo_all <- toupper(phylo_all) # so matches rest of file

        # case and matching of taxa levels handled inside of markExluded

        # Overwrite existing column if present
        # ok since user checked the box to calculate
        if ("EXCLUDE" %in% toupper(names(df_input))) {
          # save original user input
          df_input[, "EXCLUDE_USER"] <- df_input[, "EXCLUDE"]
          # drop column
          df_input <- df_input[, !names(df_input) %in% "EXCLUDE"]
        }## IF ~ Exclude

        # overwrite current data frame
        df_input <- BioMonTools::markExcluded(df_samptax = df_input
                                              , SampID = "SAMPLEID"
                                              , TaxaID = "TAXAID"
                                              , TaxaCount = "N_TAXA"
                                              , Exclude = "EXCLUDE"
                                              , TaxaLevels = phylo_all
                                              , Exceptions = NA)

        # Save Results
        fn_excl <- "IBI_1markexcl.csv"
        dn_excl <- path_results_qc
        pn_excl <- file.path(dn_excl, fn_excl)
        write.csv(df_input, pn_excl, row.names = FALSE)

      }## IF ~ input$ExclTaxa

      ## Calc, 3, MetVal----
      prog_detail <- "Calculate, Metric, Values"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Calc
      df_metval <- BioMonTools::metric.values(fun.DF = df_input
                                    , fun.Community = "bugs"
                                    , boo.Shiny = TRUE
                                    , verbose = TRUE)

      ### Save Results ----

      fn_metval <- "IBI_2metvall_all.csv"
      dn_metval <- path_results_qc
      pn_metval <- file.path(dn_metval, fn_metval)
      write.csv(df_metval, pn_metval, row.names = FALSE)

      ### Save Results (IBI) ----
      # Munge
      ## Model metrics only
      cols_req <- c("SAMPLEID", "INDEX_NAME", "INDEX_CLASS"
                    , "nt_total", "ni_total")
      cols_metrics_keep <- unique(c(cols_req, MichMetrics))
      df_metval_slim <- df_metval[, names(df_metval) %in% cols_metrics_keep]

      # Save
      fn_metval_slim <- "IBI_2metval_IBI.csv"
      dn_metval_slim <- path_results_qc
      pn_metval_slim <- file.path(dn_metval_slim, fn_metval_slim)
      write.csv(df_metval_slim, pn_metval_slim, row.names = FALSE)

      ## Calc, 4, MetScoring----
      prog_detail <- "Calculate, Metric, Scores"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Thresholds
      fn_thresh <- file.path(system.file(package="BioMonTools")
                             , "extdata"
                             , "MetricScoring.xlsx")
      df_thresh_metric <- read_excel(fn_thresh, sheet="metric.scoring")
      df_thresh_index <- read_excel(fn_thresh, sheet="index.scoring")

      # run scoring code
      df_metsc <- BioMonTools::metric.scores(DF_Metrics = df_metval_slim
                                             , col_MetricNames = MichMetrics
                                             , col_IndexName = "INDEX_NAME"
                                             , col_IndexClass = "INDEX_CLASS"
                                             , DF_Thresh_Metric = df_thresh_metric
                                             , DF_Thresh_Index = df_thresh_index
                                             , col_ni_total = "ni_total")

      # remove Index_Nar field from BioMonTools
      df_metsc <- df_metsc %>%
        select(-c(Index_Nar))

      # Save Results
      fn_metsc <- "IBI_3metsc.csv"
      dn_metsc <- path_results_qc
      pn_metsc <- file.path(dn_metsc, fn_metsc)
      write.csv(df_metsc, pn_metsc, row.names = FALSE)

      ## Calc, 5, Attainment----
      prog_detail <- "Calculate, Index, Attainment"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # Attainment
      df_index_attn <- df_metsc %>%
        mutate(AttainmentCategory = case_when(
          INDEX_CLASS == "WESTSTEEP" & Index < 42 ~ "Does not meet expectations",
          INDEX_CLASS == "WESTFLAT" & Index < 46 ~ "Does not meet expectations",
          INDEX_CLASS == "EAST" & Index < 46 ~ "Does not meet expectations",
          INDEX_CLASS == "VERYNARROW" & Index < 59 ~ "Does not meet expectations",
          INDEX_CLASS == "NARROW" & Index < 48 ~ "Does not meet expectations",
          INDEX_CLASS == "MIDSIZEDRY" & Index < 45 ~ "Does not meet expectations",
          INDEX_CLASS == "WETWIDE" & Index < 45 ~ "Does not meet expectations",
          TRUE ~ "Meets expectations"))

      # Save Results
      fn_index_attn <- "IBI_IndexCalc_Final.csv"
      dn_index_attn <- path_results_sub
      pn_index_attn <- file.path(dn_index_attn, fn_index_attn)
      write.csv(df_index_attn, pn_index_attn, row.names = FALSE)

      ## Calc, 6, Save, Reference----
      prog_detail <- "Calculate, Save, Reference"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)

      path_results_ref <- file.path(path_results, dn_files_ref)

      ## Metric Names
      fn_save <- "MetricNames.xlsx"
      file_from <- temp_metricnames
      file_to <- file.path(path_results_ref, fn_save)
      file.copy(file_from, file_to)

      ## Metric Scoring
      fn_save <- "MetricScoring.xlsx"
      file_from <- temp_metricscoring
      file_to <- file.path(path_results_ref, fn_save)
      file.copy(file_from, file_to)

      ## Calc, 7, Clean Up----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))

      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)

      # Create zip file of results
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)

      # button, enable, download
      shinyjs::enable("b_download_ibi")

      # time, end
      toc <- Sys.time()
      duration <- difftime(toc, tic)

      # pop up
      msg <- paste0("Total Records (Input) = ", nrow(df_input)
                    , "\n\n"
                    , "Elapse Time (", units(duration), ") = ", round(duration, 2))
      shinyalert::shinyalert(title = "Task Complete"
                             , text = msg
                             , type = "success"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      }## expr ~ withProgress ~ END
      , message = "Progress:"
      )## withProgress ~ END
    }##expr ~ ObserveEvent ~ END
    )##observeEvent ~ b_calc_ibi ~ END

  ## b_download_ibi ----
  output$b_download_ibi <- downloadHandler(

    filename = function() {
      inFile <- input$fn_input_calc
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      fn_abr <- abr_calc
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
      }
    , content = function(fname) {##content~START
      file.copy(file.path(path_results, "results.zip"), fname)
      }##content~END
    )##download ~ IBI

})##shinyServer ~ END
