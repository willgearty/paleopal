# this file should include a single UI element that represents all of the
# options for this module
# it should probably be an accordion_panel() that wraps a card() that contains
# one or more actionButton()s

btn1 <- actionButton("mod01_add_option_1",
                     HTML(paste(icon("box-open"),
                                "Use an included occurrence dataset")))
btn2 <- actionButton("mod01_add_option_2",
                     HTML(paste(icon("download"),
                                "Download occurrence data from the PBDB")))
btn3 <- actionButton("mod01_add_option_3",
                     HTML(paste(icon("upload"), "Upload occurrence data")))

accordion_panel(
  title = "Add Data",
  if (is_shinylive()) card(btn1, btn3) else card(btn1, btn2, btn3)
)
