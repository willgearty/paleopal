# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option (assign occurrences to time bins)
observeEvent(input$mod03_add_option_1, {
  ind <- next_step_index()

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("dataset_", ind)]],
          input[[paste0("column_", ind, "_1")]],
          input[[paste0("column_", ind, "_2")]],
          input[[paste0("rank_", ind)]],
          input[[paste0("method_", ind)]])
      df <- isolate(get_int_data(input[[paste0("dataset_", ind)]])())
      req(df[[input[[paste0("column_", ind, "_1")]]]],
          df[[input[[paste0("column_", ind, "_2")]]]])
      # bin_time() needs numeric age columns and errors on NA ages
      req(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
          is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]))
      req(!anyNA(df[[input[[paste0("column_", ind, "_1")]]]]),
          !anyNA(df[[input[[paste0("column_", ind, "_2")]]]]))
      # bin_time() takes column names as strings, so inject them as character
      # literals (no !!..() needed) alongside the rank and method choices
      max_col <- as.character(input[[paste0("column_", ind, "_1")]])
      min_col <- as.character(input[[paste0("column_", ind, "_2")]])
      metaExpr(
        substitute(
          ..(get_int_data(input[[paste0("dataset_", ind)]])()) %>%
            bin_time(min_ma = MIN, max_ma = MAX,
                     bins = time_bins(rank = RANK), method = METHOD),
          list(MIN = min_col, MAX = max_col,
               RANK = input[[paste0("rank_", ind)]],
               METHOD = input[[paste0("method_", ind)]])
        ),
        quoted = TRUE
      )
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- renderPrint({
    req(input[[paste0("dataset_", ind)]],
        input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        input[[paste0("rank_", ind)]],
        input[[paste0("method_", ind)]])
    df <- get_int_data(input[[paste0("dataset_", ind)]])()
    # the age columns must be numeric and complete for bin_time() to run
    validate(need(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]) &&
                    is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]),
                  "Both age columns must be numeric"))
    validate(need(!anyNA(df[[input[[paste0("column_", ind, "_1")]]]]) &&
                    !anyNA(df[[input[[paste0("column_", ind, "_2")]]]]),
                  "Age columns must not contain missing values"))
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod03_ui_option_1, mod03_report_option_1,
    list(
      inject(quote(
        invisible(get_int_data(paste0("occs_", !!ind))())
      ))
    ),
    c("palaeoverse")
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)

  # if chosen dataset is changed, change the column choices (max and min age)
  column_select_observe(input, ind, paste0("column_", ind, "_1"))
  column_select_observe(input, ind, paste0("column_", ind, "_2"))
}, ignoreInit = TRUE)

# handle adding the second option (look up stages and ages from interval names)
observeEvent(input$mod03_add_option_2, {
  ind <- next_step_index()

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("dataset_", ind)]],
          input[[paste0("column_", ind, "_1")]],
          input[[paste0("column_", ind, "_2")]],
          input[[paste0("intkey_", ind)]])
      df <- isolate(get_int_data(input[[paste0("dataset_", ind)]])())
      req(df[[input[[paste0("column_", ind, "_1")]]]],
          df[[input[[paste0("column_", ind, "_2")]]]])
      # look_up() matches interval *names*, so both columns must be text
      req(is.character(df[[input[[paste0("column_", ind, "_1")]]]]) ||
            is.factor(df[[input[[paste0("column_", ind, "_1")]]]]),
          is.character(df[[input[[paste0("column_", ind, "_2")]]]]) ||
            is.factor(df[[input[[paste0("column_", ind, "_2")]]]]))
      # the interval columns go in as strings; interval_key is a bare symbol (a
      # palaeoverse dataset) so substitute() leaves it untouched
      early_col <- as.character(input[[paste0("column_", ind, "_1")]])
      late_col <- as.character(input[[paste0("column_", ind, "_2")]])
      if (identical(input[[paste0("intkey_", ind)]], "interval_key")) {
        # use the bundled key for PBDB / PaleoReefs interval names
        look_up_expr <- substitute(
          ..(get_int_data(input[[paste0("dataset_", ind)]])()) %>%
            look_up(early_interval = EARLY, late_interval = LATE,
                    int_key = interval_key),
          list(EARLY = early_col, LATE = late_col)
        )
      } else {
        # interval names are already GTS2020 names (the default assignment)
        look_up_expr <- substitute(
          ..(get_int_data(input[[paste0("dataset_", ind)]])()) %>%
            look_up(early_interval = EARLY, late_interval = LATE),
          list(EARLY = early_col, LATE = late_col)
        )
      }
      metaExpr(look_up_expr, quoted = TRUE)
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- renderPrint({
    req(input[[paste0("dataset_", ind)]],
        input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        input[[paste0("intkey_", ind)]])
    df <- get_int_data(input[[paste0("dataset_", ind)]])()
    # both interval columns must hold interval names (text)
    validate(need((is.character(df[[input[[paste0("column_", ind, "_1")]]]]) ||
                     is.factor(df[[input[[paste0("column_", ind, "_1")]]]])) &&
                    (is.character(df[[input[[paste0("column_", ind, "_2")]]]]) ||
                       is.factor(df[[input[[paste0("column_", ind, "_2")]]]])),
                  "Both interval columns must contain interval names (text)"))
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod03_ui_option_2, mod03_report_option_2,
    list(
      inject(quote(
        invisible(get_int_data(paste0("occs_", !!ind))())
      ))
    ),
    c("palaeoverse")
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)

  # if chosen dataset is changed, change the column choices (early and late)
  column_select_observe(input, ind, paste0("column_", ind, "_1"))
  column_select_observe(input, ind, paste0("column_", ind, "_2"))
}, ignoreInit = TRUE)
