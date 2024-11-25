# Calculate BCG Panel

function() {
  sidebarLayout(
    sidebarPanel(
       h2("Calculate BCG Models")
       , p("This function will render all steps and make available files for download.")
       , br()

       , h4("A. Upload a file")
       , p("If no file name showing below repeat 'Import File' in the left sidebar.")
       , p(textOutput("fn_input_display_bcg"))

       , h4("B. Define Data Source (for metrics and rules)")
       , shinyjs::disabled(selectInput("si_community" # DO NOT DELETE; CAUSES TAXATOL ISSUE
                     , label = "Data Source" # DO NOT DELETE; CAUSES TAXATOL ISSUE
                     , choices = c("", "sel_community"))) # DO NOT DELETE; CAUSES TAXATOL ISSUE

       # , h4("C. Mark Redundant (Non-Distinct) Taxa")
       # , includeHTML(file.path("www", "rmd_html", "ShinyHTML_RedundantTaxa.html"))
       # , checkboxInput("ExclTaxa"
       #                 , "Generate Redundant Taxa Column"
       #                 , TRUE)

       , h4("C. Define BCG Model")
       , p("Determined by Data Source chosen in Step B.")

       , h4("D. Run Calculations")
       , p("This button will calculate metrics values, metric memberships
           , level membership, and level assignment.")
       , useShinyjs()
       , shinyjs::disabled(shinyBS::bsButton("b_calc_bcg"
                                             , label = "Run Calculations"))

       , h4("E. Download Results")
       , p("All input and output files will be available in a single zip file.")
       , shinyjs::disabled(downloadButton("b_download_bcg"
                                          , "Download Results"))
        )## sidebarPanel ~ END
    , mainPanel(
        tabsetPanel(type = "tabs"
                    , tabPanel(title = "Calc_BCG_Output"
                               ,includeHTML(file.path("www"
                                                      , "rmd_html"
                                          , "ShinyHTML_Calc_Output.html"))
                               )
                    )## tabsetPanel ~ END

    )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
