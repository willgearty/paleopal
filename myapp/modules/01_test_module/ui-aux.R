# this file should include functions that return the elements for the
# workflow and report UI
# each function should take a single argument which indicates the
# suffix index of the workflow step

# workflow elements ####
mod01_ui_option_1 <- function(ind) {
  tagList(
    accordion_panel_paleopal(
      ind = ind,
      "Rule 1: Identify your taxonomic scope",
      p("This is the first step"),
      selectInput(paste0("genus_", ind), "Choose a genus:",
                  choices = c("Tyrannosaurus", "Dimetrodon"))
    )
  )
}

# report elements ####
mod01_report_option_1 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput(paste0("code_", ind)),
      plotOutput(paste0("map_", ind))
    )
  )
}
