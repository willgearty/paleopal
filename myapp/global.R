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
library(shinypal)
library(shiny)
library(fontawesome)
library(bslib)
library(shinymeta)
library(sortable)
library(shinycssloaders)

# libraries for data handling/viz
library(dplyr)
library(munsell)
library(ggplot2)

# for code injection
library(rlang)

reefs <- readRDS("data/reefs.RDS")
tetrapods <- readRDS("data/tetrapods.RDS")

is_shinylive <- function() { R.Version()$os == "emscripten" }

# paleo libraries
# require curl which can't be used for shinylive apps
if(!is_shinylive()) library(paleobioDB)
#library(deeptime)

# fixes downloads with shinylive on Chrome: https://github.com/posit-dev/r-shinylive/issues/74
downloadButton <- function(...) {
  tag <- shiny::downloadButton(...)
  tag$attribs$download <- NULL
  tag
}

# get list of module directories
# modules should be listed in the order they will be loaded (prepend numbers)
modules <- list.dirs("./modules/", recursive = FALSE)
