# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step

# workflow elements ####
mod03_ui_option_1 <- function(ind) {
  df_names <- get_int_dfs()
  tagList(
    accordion_panel_paleopal(
      ind = ind,
      "Plot data on a map",
      p("This is the second step"),
      select_dataset_input(ind),
      select_column_input(ind, "Choose a latitude column:"),
      select_column_input(ind, "Choose a longitude column:")
    )
  )
}

# report elements ####
mod03_report_option_1 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput(paste0("code_", ind)),
      plotOutput(paste0("map_", ind))
    )
  )
}
