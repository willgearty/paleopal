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
library(dplyr)
library(htmltools)
library(fontawesome)
library(bslib)
library(shinymeta)

# libraries for data handling/viz
library(dplyr)
library(ggplot2)

# paleo libraries
# require curl which can't be used for shinylive apps
library(paleobioDB)
library(palaeoverse)
library(deeptime)

# load modules
app_mods <- list.files("./modules", pattern = "*.R", full.names = TRUE)
sapply(app_mods, FUN = source)
