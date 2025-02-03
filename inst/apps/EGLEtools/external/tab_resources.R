# Resources Panel

function() {
  tabPanel("tabpan_resources"
           , h2("Resources")
            , includeHTML(file.path("www", "rmd_html", "ShinyHTML_Resources.html"))
           , class = "center-content"
           )##tabPanel ~ END
}##FUNCTION ~ END
