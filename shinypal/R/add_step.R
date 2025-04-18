#' @title Add a step to the report, workflow, and the code chain
#' @description
#'   A short description...
#' @param input The input object from the shiny app.
#' @param ind The index of the step to be added.
#' @param fun_workflow A function that generates the UI elements for the
#'   workflow.
#' @param fun_report A function that generates the UI elements for the report.
#' @param code_chain_list A list of quoted code bits that will be added to
#'   code_chain().
#' @param libs A character vector of R packages required for this step.
#' @importFrom shiny req isolate observeEvent updateNumericInput
#' @importFrom shiny reactiveValuesToList
#' @importFrom bslib accordion_panel_insert accordion_panel_open
#' @importFrom bslib accordion_panel_remove
#' @importFrom rlang inject !!
#' @export
add_shinypal_step <- function(input, ind, fun_workflow, fun_report,
                              code_chain_list, libs) {
  check_setup()
  # this is broken for some reason???
  #req(input, ind, fun_workflow, fun_report, code_chain_list, libs)
  # add the UI elements to the workflow
  accordion_panel_insert(".workflow_accordion", panel = fun_workflow(ind))
  accordion_panel_open(".workflow_accordion", values = paste0("step_", ind))

  # add the UI elements to the report
  tmp_list <- shinypal_env$report_list()
  tmp_list[[paste0("step_", ind)]] <- fun_report(ind)
  shinypal_env$report_list(tmp_list)

  # add the code to the code chain
  tmp_list <- shinypal_env$code_chain()
  tmp_list[[paste0("step_", ind)]] <- code_chain_list
  shinypal_env$code_chain(tmp_list)

  # add the packages to the libraries chain
  tmp_list <- shinypal_env$libraries_chain()
  tmp_list[[paste0("step_", ind)]] <-
    lapply(libs, function(lib) inject(quote(quote(library(!!lib)))))
  shinypal_env$libraries_chain(tmp_list)

  # handle removing this step from the report and workflow
  observeEvent(input[[paste0(".remove_step_", ind)]], {
    accordion_panel_remove(".workflow_accordion",
                           target = paste0("step_", ind))
    for (fun in c(shinypal_env$report_list,
                  shinypal_env$code_chain,
                  shinypal_env$libraries_chain)) {
      tmp_list <- fun()
      tmp_list[[paste0("step_", ind)]] <- NULL
      fun(tmp_list)
    }
    # remove any intermediate objects for this step
    for (name in grep(paste0("*_", ind),
                      names(reactiveValuesToList(
                        shinypal_env$intermediate_list
                      )),
                      value = TRUE)) {
      shinypal_env$intermediate_list[[name]] <- NULL
    }
  }, ignoreInit = TRUE)
  updateNumericInput(inputId = ".accordion_version",
                     value =
                       isolate(input$.accordion_version) + 1)
}
