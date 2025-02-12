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
        test_module_ui("test_module"),
        sidebar = sidebar(
          card(
            includeMarkdown("./modules/test_report.qmd")
          ),
          title = "Report",
          width = "40%", position = "right"
        )
      )
    ),
    nav_panel(
      "About",
      p("This was made with love by William Gearty")
    )
  )
)
