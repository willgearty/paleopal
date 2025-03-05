# paleopal by William Gearty

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# libraries for the UI
library(shiny)
library(shinyjs)
library(htmltools)
library(fontawesome)
library(bslib)
library(shinymeta)
library(sortable)

# libraries for data handling/viz
library(dplyr)
library(ggplot2)
library(rlang)
library(purrr)

# paleo libraries
# require curl which can't be used for shinylive apps
library(paleobioDB)
library(palaeoverse)
library(deeptime)

# load UI components of modules
app_mods <- list.files("./modules", pattern = "*ui.R", full.names = TRUE, recursive = TRUE)
sapply(app_mods, FUN = source)

# common UI components ####

# a version of the accordion panel that includes a remove button
accordion_panel_paleopal <- function(ind, ...) {
  tmp <- accordion_panel(
    ...,
    actionButton(paste0(".remove_step_", ind), "Remove this step"),
    value = paste0("step_", ind)
  )
  # need this attribute for sortable_js_capture_input
  tmp$attribs$`data-rank-id` <- paste0("step_", ind)
  tmp
}
