# this file should include a single UI element that represents all of the
# options for this module
# it should probably be an accordion_panel() that wraps a card() that contains
# one or more actionButton()s

btn1 <- actionButton("mod01_add_option_1",
                     HTML(paste(icon("upload"), "Upload occurrence data")))
btn2 <- actionButton("mod01_add_option_2",
                     HTML(paste(icon("download"),
                                "Download occurrence data from the PBDB")))

accordion_panel(
  title = "Add Data",
  if (is_shinylive()) card(btn1) else card(btn1, btn2)
)
