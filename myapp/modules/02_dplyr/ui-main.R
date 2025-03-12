# this file should include a single UI element that represents all of the
# options for this module
# it should probably be an accordion_panel() that wraps a card() that contains
# one or more actionButton()s

accordion_panel(
  title = "Clean Data",
  card(
    actionButton(".mod02_add_option_1", "Remove duplicate rows"),
    actionButton(".mod02_add_option_2", "Filter by a specific column")
  )
)
