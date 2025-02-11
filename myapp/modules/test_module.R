test_module_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    "Conduct an Analysis",
    layout_column_wrap(
      width = NULL, height = 300,
      style = css(grid_template_columns = "3fr 2fr"),
      card(
        card_header("Analyis"),
        accordion(
          id = "analysis",
          multiple = FALSE, open = c("Data Download"),
          accordion_panel(
            "Data Download",
            p("This is the first step"),
            selectInput("genus", "Choose a genus:",
                        choices = c("Tyrannosaurus", "Dimetrodon"))
          ),
          accordion_panel(
            "Step 2",
            p("This is the second step"),
            selectInput("dataset", "Choose a dataset:", choices = c("mtcars", "iris"))
          ),
          accordion_panel(
            "Step 3",
            p("This is the third step"),
            selectInput("dataset", "Choose a dataset:", choices = c("mtcars", "iris"))
          )
        )
      ),
      card2 <- card(
        card_header("Report"),
        includeMarkdown("./modules/test_report.qmd")
      )
    )
  )
}

test_module_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    return(reactive({
      input$dataset
    }))
  })
}