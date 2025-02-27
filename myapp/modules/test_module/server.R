# add libraries to load at the beginning of the report
libraries_chain <- append(libraries_chain, quote(quote(library(paleobioDB))))

# handle adding the first option
observeEvent(input$add_option_1, {
  ind <- length(workflow_list()) + 1

  # build reactive expressions for each instance of this component
  occs <- metaReactive2({
    req(input[[paste0("genus_", ind)]])
    isolate(metaExpr({
      pbdb_occurrences(taxon_name = ..(input[[paste0("genus_", ind)]]),
                       vocab = "pbdb", show = "coords")
    }))
  }, varname = "occs")
  # make a map of occs with ggplot
  output[[paste0("map_", ind)]] <- metaRender(renderPlot, {
    ggplot(..(occs()), aes(x = lng, y = lat)) +
      borders("world") +
      geom_point(color = "red") +
      coord_sf()
  })
  output[[paste0("code_", ind)]] <- renderPrint({
    expandChain(
      invisible(occs()),
      output[[paste0("map_", ind)]]()
    )
  })

  workflow_list(append(workflow_list(),
                       test_module_ui_option_1(ind)))
  report_list(append(report_list(), test_module_ui_report(ind)))
  code_chain <- append(code_chain, quote(invisible(occs())))
  code_chain <- append(code_chain, quote(c()))
  code_chain <- append(code_chain, quote(output[[paste0("map_", ind)]]()))
}, ignoreInit = TRUE)

# handle adding the second option
observeEvent(input$add_option_2, {
  ind <- length(workflow_list()) + 1
  workflow_list(append(workflow_list(), test_module_ui_option_2(ind)))
}, ignoreInit = TRUE)

# handle adding the third option
observeEvent(input$add_option_3, {
  ind <- length(workflow_list()) + 1
  workflow_list(append(workflow_list(), test_module_ui_option_3(ind)))
}, ignoreInit = TRUE)
