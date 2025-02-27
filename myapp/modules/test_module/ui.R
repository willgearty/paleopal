test_module_ui_option_1 <- function(id) {
  tagList(
    accordion_panel(
      "Rule 1: Identify your taxonomic scope",
      p("This is the first step"),
      selectInput(paste0("genus_", id), "Choose a genus:",
                  choices = c("Tyrannosaurus", "Dimetrodon")),
    )
  )
}

test_module_ui_option_2 <- function(id) {
  tagList(
    accordion_panel(
      "Rule 2: Keep raw data raw",
      p("This is the second step"),
      selectInput(paste0("dataset_", id), "Choose a dataset:", choices = c("mtcars", "iris"))
    )
  )
}

test_module_ui_option_3 <- function(id) {
  tagList(
    accordion_panel(
      "Step 3",
      p("This is the third step"),
      selectInput(paste0("dataset2_", id), "Choose a dataset:", choices = c("mtcars", "iris"))
    )
  )
}

test_module_ui_main <- function() {
  tagList(
    actionButton("add_option_1", "Download data"),
    actionButton("add_option_2", "Save the data"),
    actionButton("add_option_3", "Explore the data"),
  )
}

test_module_ui_report <- function(id) {
  tagList(
    div(
      verbatimTextOutput(paste0("code_", id)),
      plotOutput(paste0("map_", id))
    )
  )
}