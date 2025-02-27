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

  # lists of elements for the workflow and report
  workflow_list <- reactiveVal(tagList())
  report_list <- reactiveVal(tagList())

  # source each module's server.R file
  # make sure local = TRUE so they all share a namespace
  source("./modules/test_module/server.R", local = TRUE)

  output$libraries <- renderPrint({
    inject(expandChain(!!!libraries_chain))
  })

  observeEvent(input$remove_step, {
    report_list(head(report_list(), length(report_list()) - 1))
    workflow_list(head(workflow_list(), length(workflow_list()) - 1))
  }, ignoreInit = TRUE)

  output$report <- renderUI({
    tagList(
      verbatimTextOutput("libraries"),
      report_list()
    )
  })

  output$workflow <- renderUI({
    accordion(!!!workflow_list(), multiple = FALSE)
  })

  output$download_script <- downloadHandler(
    filename = "paleopal_script.zip",
    content = function(file) {
      buildRmdBundle(
        "./modules/test_report.qmd",
        file,
        vars = list(
          libraries = inject(expandChain(!!!libraries_chain)),
          code = inject(expandChain(!!!code_chain))
        ),
        render_args = list(output_format = c("html_document", "pdf_document"))
      )
    }
  )
}
