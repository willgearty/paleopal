# this file should include a single UI element that represents all of the
# options for this module
# it should probably be an accordion_panel() that wraps a card() that contains
# one or more actionButton()s

accordion_panel(
  title = "Data Visualization",
  card(
    actionButton("mod04_add_option_1",
                 HTML(paste(icon("chart-line", class = "fa-solid"),
                            "Make a scatterplot"))),
    actionButton("mod04_add_option_2",
                 HTML(paste(icon("map", class = "fa-solid"),
                            "Plot data on a map"))),
    actionButton("mod04_add_option_3",
                 HTML(paste(icon("hourglass-half", class = "fa-solid"),
                            "Plot data through time"))),
    actionButton("mod04_add_option_4",
                 HTML(paste(icon("chart-column", class = "fa-solid"),
                            "Make a box or violin plot")))
  )
)
