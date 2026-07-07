# paleopal by William Gearty

#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

source("global.R")

options("styler.cache_name" = NULL)

# Define server logic required to draw a histogram
function(input, output, session) {
  shinypal_setup(input, output, session, modules,
                 download_filename = "paleopal_script.zip")

  # follow browser back/forward across the navbar tabs
  observeEvent(input$url_hash, {
    hash <- sub("^#", "", input$url_hash)
    # a bare URL or the initial no-hash entry maps to the landing tab
    if (!nzchar(hash)) hash <- "welcome"
    # a hash that doesn't match the open tab means the user hit back/forward
    if (!identical(hash, input$tabs)) {
      freezeReactiveValue(input, "tabs")
      nav_select("tabs", selected = hash, session = session)
    }
  }, ignoreInit = TRUE, priority = 1)

  observeEvent(input$tabs, {
    # record each tab change as a browser history entry
    if (!identical(input$tabs, sub("^#", "", input$url_hash))) {
      session$sendCustomMessage("pushHash", paste0("#", input$tabs))
    }
  }, ignoreInit = TRUE, priority = 0)
}
