# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option
observeEvent(input$.mod02_add_option_1, {
  ind <- input$.accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("dataset_", ind)]])
      metaExpr({
        ..(get_int_data(input[[paste0("dataset_", ind)]])()) %>%
          distinct()
      })
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("dataset_", ind)]])
    metaExpr({
      expandChain(invisible(get_int_data(paste0("occs_", ind))()))
    })
  })

  clip_observe(input, ind,
               expr(
                 expandChain(invisible(get_int_data(paste0("occs_", ind))()))
               ))

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod02_ui_option_1, mod02_report_option_1,
    list(
      inject(quote(
        invisible(get_int_data(paste0("occs_", !!ind))())
      ))
    ),
    c("dplyr")
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)
}, ignoreInit = TRUE)

# handle adding the second option
observeEvent(input$.mod02_add_option_2, {
  ind <- input$.accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind)]])
      df <- isolate(get_int_data(input[[paste0("dataset_", ind)]])())
      req(df[[input[[paste0("column_", ind)]]]])
      metaExpr({
        ..(get_int_data(input[[paste0("dataset_", ind)]])()) %>%
          filter(!!..(input[[paste0("column_", ind)]]) ==
                   ..(input[[paste0("text_", ind)]]))
      })
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind)]])
    metaExpr({
      expandChain(invisible(get_int_data(paste0("occs_", ind))()))
    })
  })

  clip_observe(input, ind,
               expr(
                 expandChain(invisible(get_int_data(paste0("occs_", ind))()))
               ))

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod02_ui_option_2, mod02_report_option_2,
    list(
      inject(quote(
        invisible(get_int_data(paste0("occs_", !!ind))())
      ))
    ),
    c("dplyr")
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)

  # if chosen dataset is changed, change the column choices
  column_select_observe(input, ind, paste0("column_", ind))
}, ignoreInit = TRUE)
