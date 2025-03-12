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
  # a named list of quoted library() calls that go at the very top of the report
  # each element may also be a list of quoted calls that will be flattened
  # don't worry about duplicates, they will be filtered out
  libraries_chain <- reactiveVal(list())

  # a named list of quoted code bits that will go after the libraries are loaded
  # each element may also be a list of quoted code bits that will be flattened
  code_chain <- reactiveVal(list())

  # ordered, named list of elements in the report
  report_list <- reactiveVal(tagList())
  # unordered, named list of intermediate variables that need to be global for
  # assembly of the markdown file
  intermediate_list <- reactiveValues()

  # common server functions ####
  # add a step to the report, workflow, and the code chain
  # fun_workflow is the function that generates the UI elements for the workflow
  # fun_report is the function that generates the UI elements for the report
  # code_chain_list is a list of quoted code bits that will be added to code_chain()
  # libs is a character vector of R packages required for this step
  add_step <- function(ind, fun_workflow, fun_report, code_chain_list, libs) {
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

    # add the packages to the libraries chain
    tmp_list <- libraries_chain()
    tmp_list[[paste0("step_", ind)]] <-
      lapply(libs, function(lib) inject(quote(quote(library(!!lib)))))
    libraries_chain(tmp_list)

    # handle removing this step from the report and workflow
    observeEvent(input[[paste0(".remove_step_", ind)]], {
      accordion_panel_remove(".workflow_accordion",
                             target = paste0("step_", ind))
      for (fun in c(report_list, code_chain, libraries_chain)) {
        tmp_list <- fun()
        tmp_list[[paste0("step_", ind)]] <- NULL
        fun(tmp_list)
      }
      # remove any intermediate objects for this step
      for (name in grep(paste0("*_", ind),
                        names(reactiveValuesToList(intermediate_list)),
                        value = TRUE)) {
        intermediate_list[[name]] <- NULL
      }
    }, ignoreInit = TRUE)
    updateTextInput(inputId = ".accordion_version",
                    value =
                      as.numeric(isolate(input$.accordion_version)) + 1)
  }

  # get the names of all intermediate data.frames
  get_int_dfs <- function(ind) {
    lst <- reactiveValuesToList(intermediate_list)
    lst[!grepl(paste0("_", ind), names(lst))] |>
      Filter(f = Negate(is.null)) |>
      Filter(f = function(el) is.data.frame(el())) |>
      names()
  }

  # show a modal with a reactable data.frame
  show_df_modal <- function(ind, df_name) {
    showModal(modalDialog(
      reactableOutput(paste0("df_", ind)), size = "l", easyClose = TRUE
    ))
    output[[paste0("df_", ind)]] <- renderReactable({
      reactable(isolate(intermediate_list[[df_name]]()),
                defaultColDef = colDef(
                  cell = function(value) format(value, nsmall = 1),
                  align = "center",
                  minWidth = 150,
                  headerStyle = list(background = "#f7f7f8", cursor = "pointer")
                ),
                defaultPageSize = 25)
    })
  }

  # observers ####
  observeEvent(input$.clear_steps, {
    sapply(names(report_list()), function(el) {
      accordion_panel_remove(".workflow_accordion", target = el)
    })
    report_list(tagList())
    code_chain(list())
    libraries_chain(list())
    for (name in names(reactiveValuesToList(intermediate_list))) {
      intermediate_list[[name]] <- NULL
    }
  }, ignoreInit = TRUE)

  observeEvent(input$.close_steps, {
    accordion_panel_close(".workflow_accordion", values = TRUE)
  }, ignoreInit = TRUE)

  # source module files ####
  # source common UI elements first
  source("ui-common.R", local = TRUE)
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
    inject(expandChain(
      !!!libraries_chain() |>
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
      report_list()
    )
  })
  observeEvent(input$copy_libraries, {
    write_clip(
      inject(expandChain(
        !!!libraries_chain() |>
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
          libraries = inject(
            expandChain(
              !!!libraries_chain() |>
                unname() |>
                list_flatten() |>
                unique()
          )),
          code = inject(
            expandChain(
              !!!code_chain() |>
                unname() |>
                list_flatten()
          ))
        ),
        render_args = list(output_format = c("html_document", "pdf_document"))
      )
    }
  )
}
