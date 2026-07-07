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
  tags$head(
    tags$script(src = "app.js"),
    tags$link(rel = "stylesheet", href = "welcome.css"),
    # Brand fonts (IBM Plex Sans for text, IBM Plex Mono for code); delivered
    # via Google Fonts so they load in the browser-only shinylive build, where
    # webR can't download fonts at theme-compile time
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&family=IBM+Plex+Sans:wght@400;500;600&display=swap"
    )
  ),
  page_navbar(
    id = "tabs",
    theme = bs_theme(version = 5, preset = "bootstrap", brand = TRUE),
    fillable_mobile = TRUE,
    ## title ----
    # brand wordmark in the navbar
    title = img(src = "full_logo.png", alt = "paleopal", class = "navbar-logo"),
    # land on the Welcome panel so the app matches the loading splash on startup
    selected = "welcome",
    ## panels ----
    nav_panel(
      "Welcome",
      value = "welcome",
      div(
        class = "welcome-hero",
        # keep this hero in sync with loading.html so the loading splash and
        # this panel look identical (only the nav items differ once loaded)
        img(src = "logo_tagline.png",
            alt = "paleopal \u2014 learn \u00b7 teach \u00b7 reproduce",
            class = "welcome-logo"),
        p(HTML("Assemble a paleobiological data science workflow step by step: import occurrence data, clean and summarize it, and build figures. <strong>paleopal</strong> writes the equivalent reproducible R script for you to download, with nothing to install."),
          class = "welcome-desc"),
        p(HTML("Open the <strong>Conduct an Analysis</strong> tab to get started."),
          class = "welcome-cue")
      )
    ),
    nav_panel(
      "Conduct an Analysis",
      value = "analysis",
      shinypal_ui(modules)
    ),
    nav_panel(
      "About",
      value = "about",
      p(HTML("This was made with love by <a href='https://github.com/willgearty' target = '_blank'>William Gearty</a>")),
      p(HTML("The source code for the <strong>paleopal</strong> Shiny app is available <a href='https://github.com/willgearty/paleopal' target = '_blank'>on GitHub</a>. This app is built using the <a href='https://github.com/willgearty/shinypal' target = '_blank'>shinypal framework</a> and hosted as a <a href='https://docs.r-wasm.org/' target = '_blank'>webr package</a> with GitHub pages using the <a href='https://posit-dev.github.io/r-shinylive/' target = '_blank'>shinylive package</a>."))
    ),
    nav_spacer(),
    nav_item(input_dark_mode())
  )
)
