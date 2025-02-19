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
  code_chain <- list()
  code_chain <- append(code_chain,
                       quote(quote(library(tidyverse))))
  # source each module's server.R file
  # make sure local = TRUE so they all share a namespace
  source("./modules/test_module/server.R", local = TRUE)

  output$code <- renderPrint({
    inject(expandChain(!!!code_chain))
  })
}
