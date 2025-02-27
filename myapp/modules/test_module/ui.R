test_module_ui_main <- function() {
  card(
    card_header("Analyis"),
    accordion(
      id = "analysis",
      multiple = FALSE, open = c("Data Download"),
      accordion_panel(
        "Rule 1: Identify your taxonomic scope",
        p("This is the first step"),
        selectInput("genus", "Choose a genus:",
                    choices = c("Tyrannosaurus", "Dimetrodon")),
      ),
      accordion_panel(
        "Rule 2: Keep raw data raw",
        p("This is the second step"),
        selectInput("dataset", "Choose a dataset:", choices = c("mtcars", "iris"))
      ),
      accordion_panel(
        "Step 3",
        p("This is the third step"),
        selectInput("dataset", "Choose a dataset:", choices = c("mtcars", "iris"))
      )
    )
  )
}

test_module_ui_report <- function() {
  tagList(
    div(
      verbatimTextOutput("code1"),
      plotOutput("map1")
    )
  )
}