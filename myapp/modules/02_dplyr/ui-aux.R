# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step
# the function names should be prefaced with some representing of the module
# name/number to keep them unique

# workflow elements ####
mod02_ui_option_1 <- function(ind) {
  df_names <- get_int_dfs(ind)
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      "Remove duplicate rows",
      select_dataset_input(ind),
      df_modal_button(ind)
    )
  )
}

mod02_ui_option_2 <- function(ind) {
  df_names <- get_int_dfs(ind)
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      "Filter by a specific column",
      select_dataset_input(ind),
      select_column_input(ind),
      textInput(paste0("text_", ind), "Enter a value to filter by:"),
      df_modal_button(ind)
    )
  )
}

# report elements ####
mod02_report_option_1 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind)
    )
  )
}

mod02_report_option_2 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind)
    )
  )
}