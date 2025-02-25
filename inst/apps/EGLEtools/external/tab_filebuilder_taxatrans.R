# File Builder Panel, taxa translate

function() {
  sidebarLayout(
    sidebarPanel(h2("File Builder")
            , h3("Taxa Translator, Attribute Assignment, and Stream Class Assignment")
            , useShinyjs()

            , p("The process below will combine user data with an official taxa list,
                assign taxa attributes, and assign sites to index classes.")
            , p("See 'About File Builder' tab for more details.")

            , h4("A. Upload a File")
            , p("Choose whether your input file is wide-format (default) or long-format.")
            , p("The 'separator' allows the user to upload different file formats
                         (e.g., csv or tsv).")
            , p(paste0("File uploads are limited to a maximum of "
                       , mb_limit
                       , " MB in size."))
            , radioButtons("fn_input_format", "Input file format"
                           , choices = list("Wide", "Long")
                           , selected = "Wide")
            , radioButtons("sep_taxatrans", "Separator"
                           , c(Comma = ",", Tab = "\t"),',')
            , fileInput("fn_input_taxatrans", label = "Choose file to upload"
                        , multiple = FALSE
                        , accept = c("text/csv"
                                     , "text/comma-separated-values"
                                     , "text/tab-separated-values"
                                     , "text/plain"
                                     , ".csv"
                                     , ".tsv"
                                     , ".txt"))##fileInput~END
            # , p(textOutput("fn_input_display_taxatrans"))

            , h4("B. User Specified Column Names")
            , p(strong("Required Matching Fields"))
            , p("If the default values are present they will be auto-populated.")

            , selectInput(inputId = "taxatrans_user_col_sampid"
                          , label = "Column, Unique Sample Identifier (e.g., SampleID)"
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
            , selectInput(inputId = "taxatrans_user_col_taxaid"
                          , label = "Taxa identifier (e.g., TaxaID)"
                          , choices = "Imported file necessary for selection...")
            , selectInput(inputId = "taxatrans_user_col_n_taxa"
                          , label = "Number of taxa (e.g., N_TAXA)"
                          , choices = "Imported file necessary for selection...")

            , p(strong("Other Fields"))
            , p(strong(em("Wide-format:")), " REQUIRED to add all non-taxa fields here.
                DO NOT REPEAT COLUMNS FROM ABOVE."
                , br(), strong(em("Long-format:"))
                , " OPTIONAL to add other fields to carry through analyses.
                DO NOT REPEAT COLUMNS FROM ABOVE.")

            , selectInput(inputId = "taxatrans_user_col_groupby"
                          , label = "Columns to Keep in Output"
                          , choices = "Imported file necessary for selection..."
                          , multiple = TRUE)

            , h4("C. Run Operation")
            , shinyjs::disabled(shinyBS::bsButton("b_calc_taxatrans"
                                                  , label = "Run Operation"))

            , h4("D. Download Output")
            , p("All input and output files will be available in a single zip file.")
            , shinyjs::disabled(downloadButton("b_download_taxatrans"
                                               , "Download Results"))
            )## sidebarPanel ~ END
       , mainPanel(tabsetPanel(type = "tabs"
                               , tabPanel(title = "Uploaded Data"
                                          , p("A table is shown below after data are loaded.")
                                          , DT::dataTableOutput("df_import_DT_taxatrans"))
                               , tabPanel(title = "About File Builder"
                                          , includeHTML(file.path("www"
                                                                  , "rmd_html"
                                      , "ShinyHTML_FB_TaxaTrans_1About.html")))# END ~ tabPanel
                               , tabPanel(title = "Output Description"
                                          , includeHTML(file.path("www"
                                                                  , "rmd_html"
                                      , "ShinyHTML_FB_TaxaTrans_2Output.html")))# END ~ tabPanel
                               )## tabsetPanel ~ END
                   )## mainPanel ~ END
    )##sidebarLayout ~ END
  }##FUNCTION ~ END
