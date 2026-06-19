# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step
# the function names should be prefaced with some representing of the module
# name/number to keep them unique

# workflow elements ####
mod02_ui_option_1 <- function(ind) {
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      HTML(paste(icon("copy", class = "fa-solid"), "Remove duplicate rows")),
      select_dataset_input(ind),
      df_modal_button(ind)
    )
  )
}

mod02_ui_option_2 <- function(ind) {
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      HTML(paste(icon("filter"), "Filter by a specific column")),
      select_dataset_input(ind),
      select_column_input(ind),
      textInput(paste0("text_", ind), "Enter a value to filter by:"),
      df_modal_button(ind)
    )
  )
}

mod02_ui_option_3 <- function(ind) {
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      HTML(paste(icon("calculator"), "Calculate a new column")),
      select_dataset_input(ind),
      selectInput(paste0("mutate_mode_", ind), "Type of calculation:",
                  choices = c("Transform one column" = "unary",
                              "Combine two columns" = "binary"),
                  selected = "unary"),
      conditionalPanel(
        condition = paste0("input.mutate_mode_", ind, " == 'unary'"),
        select_column_input(ind, "Column to transform:"),
        selectInput(paste0("transform_", ind), "Transformation:",
                    choices = c("Natural log (log)" = "log",
                                "Log base 10 (log10)" = "log10",
                                "Square root (sqrt)" = "sqrt",
                                "Absolute value (abs)" = "abs",
                                "To factor (as.factor)" = "as.factor",
                                "To number (as.numeric)" = "as.numeric",
                                "To text (as.character)" = "as.character"),
                    selected = "log")
      ),
      conditionalPanel(
        condition = paste0("input.mutate_mode_", ind, " == 'binary'"),
        select_column_input(paste0(ind, "_1"), "First column:"),
        selectInput(paste0("operator_", ind), "Operation:",
                    choices = c("Mean ((a + b) / 2)" = "mean",
                                "Sum (a + b)" = "+",
                                "Difference (a - b)" = "-",
                                "Product (a * b)" = "*",
                                "Ratio (a / b)" = "/"),
                    selected = "mean"),
        select_column_input(paste0(ind, "_2"), "Second column:")
      ),
      textInput(paste0("name_", ind), "New column name (optional):",
                placeholder = "e.g. mid_ma"),
      df_modal_button(ind)
    )
  )
}

mod02_ui_option_4 <- function(ind) {
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      HTML(paste(icon("compress"), "Summarize by group")),
      select_dataset_input(ind),
      select_column_input(paste0(ind, "_1"), "Group by:"),
      selectInput(paste0("stat_", ind), "Statistic:",
                  choices = c("Count" = "n",
                              "Mean" = "mean",
                              "Median" = "median",
                              "Sum" = "sum",
                              "Minimum" = "min",
                              "Maximum" = "max",
                              "Standard deviation" = "sd",
                              "Distinct count" = "n_distinct"),
                  selected = "n"),
      conditionalPanel(
        condition = paste0("input.stat_", ind, " != 'n'"),
        select_column_input(paste0(ind, "_2"), "Summarize which column:")
      ),
      textInput(paste0("name_", ind), "New column name (optional):",
                placeholder = "e.g. n_occurrences"),
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

mod02_report_option_3 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind)
    )
  )
}

mod02_report_option_4 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind)
    )
  )
}