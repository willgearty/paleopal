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

  # a named list of quoted code bits that will go after the libraries are loaded
  # each element may also be a list of quoted code bits that will be flattened
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
  # add a step to the report, workflow, and the code chain
  # fun_workflow is the function that generates the UI elements for the workflow
  # fun_report is the function that generates the UI elements for the report
  # code_chain_list is a list of quoted code bits that will be added to code_chain()
  add_step <- function(ind, fun_workflow, fun_report, code_chain_list) {
    # add the UI elements to the workflow
    accordion_panel_insert(".workflow_accordion", panel = fun_workflow(ind))
    accordion_panel_open(".workflow_accordion", values = paste0("step_", ind))

    # add the UI elements to the report
    tmp_list <- report_list()
    tmp_list[[paste0("step_", ind)]] <- fun_report(ind)
    report_list(tmp_list)

    # add the code to the code chain
    tmp_list <- code_chain()
    tmp_list[[paste0("step_", ind)]] <- code_chain_list
    code_chain(tmp_list)

    # handle removing this step from the report and workflow
    observeEvent(input[[paste0(".remove_step_", ind)]], {
      accordion_panel_remove(".workflow_accordion",
                             target = paste0("step_", ind))
      for (fun in c(report_list, code_chain)) {
        tmp_list <- fun()
        tmp_list[[paste0("step_", ind)]] <- NULL
        fun(tmp_list)
      }
    }, ignoreInit = TRUE)
    updateTextInput(inputId = ".accordion_version",
                    value =
                      as.numeric(isolate(input$.accordion_version)) + 1)
  }

  # source module files ####
  # load the dynamic bits for each modules (ui-aux.R and server.R)
  # make sure local = TRUE so they all share a namespace with the main app
  sapply(modules, FUN = function(module) {
    ui_aux_file <- file.path(module, "ui-aux.R")
    if (file.exists(ui_aux_file)) source(ui_aux_file, local = TRUE)
    server_file <- file.path(module, "server.R")
    if (file.exists(server_file)) source(server_file, local = TRUE)
  })

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
    # TODO: figure out how to maintain which steps are open/expanded
    accordion(rank_list(labels = workflow_list(),
                        input_id = ".workflow_sortable"),
              open = isolate(input$.workflow_accordion),
              id = ".workflow_accordion")
  })

  # handle workflow reordering
  observeEvent(input$.workflow_sortable, {
    new_order <- isolate(input$.workflow_sortable)
    tmp_list <- report_list()
    report_list(tmp_list[new_order])
    tmp_list <- code_chain()
    code_chain(tmp_list[new_order])
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
          code = inject(expandChain(!!!list_flatten(unname(code_chain()))))
        ),
        render_args = list(output_format = c("html_document", "pdf_document"))
      )
    }
  )
}
