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
  page_navbar(
    theme = bs_theme(version = 5, preset="bootstrap"),
    fillable_mobile = TRUE,
    ## title ----
    title= 'paleopal',
    ## panels ----
    nav_panel(
      "Conduct an Analysis",
      layout_sidebar(
        test_module_ui_main(),
        sidebar = sidebar(
          verbatimTextOutput("libraries"),
          test_module_ui_report(),
          title = "Report",
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
