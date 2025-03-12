# this file should include a single UI element that represents all of the
# options for this module
# it should probably be an accordion_panel() that wraps a card() that contains
# one or more actionButton()s

accordion_panel(
  title = "Add Data",
  card(
    actionButton(".mod01_add_option_1", "Upload occurrence data"),
    actionButton(".mod01_add_option_2",
                 "Download occurrence data from the PBDB")
  )
)
