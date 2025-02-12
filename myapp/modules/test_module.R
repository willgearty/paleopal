test_module_ui <- function(id) {
  card(
    card_header("Analyis"),
    accordion(
      id = NS(id, "analysis"),
      multiple = FALSE, open = c("Data Download"),
      accordion_panel(
        "Data Download",
        p("This is the first step"),
        selectInput(NS(id, "genus"), "Choose a genus:",
                    choices = c("Tyrannosaurus", "Dimetrodon")),
        plotOutput(NS(id, "map")),
        verbatimTextOutput(NS(id, "code"))
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
  )
}

test_module_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    occs <- metaReactive2({
      req(input$genus)
      isolate(metaExpr({
        pbdb_occurrences(taxon_name = ..(input$genus),
                                 vocab = "pbdb", show = "coords")
      }))
    }, varname = "occs")
    # make a map of occs with ggplot
    output$map <- metaRender(renderPlot, {
      ggplot(..(occs()), aes(x = lng, y = lat)) +
        borders("world") +
        geom_point(color = "red") +
        coord_sf()
    })
    output$code <- renderPrint({
      expandChain(
        quote(library(tidyverse)),
        invisible(occs()),
        output$map()
      )
    })
  })
}