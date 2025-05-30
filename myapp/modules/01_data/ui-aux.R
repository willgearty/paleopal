# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step

# workflow elements ####
mod01_ui_option_1 <- function(ind) {
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      "Use occurrence data from the palaeoverse package",
      p(HTML("You can choose between occurrence data for Panerozoic reefs ('reefs', <a href='https://palaeoverse.palaeoverse.org/reference/reefs.html' target = '_blank'>more details here</a>) and occurrence data for early tetrapods ('tetrapods', <a href='https://palaeoverse.palaeoverse.org/reference/reefs.html' target = '_blank'>more details here</a>).")),
      selectInput(paste0("palaeoverse_", ind), "Choose a dataset:",
                  choices = c("reefs", "tetrapods")),
      df_modal_button(ind)
    )
  )
}

mod01_ui_option_2 <- function(ind) {
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      "Download occurrence data from the PBDB",
      selectInput(paste0("genus_", ind), "Choose a genus:",
                  choices = c("Tyrannosaurus", "Dimetrodon")),
      df_modal_button(ind)
    )
  )
}

mod01_ui_option_3 <- function(ind) {
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      "Upload occurrence data",
      fileInput(paste0("file1_", ind), "Choose a .csv file:", accept = ".csv"),
      numericInput(paste0("num_rows_", ind), "Number of rows to skip:",
                   value = 0, min = 0),
      df_modal_button(ind)
    )
  )
}

# report elements ####
mod01_report_option_1 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind)
    )
  )
}
mod01_report_option_2 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind)
    )
  )
}

mod01_report_option_3 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind)
    )
  )
}
