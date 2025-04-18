# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step

# workflow elements ####
mod03_ui_option_1 <- function(ind) {
  df_names <- get_int_dfs(ind)
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      "Plot data on a map",
      select_dataset_input(ind),
      select_column_input(paste0(ind, "_1"), "Choose a longitude column:",
                          "lng"),
      select_column_input(paste0(ind, "_2"), "Choose a latitude column:",
                          "lat")
    )
  )
}

# report elements ####
mod03_report_option_1 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind),
      plotOutput(paste0("map_", ind))
    )
  )
}
