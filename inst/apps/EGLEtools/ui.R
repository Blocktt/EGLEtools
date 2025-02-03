dashboardPage(
  header = dashboardHeader(title = "EGLE P51 Score Calculator", titleWidth = 275),
  sidebar = dashboardSidebar(db_main_sb("leftsidebarmenu")),
  body = dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"))
    ,tags$style(HTML("/* Target the 'body' tag inside your RMarkdown content */
      body {font-size: 16px;}"))
    , db_main_body("dbBody"))
  , footer = dashboardFooter(left = pkg_version
                             , right = "https://github.com/Blocktt/EGLEtools")
  , skin = NULL  # Disable the default skin
) # dashboardPage ~ END
