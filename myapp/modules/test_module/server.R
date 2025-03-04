# add libraries to load at the beginning of the report
libraries_chain <- append(libraries_chain, quote(quote(library(paleobioDB))))

# handle adding the first option
observeEvent(input$.add_option_1, {
  ind <- as.numeric(input$.accordion_version)

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  intermediate_list[[paste0("occs_", ind)]] <- metaReactive2({
    req(input[[paste0("genus_", ind)]])
    isolate(metaExpr({
      pbdb_occurrences(taxon_name = ..(input[[paste0("genus_", ind)]]),
                       vocab = "pbdb", show = "coords")
    }))
  }, varname = "occs")
  # make a map of occs with ggplot
  output[[paste0("map_", ind)]] <- metaRender(renderPlot, {
    ggplot(..(intermediate_list[[paste0("occs_", ind)]]()), aes(x = lng, y = lat)) +
      borders("world") +
      geom_point(color = "red") +
      coord_sf()
  })
  output[[paste0("code_", ind)]] <- renderPrint({
    expandChain(
      invisible(intermediate_list[[paste0("occs_", ind)]]()),
      output[[paste0("map_", ind)]]()
    )
  })

  # add the UI elements to the workflow and report
  add_step(test_module_ui_option_1, test_module_ui_report, ind)

  # add code components to the downloadable markdown
  # note that any local variables need to be injected with !!
  code_chain(append(code_chain(),
                    list(
                      inject(quote(invisible(intermediate_list[[paste0("occs_", !!ind)]]()))),
                      quote(c()),
                      inject(quote(output[[paste0("map_", !!ind)]]()))
                    )
  ))
}, ignoreInit = TRUE)

# handle adding the second option
observeEvent(input$.add_option_2, {
  ind <- as.numeric(input$.accordion_version)

  # add the UI elements to the workflow and report
  add_step(test_module_ui_option_2, test_module_ui_report, ind)
}, ignoreInit = TRUE)

# handle adding the third option
observeEvent(input$.add_option_3, {
  ind <- as.numeric(input$.accordion_version)

  # add the UI elements to the workflow and report
  add_step(test_module_ui_option_3, test_module_ui_report, ind)
}, ignoreInit = TRUE)
