# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option
observeEvent(input$mod02_add_option_1, {
  ind <- next_step_index()

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
  output[[paste0("code_", ind)]] <- renderPrint({
    req(input[[paste0("dataset_", ind)]])
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

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
observeEvent(input$mod02_add_option_2, {
  ind <- next_step_index()

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
          # wrap the unquoted column in parens so `!!` binds to the symbol
          filter((!!..(input[[paste0("column_", ind)]])) ==
                   ..(input[[paste0("text_", ind)]]))
      })
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- renderPrint({
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind)]])
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

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

# handle adding the third option (mutate: calculate a new column)
observeEvent(input$mod02_add_option_3, {
  ind <- next_step_index()

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("dataset_", ind)]], input[[paste0("mutate_mode_", ind)]])
      df <- isolate(get_int_data(input[[paste0("dataset_", ind)]])())
      mode <- input[[paste0("mutate_mode_", ind)]]
      out_name <- input[[paste0("name_", ind)]]
      if (identical(mode, "binary")) {
        # combine two columns with an arithmetic operator (or their mean)
        req(input[[paste0("column_", ind, "_1")]],
            input[[paste0("column_", ind, "_2")]],
            input[[paste0("operator_", ind)]])
        req(df[[input[[paste0("column_", ind, "_1")]]]],
            df[[input[[paste0("column_", ind, "_2")]]]])
        # arithmetic needs two numeric columns
        req(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
            is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]))
        op <- input[[paste0("operator_", ind)]]
        # inject each column as a bare name via !!..(); assemble the call() tree
        # directly so operator precedence is right without parsing any text
        unq1 <- substitute(
          !!..(COL),
          list(COL = quote(input[[paste0("column_", ind, "_1")]]))
        )
        unq2 <- substitute(
          !!..(COL),
          list(COL = quote(input[[paste0("column_", ind, "_2")]]))
        )
        mutate_value <- if (identical(op, "mean")) {
          call("/", call("+", unq1, unq2), 2)
        } else {
          call(op, unq1, unq2)
        }
        # default the name to <operation>_<col1>_<col2> if left blank
        if (is.null(out_name) || !nzchar(out_name)) {
          op_tag <- c("+" = "sum", "-" = "diff", "*" = "prod",
                      "/" = "ratio", "mean" = "mean")[[op]]
          out_name <- paste0(
            op_tag, "_",
            as.character(input[[paste0("column_", ind, "_1")]]), "_",
            as.character(input[[paste0("column_", ind, "_2")]])
          )
        }
      } else {
        # transform a single column with a function
        req(input[[paste0("column_", ind)]], input[[paste0("transform_", ind)]])
        req(df[[input[[paste0("column_", ind)]]]])
        fn <- input[[paste0("transform_", ind)]]
        # log/sqrt/etc. can't run on a non-numeric column; coercions (as.*) can
        if (fn %in% c("log", "log10", "sqrt", "abs")) {
          req(is.numeric(df[[input[[paste0("column_", ind)]]]]))
        }
        # the column is injected with !!..() so it expands to a bare name
        mutate_value <- substitute(
          FN(!!..(COL)),
          list(FN = as.symbol(fn),
               COL = quote(input[[paste0("column_", ind)]]))
        )
        # default the name to <transform>_<column> if left blank
        if (is.null(out_name) || !nzchar(out_name)) {
          out_name <- paste0(fn, "_",
                             as.character(input[[paste0("column_", ind)]]))
        }
      }
      out_name <- make.names(out_name)
      # build mutate(<out_name> = <value>) with a dynamically set arg name
      mutate_arg <- list(mutate_value)
      names(mutate_arg) <- out_name
      metaExpr(
        substitute(
          ..(get_int_data(input[[paste0("dataset_", ind)]])()) %>% MUT,
          list(MUT = as.call(c(quote(mutate), mutate_arg)))
        ),
        quoted = TRUE
      )
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- renderPrint({
    req(input[[paste0("dataset_", ind)]], input[[paste0("mutate_mode_", ind)]])
    df <- get_int_data(input[[paste0("dataset_", ind)]])()
    if (identical(input[[paste0("mutate_mode_", ind)]], "binary")) {
      # both columns must be chosen and numeric to combine them
      validate(
        need(input[[paste0("column_", ind, "_1")]], "Choose a first column"),
        need(input[[paste0("column_", ind, "_2")]], "Choose a second column")
      )
      validate(need(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]) &&
                      is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]),
                    "Both columns must be numeric to combine them"))
    } else {
      req(input[[paste0("column_", ind)]])
      # warn (not error) when a numeric transform meets a non-numeric column
      if (input[[paste0("transform_", ind)]] %in% c("log", "log10", "sqrt", "abs")) {
        validate(need(is.numeric(df[[input[[paste0("column_", ind)]]]]),
                      "Column must be numeric for this transformation"))
      }
    }
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod02_ui_option_3, mod02_report_option_3,
    list(
      inject(quote(
        invisible(get_int_data(paste0("occs_", !!ind))())
      ))
    ),
    c("dplyr")
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)

  # if chosen dataset is changed, change the column choices (the single-transform
  # column plus the two combine columns)
  column_select_observe(input, ind, paste0("column_", ind))
  column_select_observe(input, ind, paste0("column_", ind, "_1"))
  column_select_observe(input, ind, paste0("column_", ind, "_2"))
}, ignoreInit = TRUE)

# handle adding the fourth option (summarise by group)
observeEvent(input$mod02_add_option_4, {
  ind <- next_step_index()

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
          input[[paste0("stat_", ind)]])
      df <- isolate(get_int_data(input[[paste0("dataset_", ind)]])())
      req(df[[input[[paste0("column_", ind, "_1")]]]])
      stat <- input[[paste0("stat_", ind)]]
      out_name <- input[[paste0("name_", ind)]]
      # count needs no column; every other statistic summarises a value column
      if (identical(stat, "n")) {
        summary_value <- quote(n())
        if (is.null(out_name) || !nzchar(out_name)) out_name <- "n"
      } else {
        req(input[[paste0("column_", ind, "_2")]])
        req(df[[input[[paste0("column_", ind, "_2")]]]])
        # the numeric statistics can't run on a non-numeric column
        if (stat %in% c("mean", "median", "sum", "min", "max", "sd")) {
          req(is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]))
        }
        summary_value <- substitute(
          STAT(!!..(VAL)),
          list(STAT = as.symbol(stat),
               VAL = quote(input[[paste0("column_", ind, "_2")]]))
        )
        if (is.null(out_name) || !nzchar(out_name)) {
          out_name <- paste0(stat, "_",
                             as.character(input[[paste0("column_", ind, "_2")]]))
        }
      }
      out_name <- make.names(out_name)
      # summarise(<out_name> = <summary>, .groups = "drop"); dropping groups
      # returns an ungrouped tibble so later steps don't inherit the grouping
      summ_arg <- list(summary_value)
      names(summ_arg) <- out_name
      metaExpr(
        substitute(
          ..(get_int_data(input[[paste0("dataset_", ind)]])()) %>%
            group_by(!!..(input[[paste0("column_", ind, "_1")]])) %>%
            SUMM,
          list(SUMM = as.call(c(quote(summarise), summ_arg,
                                list(.groups = "drop"))))
        ),
        quoted = TRUE
      )
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- renderPrint({
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("stat_", ind)]])
    df <- get_int_data(input[[paste0("dataset_", ind)]])()
    stat <- input[[paste0("stat_", ind)]]
    # for non-count statistics, a value column (numeric where required) is needed
    if (stat != "n") {
      validate(need(input[[paste0("column_", ind, "_2")]],
                    "Choose a column to summarise"))
      if (stat %in% c("mean", "median", "sum", "min", "max", "sd")) {
        validate(need(is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]),
                      "Column must be numeric for this statistic"))
      }
    }
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod02_ui_option_4, mod02_report_option_4,
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
  column_select_observe(input, ind, paste0("column_", ind, "_1"))
  column_select_observe(input, ind, paste0("column_", ind, "_2"))
}, ignoreInit = TRUE)
