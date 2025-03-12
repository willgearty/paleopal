# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option
observeEvent(input$.mod02_add_option_1, {
  ind <- input$.accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  intermediate_list[[paste0("occs_", ind)]] <- metaReactive2({
    req(input[[paste0("dataset_", ind)]])
    metaExpr({
      ..(intermediate_list[[input[[paste0("dataset_", ind)]]]]()) %>%
        distinct()
    })
  }, varname = paste0("occs_", ind))
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("dataset_", ind)]])
    metaExpr({
      expandChain(invisible(intermediate_list[[paste0("occs_", ind)]]()))
    })
  })
  observeEvent(input[[paste0("copy_", ind)]], {
    write_clip(
      expandChain(invisible(intermediate_list[[paste0("occs_", ind)]]())),
      allow_non_interactive = TRUE
    )
  })

  observeEvent(input[[paste0("df_modal_", ind)]], {
    show_df_modal(ind, paste0("occs_", ind))
  }, ignoreInit = TRUE)

  # add the UI elements to the workflow and report
  add_step(ind, mod02_ui_option_1, mod02_report_option_1,
           list(
             inject(quote(
               invisible(intermediate_list[[paste0("occs_", !!ind)]]())
             ))
           ),
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

# handle adding the second option
observeEvent(input$.mod02_add_option_2, {
  ind <- input$.accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  intermediate_list[[paste0("occs_", ind)]] <- metaReactive2({
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind)]])
    metaExpr({
      ..(intermediate_list[[input[[paste0("dataset_", ind)]]]]()) %>%
        filter(!!..(input[[paste0("column_", ind)]]) ==
                 ..(input[[paste0("text_", ind)]]))
    })
  }, varname = paste0("occs_", ind))
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind)]])
    metaExpr({
      expandChain(invisible(intermediate_list[[paste0("occs_", ind)]]()))
    })
  })
  observeEvent(input[[paste0("copy_", ind)]], {
   write_clip(
     expandChain(invisible(intermediate_list[[paste0("occs_", ind)]]())),
     allow_non_interactive = TRUE
   )
  })

  observeEvent(input[[paste0("df_modal_", ind)]], {
    show_df_modal(ind, paste0("occs_", ind))
  }, ignoreInit = TRUE)

  # add the UI elements to the workflow and report
  add_step(ind, mod02_ui_option_2, mod02_report_option_2,
           list(
             inject(quote(
               invisible(intermediate_list[[paste0("occs_", !!ind)]]())
             ))
           ),
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
