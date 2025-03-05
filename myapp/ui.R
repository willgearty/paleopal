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
        #rank-list-\\.sortable, #\\.sortable, #\\.sortable .rank-list-item {
          padding: 0;
          border: 0;
          margin: 0;
          background-color: transparent;
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
        card(
          card_header("Workflow Steps"),
          test_module_ui_main()
        ),
        card(
          card_header("Workflow (click and drag to reorder)"),
          uiOutput("workflow"),
          textInput(".accordion_version", label = NULL, value = "0")
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
