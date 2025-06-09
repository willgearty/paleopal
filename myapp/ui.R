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
  page_navbar(
    theme = bs_theme(version = 5, preset="bootstrap"),
    fillable_mobile = TRUE,
    ## title ----
    title = 'paleopal',
    ## panels ----
    nav_panel(
      "Conduct an Analysis",
      shinypal_ui(modules)
    ),
    nav_panel(
      "About",
      p(HTML("This was made with love by <a href='https://github.com/willgearty' target = '_blank'>William Gearty</a>")),
      p(HTML("The source code for the <strong>paleopal</strong> Shiny app is available <a href='https://github.com/willgearty/paleopal' target = '_blank'>on GitHub</a>. This app is built using the <a href='https://github.com/willgearty/shinypal' target = '_blank'>shinypal framework</a> and hosted as a <a href='https://docs.r-wasm.org/' target = '_blank'>webr package</a> with GitHub pages using the <a href='https://posit-dev.github.io/r-shinylive/' target = '_blank'>shinylive package</a>."))
    ),
    nav_spacer(),
    nav_item(input_dark_mode())
  )
)
