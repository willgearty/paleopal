# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step
# the function names should be prefaced with some representing of the module
# name/number to keep them unique

# workflow elements ####

mod02_ui_option_1 <- function(ind) {
  df_names <- get_int_dfs()
  tagList(
    accordion_panel_paleopal(
      ind = ind,
      "Filter by a specific column",
      p("This is the second step"),
      select_dataset_input(ind),
      select_column_input(ind)
    )
  )
}

mod02_ui_option_2 <- function(ind) {
  tagList(
    accordion_panel_paleopal(
      ind = ind,
      "Step 3",
      p("Remove duplicate rows"),
      selectInput(paste0("dataset_", ind), "Choose a dataset:",
                  choices = get_int_dfs())
    )
  )
}

# report elements ####
mod02_report_option_1 <- function(ind) {
  tagList(
    div(
      textOutput(paste0("text_", ind))
    )
  )
}

mod02_report_option_2 <- function(ind) {
  tagList(
    div(
      textOutput(paste0("text_", ind))
    )
  )
}