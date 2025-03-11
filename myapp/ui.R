# paleopal by William Gearty

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

tagList(
  useShinyjs(),
  tags$head(
    tags$style(
      HTML(
        "#\\.accordion_version {
          display: none;
        }
        #\\.steps_card .accordion .card,
        #\\.steps_card .accordion .card-body,
        #\\.steps_card .accordion .card-header {
          padding: 0;
          margin: 0;
          border: 0;
        }
        .Reactable {
          max-height: 90vh;
          max-height: 80dvh;
        }
        pre.shiny-text-output {
          white-space: pre-wrap;
        }"
      )
    )
  ),
  page_navbar(
    theme = bs_theme(version = 5, preset="bootstrap"),
    fillable_mobile = TRUE,
    ## title ----
    title= 'paleopal',
    ## panels ----
    nav_panel(
      "Conduct an Analysis",
      layout_sidebar(
        layout_column_wrap(
          card(
            id = ".steps_card",
            card_header("Possible Workflow Steps"),
            accordion(
              !!!lapply(modules, function(module) {
                if (file.exists(file.path(module, "ui-main.R"))) {
                  source(file.path(module, "ui-main.R"))$value
                } else {
                  NULL
                }
              }),
              open = FALSE
            )
          ),
          card(
            card_header(tagList(
              "Workflow (click and drag to reorder)",
              div(
                actionButton(".close_steps", label = "Collapse all steps",
                             class = "btn-sm"),
                actionButton(".clear_steps", label = "Remove all steps",
                             class = "btn-sm"),
                class = "btn-group float-end"
              )
            )),
            accordion(id = ".workflow_accordion"),
            textInput(".accordion_version", label = NULL, value = "1"),
            sortable_js(".workflow_accordion",
                        options = sortable_options(
                          onSort =
                            sortable_js_capture_input(
                              input_id = ".workflow_sortable"
                            )
                        ))
          ),
          style = css(grid_template_columns = "1fr 2fr")
        ),
        sidebar = sidebar(
          downloadButton("download_script", "Download script"),
          uiOutput("report"),
          width = "30%", position = "right"
        )
      )
    ),
    nav_panel(
      "About",
      p("This was made with love by William Gearty")
    )
  )
)
