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
          test_module_ui_main(),
          actionButton(".remove_step", "Remove last step")
        ),
        card(
          card_header("Workflow"),
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
