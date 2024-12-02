# Prepare Data Panel, outside app

function() {
  tabPanel("tab_filebuilder_outsideapp"
           , includeHTML(file.path("www", "rmd_html", "ShinyHTML_FB_outsideapp.html"))
  )##tabPanel ~ END
}##FUNCTION ~ END
