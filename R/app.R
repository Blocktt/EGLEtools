#' Launch Shiny App
#'
#' https://debruine.github.io/shinyintro/sharing.html
#'
#' @param name The name of the app to run
#' @param ... arguments to pass to shiny::runApp
#'
#' @export
#'
app <- function(name = "default_app", ...) {
  appDir <- system.file(paste0("apps/", name), package = "mypackagename")
  if (appDir == "") stop("The shiny app ", name, " does not exist")
  shiny::runApp(appDir, ...)
}
