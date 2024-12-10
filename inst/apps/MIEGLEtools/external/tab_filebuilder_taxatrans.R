# File Builder Panel, taxa translate

function() {
  sidebarLayout(
    sidebarPanel(h2("File Builder")
            , h3("Taxa Translator, Attribute Assignment, and Index Class Assignment")
            , useShinyjs()

            , p("The process below will combine user data with an official taxa list.")

            , h4("A. Upload a File")
            , p("If no file name showing below, then repeat 'Import File' in the left sidebar.")
            , p(textOutput("fn_input_display_taxatrans"))

            , h4("B. Select Calculation.")
            , selectInput(inputId = "taxatrans_pick_official"
                          , label = "Calculation"
                          , choices = NULL)

            , h4("C. User File Column Names")

            , h5("Required Matching Fields")
            , p("If the default values are present they will be auto-populated.")

            , selectInput(inputId = "taxatrans_user_col_sampid"
                          , label = "Column, Unique Sample Identifier (e.g., SampleID)"
                          , choices = "Imported file necessary for selection...")
            , selectInput(inputId = "taxatrans_user_col_taxaid"
                          , label = "Column, TaxaID"
                          , choices = "Imported file necessary for selection...")
            , selectInput(inputId = "taxatrans_user_col_n_taxa"
                          , label = "Column, Taxa Count (number of individuals or N_Taxa)"
                          , choices = "Imported file necessary for selection...")
            , selectInput(inputId = "siteclass_user_col_siteid"
                          , label = "Column, SiteID"
                          , choices = "Imported file necessary for selection...")
            , selectInput(inputId = "siteclass_user_col_lat"
                          , label = "Column, Latitude (decimal degrees)"
                          , choices = "Imported file necessary for selection...")
            , selectInput(inputId = "siteclass_user_col_long"
                          , label = "Column, Longitude (decimal degrees)"
                          , choices = "Imported file necessary for selection...")
            , selectInput(inputId = "siteclass_user_col_width"
                          , label = "Column, Stream Width (ft)"
                          , choices = "Imported file necessary for selection...")

            , h5("Other Required Fields and Optional Fields")
            , p("Specify all optional fields here. Do not repeat any of the required fields from above.")
            , p("All fields not specified below will be dropped from the output.")

            , selectInput(inputId = "taxatrans_user_col_groupby"
                          , label = "Columns to Keep in Output"
                          , choices = "Imported file necessary for selection..."
                          , multiple = TRUE)

            , h4("D. Run Operation")
            , p("This button will merge the user file with the official taxa file.")
            , shinyjs::disabled(shinyBS::bsButton("b_calc_taxatrans"
                                                  , label = "Run Operation"))

            , h4("E. Download Output")
            , p("All input and output files will be available in a single zip file.")
            , shinyjs::disabled(downloadButton("b_download_taxatrans"
                                               , "Download Results"))
            )## sidebarPanel ~ END
       , mainPanel(tabsetPanel(type = "tabs"
                               , tabPanel(title = "TaxaTrans_About"
                                          , includeHTML(file.path("www"
                                                                  , "rmd_html"
                                      , "ShinyHTML_FB_TaxaTrans_1About.html")))# END ~ tabPanel
                               , tabPanel(title = "TaxaTrans_Output"
                                          , includeHTML(file.path("www"
                                                                  , "rmd_html"
                                      , "ShinyHTML_FB_TaxaTrans_2Output.html")))# END ~ tabPanel
                               )## tabsetPanel ~ END
                   )## mainPanel ~ END
    )##sidebarLayout ~ END
  }##FUNCTION ~ END
