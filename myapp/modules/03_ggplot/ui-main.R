# this file should include a single UI element that represents all of the
# options for this module
# it should probably be an accordion_panel() that wraps a card() that contains
# one or more actionButton()s

accordion_panel(
  title = "Data Visualization",
  card(
    actionButton(".mod03_add_option_1", "Plot data on a map")
  )
)
