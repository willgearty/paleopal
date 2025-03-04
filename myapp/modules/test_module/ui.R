test_module_ui_option_1 <- function(ind) {
  tagList(
    accordion_panel_paleopal(ind = ind,
      "Rule 1: Identify your taxonomic scope",
      p("This is the first step"),
      selectInput(paste0("genus_", ind), "Choose a genus:",
                  choices = c("Tyrannosaurus", "Dimetrodon"))
    )
  )
}

test_module_ui_option_2 <- function(ind) {
  tagList(
    accordion_panel_paleopal(ind = ind,
      "Rule 2: Keep raw data raw",
      p("This is the second step"),
      selectInput(paste0("dataset_", ind), "Choose a dataset:", choices = c("mtcars", "iris"))
    )
  )
}

test_module_ui_option_3 <- function(ind) {
  tagList(
    accordion_panel_paleopal(ind = ind,
      "Step 3",
      p("This is the third step"),
      selectInput(paste0("dataset2_", ind), "Choose a dataset:", choices = c("mtcars", "iris"))
    )
  )
}

test_module_ui_main <- function() {
  tagList(
    actionButton(".add_option_1", "Download data"),
    actionButton(".add_option_2", "Save the data"),
    actionButton(".add_option_3", "Explore the data"),
  )
}

test_module_report_option_1 <- function(ind) {
  tagList(
    div(
      verbatimTextOutput(paste0("code_", ind)),
      plotOutput(paste0("map_", ind))
    )
  )
}

test_module_report_option_2 <- function(ind) {
  tagList(
    div(
      textOutput(paste0("text_", ind))
    )
  )
}

test_module_report_option_3 <- function(ind) {
  tagList(
    div(
      textOutput(paste0("text_", ind))
    )
  )
}
