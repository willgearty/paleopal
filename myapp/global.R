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
library(brand.yml)
library(shinymeta)
library(sortable)
library(shinycssloaders)

# for code injection
library(rlang)

# webR/shinylive's recursion budget is far shallower than desktop R's
if (is_shinylive()) options(expressions = 5e4)

# libraries for data handling/viz
library(dplyr)
library(munsell)
library(ggplot2)

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

# paleo libraries
# deeptime imports grImport2, which imports XML, which has no webR/WASM build
deeptime_available <- !is_shinylive() && requireNamespace("deeptime", quietly = TRUE)
if (deeptime_available) library(deeptime)
library(palaeoverse)

reefs <- readRDS("data/reefs.RDS")
tetrapods <- readRDS("data/tetrapods.RDS")

# paleobioDB requires curl, which isn't available in shinylive apps
pbdb_available <- !is_shinylive() && requireNamespace("paleobioDB", quietly = TRUE)
if (pbdb_available) library(paleobioDB)

# get list of module directories
# modules should be listed in the order they will be loaded (prepend numbers)
modules <- list.dirs("./modules/", recursive = FALSE)
