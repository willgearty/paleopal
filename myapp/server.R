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
  # a list of quoted code bits that will go at the very top of the report
  libraries_chain <- list(quote(quote(library(tidyverse))))

  # a list of quote code bits that will go after the libraries are loaded
  code_chain <- list()

  # source each module's server.R file
  # make sure local = TRUE so they all share a namespace
  source("./modules/test_module/server.R", local = TRUE)

  output$libraries <- renderPrint({
    inject(expandChain(!!!libraries_chain))
  })

  # TODO: convert this to a downloadable .Rmd file
  output$code <- renderPrint({
    inject(expandChain(!!!code_chain))
  })
}
