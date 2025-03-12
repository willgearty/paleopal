# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option
observeEvent(input$.mod03_add_option_1, {
  ind <- input$.accordion_version

  # make a map of occs with ggplot
  output[[paste0("map_", ind)]] <- metaRender(renderPlot, {
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        intermediate_list[[input[[paste0("dataset_", ind)]]]])
    ggplot(..(intermediate_list[[input[[paste0("dataset_", ind)]]]]()),
           aes(x = !!..(input[[paste0("column_", ind, "_1")]]),
               y = !!..(input[[paste0("column_", ind, "_2")]]))) +
      borders("world") +
      geom_point(color = "red") +
      coord_sf()
  })
  output[[paste0("code_", ind)]] <- renderPrint({
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        intermediate_list[[input[[paste0("dataset_", ind)]]]])
    expandChain(output[[paste0("map_", ind)]]())
  })
  observeEvent(input[[paste0("copy_", ind)]], {
    write_clip(expandChain(output[[paste0("map_", ind)]]()),
               allow_non_interactive = TRUE)
  })

  # add the UI elements to the workflow and report
  add_step(ind, mod03_ui_option_1, mod03_report_option_1,
           list(
             inject(quote(
               output[[paste0("map_", !!ind)]]()
             ))
           ),
           c("ggplot2"))

  # choices should always include all intermediate data.frames
  observe({
    choices <- get_int_dfs(ind) %||% character(0)
    # try to preserve the old selected dataset name
    old_df <- isolate(input[[paste0("dataset_", ind)]])
    if (!is.null(old_df) && old_df %in% choices) {
      selected <- old_df
    } else {
      selected <- NULL
    }
    # update choices but maintain selected
    updateSelectInput(session, paste0("dataset_", ind), choices = choices,
                      selected = selected)
  })
  # if chosen dataset is changed, change the column choices
  observeEvent(input[[paste0("dataset_", ind)]], {
    df_name <- input[[paste0("dataset_", ind)]]
    choices <- colnames(isolate(intermediate_list[[df_name]]()))
    # try to preserve the old selected column name
    old_col <- isolate(input[[paste0("column_", ind)]])
    if (!is.null(old_col) && as_string(old_col) %in% choices) {
      selected <- old_col
    } else {
      selected <- NULL
    }
    updateVarSelectInput(session, paste0("column_", ind),
                         data = isolate(intermediate_list[[df_name]]()),
                         selected = selected)
  }, ignoreInit = TRUE)

}, ignoreInit = TRUE)