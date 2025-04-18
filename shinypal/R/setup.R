# maybe a setup function that sets some variables in the environment?
# maybe the names of the input objects that should be watched?
#' @title Setup shinypal
#' @description
#'   A function to set up the shinypal environment. This function should be
#'   called at the top of the server function of your shiny app.
#' @details
#'   Each module should have a `ui-aux.R` file that defines the UI elements for
#'   that module in the "Workflow" accordion and a `server.R` file that defines
#'   the server-side logic for the module.
#' @param input The shiny input object.
#' @param output The shiny output object.
#' @param session The shiny session object.
#' @param modules A character vector of paths to independent modules.
#' @param accordion_id The ID of the accordion element.
#' @export
shinypal_setup <- function(input, output, session, modules,
                           download_filename = "shinypal_script.zip") {
  # shared server objects ####
  # a shared expansion context for all expandChain() calls
  shinypal_env$shared_ec <- newExpansionContext()

  # a named list of quoted library() calls that go at the very top of the report
  # each element may also be a list of quoted calls that will be flattened
  # don't worry about duplicates, they will be filtered out
  shinypal_env$libraries_chain <- reactiveVal(list())

  # a named list of quoted code bits that will go after the libraries are loaded
  # each element may also be a list of quoted code bits that will be flattened
  shinypal_env$code_chain <- reactiveVal(list())

  # ordered, named list of elements in the report
  shinypal_env$report_list <- reactiveVal(tagList())
  # unordered, named list of intermediate variables that need to be global for
  # assembly of the markdown file
  shinypal_env$intermediate_list <- reactiveValues()

  # render dynamic UI ####
  # add libraries to load at the beginning of the report
  output$libraries <- renderPrint({
    inject(expandChain(
      !!!shinypal_env$libraries_chain() |>
        unname() |>
        list_flatten() |>
        unique()
    ))
  })

  # render the report
  output$report <- renderUI({
    tagList(
      div(
        verbatimTextOutput("libraries"),
        actionButton("copy_libraries", icon("copy")),
        class = "code_wrapper"
      ),
      shinypal_env$report_list()
    )
  })
  observeEvent(input$copy_libraries, {
    write_clip(
      inject(expandChain(
        !!!shinypal_env$libraries_chain() |>
          unname() |>
          list_flatten() |>
          unique()
      )),
      allow_non_interactive = TRUE
    )
  })

  # handle workflow reordering
  observeEvent(input$.workflow_sortable, {
    new_order <- isolate(input$.workflow_sortable)
    tmp_list <- shinypal_env$report_list()
    shinypal_env$report_list(tmp_list[new_order])
    tmp_list <- shinypal_env$code_chain()
    shinypal_env$code_chain(tmp_list[new_order])
  }, ignoreInit = TRUE)

  # report download ####
  # handle downloading a zip folder with the markdown script and rendered files
  output$download_script <- downloadHandler(
    filename = download_filename,
    content = function(file) {
      buildRmdBundle(
        "./modules/test_report.qmd",
        file,
        vars = list(
          # lists of quoted code bits, need to be injected into expandChain()
          libraries = inject(
            expandChain(
              !!!shinypal_env$libraries_chain() |>
                unname() |>
                list_flatten() |>
                unique()
            )),
          code = inject(
            expandChain(
              !!!shinypal_env$code_chain() |>
                unname() |>
                list_flatten()
            ))
        ),
        render_args = list(output_format = c("html_document", "pdf_document"))
      )
    }
  )

  # observers ####
  observeEvent(input$.clear_steps, {
    sapply(names(shinypal_env$report_list()), function(el) {
      accordion_panel_remove(".workflow_accordion", target = el)
    })
    shinypal_env$report_list(tagList())
    shinypal_env$code_chain(list())
    shinypal_env$libraries_chain(list())
    for (name in names(reactiveValuesToList(shinypal_env$intermediate_list))) {
      shinypal_env$intermediate_list[[name]] <- NULL
    }
    updateNumericInput(inputId = ".accordion_version", value = "1")
  }, ignoreInit = TRUE)

  observeEvent(input$.close_steps, {
    accordion_panel_close(".workflow_accordion", values = TRUE)
  }, ignoreInit = TRUE)

  # load the dynamic bits for each module (ui-aux.R and server.R)
  # make sure local = TRUE so they all share a namespace with the main app
  sapply(modules, FUN = function(module) {
    ui_aux_file <- file.path(module, "ui-aux.R")
    if (file.exists(ui_aux_file)) source(ui_aux_file, local = TRUE)
    server_file <- file.path(module, "server.R")
    if (file.exists(server_file)) source(server_file, local = TRUE)
  })

  shinypal_env$setup <- TRUE
}
