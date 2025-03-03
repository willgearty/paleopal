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
  # TODO: might need to make this reactive?
  libraries_chain <- list(quote(quote(library(tidyverse))))

  # a list of quote code bits that will go after the libraries are loaded
  code_chain <- reactiveVal(list())

  # ordered list of elements in the workflow
  workflow_list <- reactiveVal(tagList())
  # ordered list of elements in the report
  report_list <- reactiveVal(tagList())
  # unordered, named list of intermediate variables that need to be global for
  # assembly of the markdown file
  intermediate_list <- reactiveValues()
  # unordered, named list of old values for form elements
  old_vals <- reactiveVal()

  # source each module's server.R file
  # make sure local = TRUE so they all share a namespace
  source("./modules/test_module/server.R", local = TRUE)

  # add libraries to load at the beginning of the report
  output$libraries <- renderPrint({
    inject(expandChain(!!!libraries_chain))
  })

  # handle removing the last step
  # TODO: this should be handled for any arbitrary step
  observeEvent(input$.remove_step, {
    report_list(head(report_list(), length(report_list()) - 1))
    workflow_list(head(workflow_list(), length(workflow_list()) - 1))
  }, ignoreInit = TRUE)

  # render the report
  output$report <- renderUI({
    tagList(
      verbatimTextOutput("libraries"),
      report_list()
    )
  })

  # render the workflow
  output$workflow <- renderUI({
    old_vals(isolate(reactiveValuesToList(input)))
    updateTextInput(inputId = ".accordion_version",
                    value =
                      as.numeric(isolate(input$.accordion_version)) + 1)
    accordion(!!!workflow_list(), multiple = FALSE)
  })

  # restore old inputs
  observeEvent(input$.accordion_version, {
    old_vals_list <- isolate(old_vals())
    for (idx in seq_along(old_vals_list)) {
      runjs(paste0("$('#", names(old_vals_list)[[idx]],
                   "').val('", old_vals_list[[idx]],
                   "').change().data('selectize').setValue('",
                   old_vals_list[[idx]],
                   "');"))
    }
  }, ignoreInit = TRUE)

  # handle downloading a zip folder with the markdown script and rendered files
  output$download_script <- downloadHandler(
    filename = "paleopal_script.zip",
    content = function(file) {
      buildRmdBundle(
        "./modules/test_report.qmd",
        file,
        vars = list(
          # lists of quoted code bits, need to be injected into expandChain()
          libraries = inject(expandChain(!!!libraries_chain)),
          code = inject(expandChain(!!!code_chain()))
        ),
        render_args = list(output_format = c("html_document", "pdf_document"))
      )
    }
  )
}
