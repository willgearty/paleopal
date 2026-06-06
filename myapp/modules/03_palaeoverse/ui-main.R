# this file should include a single UI element that represents all of the
# options for this module
# it should probably be an accordion_panel() that wraps a card() that contains
# one or more actionButton()s

accordion_panel(
  title = "Paleobiology Tools",
  card(
    actionButton("mod04_add_option_1",
                 HTML(paste(icon("layer-group", class = "fa-solid"),
                            "Assign data to time bins")))
  )
)
