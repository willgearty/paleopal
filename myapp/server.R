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
  # shared server objects ####
  # a list of quoted code bits that will go at the very top of the report
  # TODO: might need to make this reactive?
  libraries_chain <- list(quote(quote(library(tidyverse))))

  # a list of quote code bits that will go after the libraries are loaded
  code_chain <- reactiveVal(list())

  # ordered, named list of elements in the workflow
  workflow_list <- reactiveVal(tagList())
  # ordered, named list of elements in the report
  report_list <- reactiveVal(tagList())
  # unordered, named list of intermediate variables that need to be global for
  # assembly of the markdown file
  intermediate_list <- reactiveValues()
  # unordered, named list of old values for form elements
  old_vals <- reactiveVal()

  # common server functions ####
  # add a step to the report and workflow
  add_step <- function(fun_workflow, fun_report, ind) {
    # add the UI elements to the workflow
    tmp_list <- workflow_list()
    tmp_list[[paste0("step_", ind)]] <- fun_workflow(ind)
    workflow_list(tmp_list)

    # add the UI elements to the report
    tmp_list <- report_list()
    tmp_list[[paste0("step_", ind)]] <- fun_report(ind)
    report_list(tmp_list)
  }

  # remove a specific step from the report and workflow
  remove_step <- function(ind) {
    observeEvent(input[[paste0(".remove_step_", ind)]], {
      tmp_list <- report_list()
      tmp_list[[paste0("step_", ind)]] <- NULL
      report_list(tmp_list)
      tmp_list <- workflow_list()
      tmp_list[[paste0("step_", ind)]] <- NULL
      workflow_list(tmp_list)
    }, ignoreInit = TRUE)
  }

  # source server.R files ####
  # source each module's server.R file
  # make sure local = TRUE so they all share a namespace
  source("./modules/test_module/server.R", local = TRUE)

  # render dynamic UI ####
  # add libraries to load at the beginning of the report
  output$libraries <- renderPrint({
    inject(expandChain(!!!libraries_chain))
  })

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
    accordion(!!!unname(workflow_list()), multiple = FALSE)
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

  # report download ####
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
