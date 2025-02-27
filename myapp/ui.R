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
        actionButton("add_step", "Add step"),
        actionButton("remove_step", "Remove step"),
        uiOutput("pipeline"),
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
