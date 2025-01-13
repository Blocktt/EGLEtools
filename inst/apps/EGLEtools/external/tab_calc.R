# Calculate Panel

function() {
  sidebarLayout(
    sidebarPanel(
       h2("Calculate P51 Scores")
       , p("This function will calculate metric values, metric scores, index scores,
           and apply macroinvertebrate ratings for all samples in the input file.")

       , h4("A. Upload a file")
       , p("The 'separator' allows the user to upload different file formats
                         (e.g., csv, tsv, or txt).")
       , p(paste0("File uploads are limited to a maximum of "
                  , mb_limit
                  , " MB in size."))
       , radioButtons("sep_calc", "Separator"
                      , c(Comma = ",", Tab = "\t"),',')
       , fileInput("fn_input_calc", label = "Choose file to upload"
                   , multiple = FALSE
                   , accept = c("text/csv"
                                , "text/comma-separated-values"
                                , "text/tab-separated-values"
                                , "text/plain"
                                , ".csv"
                                , ".tsv"
                                , ".txt"))##fileInput~END

       , h4("B. Mark Redundant (Non-Distinct) Taxa")
       , checkboxInput("ExclTaxa"
                       , "Generate EXCLUDE Column"
                       , TRUE)

       , h4("C. Run Calculations")
       , useShinyjs()
       , shinyjs::disabled(shinyBS::bsButton("b_calc_ibi"
                                             , label = "Run Calculations"))

       , h4("D. Download Results")
       , p("All input and output files will be available in a single zip file.")
       , shinyjs::disabled(downloadButton("b_download_ibi"
                                          , "Download Results"))
       )## sidebarPanel ~ END
    , mainPanel(
        tabsetPanel(type = "tabs"
                    , tabPanel(title = "Uploaded Data"
                               , p("A table is shown below after data are loaded.")
                               , DT::dataTableOutput("df_import_DT_calc"))
                    , tabPanel(title = "Output Description"
                               ,includeHTML(file.path("www"
                                                      , "rmd_html"
                                          , "ShinyHTML_Calc_Output.html"))))## tabsetPanel ~ END
        )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
