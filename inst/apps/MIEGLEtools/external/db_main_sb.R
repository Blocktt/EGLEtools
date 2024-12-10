#Sidebar----

# tabs
# sourced in global.R
# ref in db_main_body.R
# menu in db_main_sb.R

function(id) {
  dashboardSidebar(
    width = 275
    , sidebarMenu(id = id
                  , HTML(paste0(
                    "<br>",
                    "<a href='https://www.michigan.gov/egle/about/organization/water-resources/glwarm/biological-assessments' target='_blank'><img style = 'display: block; margin-left: auto; margin-right: auto;' src='EGLE_Logo_Primary_White.png' width = '230'></a>",
                    "<br>"))# END ~ HTML
      , menuItem(text = "About"
               , tabName = "tab_about"
               , icon = icon("house"))# END ~ menuItem
      , menuItem(text = "Import File"
                 , tabName = "tab_import"
                 , icon = icon("file-arrow-up")
                 , startExpanded = TRUE)# END ~ menuItem
      , menuItem(text = "Step 1: Prepare Data"
                 , icon = icon("toolbox")
                 , menuSubItem("Introduction"
                               , tabName = "tab_filebuilder_intro"
                               , icon = icon("info"))# END ~ menuSubItem
                 , menuSubItem("Within the App: File Builder"
                               , tabName = "tab_filebuilder_taxatrans"
                               , icon = icon("language"))# END ~ menuSubItem
                 , menuSubItem("Outside the App"
                               , tabName = "tab_filebuilder_outsideapp"
                               , icon = icon("language"))# END ~ menuSubItem
                 )# END ~ menuItem
      , menuItem(text = "Step 2: Calculation"
                 , icon = icon("gears")
                 , tabName = "tab_calc")# END ~ menuItem
      , menuItem(text = "Relevant Resources"
                 , tabName = "tab_resources"
                 , icon = icon("book"))
    )## sidebarMenu ~ END
  )## dashboardSidebar ~ END
}## FUNCTION ~ END
