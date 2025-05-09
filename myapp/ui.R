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
      p("This was made with love by William Gearty")
    ),
    nav_spacer(),
    nav_item(input_dark_mode())
  )
)
