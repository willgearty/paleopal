# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step

# workflow elements ####
mod01_ui_option_1 <- function(ind) {
  tagList(
    accordion_panel_paleopal(
      ind = ind,
      "Download data from the PBDB",
      p("This is the first step"),
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
