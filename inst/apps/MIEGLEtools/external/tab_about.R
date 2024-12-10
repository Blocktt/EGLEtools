# About Panel
function() {
    tabPanel("tabpan_about"
             , includeHTML(file.path("www", "rmd_html", "ShinyHTML_About.html"))
             , class = "center-content"
    )##tabPanel ~ END
}##FUNCTION ~ END

# function() {
#   mainPanel(
#     tabPanel("tabpan_about"
#              , includeHTML(file.path("www", "rmd_html", "ShinyHTML_About.html"))
#              , class = "center-content"
#     )##tabPanel ~ END
#   )##mainPanel  ~ END
# }##FUNCTION ~ END
