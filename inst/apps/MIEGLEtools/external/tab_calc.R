# Calculate Panel

function() {
  sidebarLayout(
    sidebarPanel(
       h2("Calculate IBI Models")
       , p("This function will render all steps and make available files for download.")
       , br()

       , h4("A. Upload a file")
       , p("If no file name showing below, then repeat 'Import File' in the left sidebar.")
       , p(textOutput("fn_input_display_ibi"))

       , h4("B. Mark Redundant (Non-Distinct) Taxa")
       , checkboxInput("ExclTaxa"
                       , "Generate Redundant Taxa Column"
                       , TRUE)

       , h4("C. Run Calculations")
       , p("This button will calculate metrics values, metric scores
           , index scores, and attainment status for every sample.")

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
                    , tabPanel(title = "Calc_IBI_Output"
                               ,includeHTML(file.path("www"
                                                      , "rmd_html"
                                          , "ShinyHTML_Calc_Output.html"))))## tabsetPanel ~ END
        )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
