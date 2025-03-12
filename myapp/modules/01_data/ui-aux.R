# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step

# workflow elements ####
mod01_ui_option_1 <- function(ind) {
  tagList(
    accordion_panel_paleopal(
      ind = ind,
      "Upload occurrence data",
      fileInput(paste0("file_", ind), "Choose a .csv file:", accept = ".csv"),
      numericInput(paste0("num_rows_", ind), "Number of rows to skip:",
                   value = 0, min = 0),
      df_modal_button(ind)
    )
  )
}

mod01_ui_option_2 <- function(ind) {
  tagList(
    accordion_panel_paleopal(
      ind = ind,
      "Download occurrence data from the PBDB",
      selectInput(paste0("genus_", ind), "Choose a genus:",
                  choices = c("Tyrannosaurus", "Dimetrodon")),
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
