#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dashboardPage(
  header = dashboardHeader(title = "EGLE IBI Calculator", titleWidth = 275)
  , sidebar = dashboardSidebar(db_main_sb("leftsidebarmenu"))
  # , body = dashboardBody(db_main_body("dbBody"))
  , body = dashboardBody(
    tags$style(HTML("/* Target the 'body' tag inside your RMarkdown content */
      body {font-size: 16px;}")),
    db_main_body("dbBody"))
  , footer = dashboardFooter(left = pkg_version
                             , right = "https://github.com/Blocktt/MIEGLEtools")
) ## dashboardPage ~ END

# https://rstudio.github.io/shinydashboard/get_started.html
