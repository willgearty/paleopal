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

# Cache the borders("world") layer so repeat calls in the live app reuse it
local({
  cache <- new.env(parent = emptyenv())
  cached_borders <- function(database = "world", regions = ".", ...) {
    key <- paste(database, regions,
                 paste(deparse(list(...)), collapse = ""), sep = "\r")
    if (is.null(cache[[key]])) {
      cache[[key]] <- ggplot2::borders(database, regions, ...)
    }
    cache[[key]]
  }
  assign("borders", cached_borders, envir = globalenv())
})

reefs <- readRDS("data/reefs.RDS")
tetrapods <- readRDS("data/tetrapods.RDS")

is_shinylive <- function() { R.Version()$os == "emscripten" }

# paleo libraries
# require curl which can't be used for shinylive apps
if(!is_shinylive()) library(paleobioDB)
#library(deeptime)

# get list of module directories
# modules should be listed in the order they will be loaded (prepend numbers)
modules <- list.dirs("./modules/", recursive = FALSE)
