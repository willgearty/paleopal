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
library(reactable)

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

# get list of module directories
# modules should be listed in the order they will be loaded (prepend numbers)
modules <- list.dirs("./modules/", recursive = FALSE)
