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
        "#accordion_version {
          display: none;
        }
        #steps_card .accordion .card,
        #steps_card .accordion .card-body,
        #steps_card .accordion .card-header {
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
        }
        .code_wrapper {
          position: relative;
          button {
            position: absolute;
            top: 5px;
            right: 5px;
            opacity: 0%;
            transition: all ease 0.5s;
          }
        }
        .code_wrapper:hover {
          button {
            opacity: 100%;
          }
        }"
      )
    )
  ),
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
