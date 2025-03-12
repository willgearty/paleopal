# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the second option
observeEvent(input$.mod02_add_option_1, {
  ind <- as.numeric(input$.accordion_version)

  output[[paste0("text_", ind)]] <- renderText({
    "This is the second step"
  })

  # add the UI elements to the workflow and report
  add_step(ind, mod02_ui_option_1, mod02_report_option_1,
           list(quote("#This is the second step")),
           c("dplyr"))

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

# handle adding the third option
observeEvent(input$.mod02_add_option_2, {
  ind <- as.numeric(input$.accordion_version)

  output[[paste0("text_", ind)]] <- renderText({
    "This is the third step"
  })

  # add the UI elements to the workflow and report
  add_step(ind, mod02_ui_option_2, mod02_report_option_2,
           list(quote("#This is the third step")),
           c())
}, ignoreInit = TRUE)
