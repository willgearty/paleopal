# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step
# the function names should be prefaced with some representing of the module
# name/number to keep them unique

# workflow elements ####
mod04_ui_option_1 <- function(ind) {
  tagList(
    accordion_panel_remove_button(
      ind = ind,
      HTML(paste(icon("layer-group"), "Assign data to time bins")),
      select_dataset_input(ind),
      select_column_input(paste0(ind, "_1"), "Maximum age column (Ma):",
                          "max_ma"),
      select_column_input(paste0(ind, "_2"), "Minimum age column (Ma):",
                          "min_ma"),
      selectInput(paste0("rank_", ind), "Time bin resolution:",
                  choices = c("Stage" = "stage",
                              "Epoch" = "epoch",
                              "Period" = "period",
                              "Era" = "era",
                              "Eon" = "eon"),
                  selected = "stage"),
      selectInput(paste0("method_", ind), "Binning method:",
                  choices = c("Midpoint" = "mid",
                              "Majority overlap" = "majority",
                              "All overlapping bins" = "all"),
                  selected = "mid"),
      df_modal_button(ind)
    )
  )
}

# report elements ####
mod04_report_option_1 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput_copy(ind)
    )
  )
}
