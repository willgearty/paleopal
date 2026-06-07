# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option (scatterplot)
observeEvent(input$mod04_add_option_1, {
  ind <- next_step_index()

  # fetch the chosen data.frame once for both the plot and the code output
  plot_df <- reactive({
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        get_int_data(input[[paste0("dataset_", ind)]]))
    get_int_data(input[[paste0("dataset_", ind)]])()
  })

  # make a scatterplot with ggplot
  output[[paste0("plot_", ind)]] <- metaRender2(renderPlot, {
    df <- plot_df()
    # leave the plot blank (via req) rather than repeating the validation
    # message -- the code chunk shown just above already displays it
    req(df[[input[[paste0("column_", ind, "_1")]]]],
        df[[input[[paste0("column_", ind, "_2")]]]])
    req(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
        is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]))
    metaExpr({
      ggplot(..(get_int_data(input[[paste0("dataset_", ind)]])()),
             aes(x = !!..(input[[paste0("column_", ind, "_1")]]),
                 y = !!..(input[[paste0("column_", ind, "_2")]]))) +
        geom_point(color = "red") +
        theme_classic()
    })
  })
  output[[paste0("code_", ind)]] <- renderPrint({
    df <- plot_df()
    validate(need(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
                  "x-axis column must be numeric"),
             need(is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]),
                  "y-axis column must be numeric"))
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod04_ui_option_1, mod04_report_option_1,
    list(
      inject(quote(
        output[[paste0("plot_", !!ind)]]()
      ))
    ),
    c("ggplot2")
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)

  # if chosen dataset is changed, change the column choices
  column_select_observe(input, ind, paste0("column_", ind, "_1"))
  column_select_observe(input, ind, paste0("column_", ind, "_2"))

}, ignoreInit = TRUE)

# handle adding the second option (map)
observeEvent(input$mod04_add_option_2, {
  ind <- next_step_index()

  # fetch the chosen data.frame once for both the map and the code output
  plot_df <- reactive({
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        get_int_data(input[[paste0("dataset_", ind)]]))
    get_int_data(input[[paste0("dataset_", ind)]])()
  })

  # make a map of occs with ggplot
  output[[paste0("map_", ind)]] <- metaRender2(renderPlot, {
    df <- plot_df()
    # leave the plot blank (via req) rather than repeating the validation
    # message -- the code chunk shown just above already displays it
    req(df[[input[[paste0("column_", ind, "_1")]]]],
        df[[input[[paste0("column_", ind, "_2")]]]])
    req(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
        is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]))
    metaExpr({
      ggplot(..(get_int_data(input[[paste0("dataset_", ind)]])()),
             aes(x = !!..(input[[paste0("column_", ind, "_1")]]),
                 y = !!..(input[[paste0("column_", ind, "_2")]]))) +
        borders("world") +
        geom_point(color = "red") +
        coord_sf()
    })
  })
  output[[paste0("code_", ind)]] <- renderPrint({
    df <- plot_df()
    validate(need(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
                  "Longitude column must be numeric"),
             need(is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]),
                  "Latitude column must be numeric"))
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod04_ui_option_2, mod04_report_option_2,
    list(
      inject(quote(
        output[[paste0("map_", !!ind)]]()
      ))
    ),
    c("ggplot2")
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)

  # if chosen dataset is changed, change the column choices
  column_select_observe(input, ind, paste0("column_", ind, "_1"))
  column_select_observe(input, ind, paste0("column_", ind, "_2"))

}, ignoreInit = TRUE)

# handle adding the third option (time series with a geological timescale)
observeEvent(input$mod04_add_option_3, {
  ind <- next_step_index()

  # fetch the chosen data.frame once for both the plot and the code output
  plot_df <- reactive({
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        get_int_data(input[[paste0("dataset_", ind)]]))
    get_int_data(input[[paste0("dataset_", ind)]])()
  })

  # plot a time series; the geom and the geological timescale axis are toggleable
  output[[paste0("plot_", ind)]] <- metaRender2(renderPlot, {
    df <- plot_df()
    # leave the plot blank (via req) rather than repeating the validation
    # message -- the code chunk shown just above already displays it
    req(df[[input[[paste0("column_", ind, "_1")]]]],
        df[[input[[paste0("column_", ind, "_2")]]]])
    req(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
        is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]))
    # pick the geom from the dropdown (default to points if unset)
    geom_layer <- if (identical(input[[paste0("geom_", ind)]], "line")) {
      quote(geom_line())
    } else {
      quote(geom_point())
    }
    # assemble the layers, adding coord_geo() only when the axis box is checked
    # and deeptime is available
    layers <- list(geom_layer, quote(scale_x_reverse()))
    if (isTRUE(input[[paste0("axis_", ind)]]) && deeptime_available) {
      layers <- c(layers, list(quote(coord_geo())))
    }
    layers <- c(layers, list(quote(theme_classic())))
    # build the ggplot() call then fold the layers on with `+`. constructing the
    # expression (instead of a literal metaExpr) lets us omit coord_geo()
    # entirely when the axis is off, rather than leaving a `+ NULL` stub; the
    # ..()/!! markers are still expanded by metaExpr() below. the time column
    # must be in millions of years (Ma) for the timescale to line up
    plot_expr <- quote(
      ggplot(..(get_int_data(input[[paste0("dataset_", ind)]])()),
             aes(x = !!..(input[[paste0("column_", ind, "_1")]]),
                 y = !!..(input[[paste0("column_", ind, "_2")]])))
    )
    for (layer in layers) plot_expr <- call("+", plot_expr, layer)
    metaExpr(plot_expr, quoted = TRUE)
  })
  output[[paste0("code_", ind)]] <- renderPrint({
    df <- plot_df()
    validate(need(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
                  "Time column must be numeric (ages in Ma)"),
             need(is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]),
                  "y-axis column must be numeric"))
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod04_ui_option_3, mod04_report_option_3,
    list(
      inject(quote(
        output[[paste0("plot_", !!ind)]]()
      ))
    ),
    if (deeptime_available) c("ggplot2", "deeptime") else "ggplot2"
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)

  # if chosen dataset is changed, change the column choices
  column_select_observe(input, ind, paste0("column_", ind, "_1"))
  column_select_observe(input, ind, paste0("column_", ind, "_2"))

}, ignoreInit = TRUE)

# handle adding the fourth option (boxplot)
observeEvent(input$mod04_add_option_4, {
  ind <- next_step_index()

  # fetch the chosen data.frame once for both the plot and the code output
  plot_df <- reactive({
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        get_int_data(input[[paste0("dataset_", ind)]]))
    get_int_data(input[[paste0("dataset_", ind)]])()
  })

  # make a box or violin plot: a numeric y-axis grouped by a categorical x-axis
  output[[paste0("plot_", ind)]] <- metaRender2(renderPlot, {
    df <- plot_df()
    # leave the plot blank (via req) rather than repeating the validation
    # message -- the code chunk shown just above already displays it
    req(df[[input[[paste0("column_", ind, "_1")]]]],
        df[[input[[paste0("column_", ind, "_2")]]]])
    req(is.character(df[[input[[paste0("column_", ind, "_1")]]]]) ||
          is.factor(df[[input[[paste0("column_", ind, "_1")]]]]),
        is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]))
    # pick the geom from the dropdown (default to a boxplot)
    geom_layer <- if (identical(input[[paste0("geom_", ind)]], "violin")) {
      quote(geom_violin())
    } else {
      quote(geom_boxplot())
    }
    # build the ggplot() call then fold on the chosen geom and theme; see the
    # time-series step for why we construct the expression instead of writing a
    # literal metaExpr (the ..()/!! markers are still expanded by metaExpr below)
    plot_expr <- quote(
      ggplot(..(get_int_data(input[[paste0("dataset_", ind)]])()),
             aes(x = !!..(input[[paste0("column_", ind, "_1")]]),
                 y = !!..(input[[paste0("column_", ind, "_2")]])))
    )
    for (layer in list(geom_layer, quote(theme_classic()))) {
      plot_expr <- call("+", plot_expr, layer)
    }
    metaExpr(plot_expr, quoted = TRUE)
  })
  output[[paste0("code_", ind)]] <- renderPrint({
    df <- plot_df()
    validate(need(is.character(df[[input[[paste0("column_", ind, "_1")]]]]) ||
                    is.factor(df[[input[[paste0("column_", ind, "_1")]]]]),
                  "Grouping column must be categorical (text or factor)"),
             need(is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]),
                  "y-axis column must be numeric"))
    get_chunk(ind)
  })

  clip_observe(input, output, ind, expr(get_chunk(ind)))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod04_ui_option_4, mod04_report_option_4,
    list(
      inject(quote(
        output[[paste0("plot_", !!ind)]]()
      ))
    ),
    c("ggplot2")
  )

  # choices should always include all intermediate data.frames
  df_select_observe(input, ind)

  # if chosen dataset is changed, change the column choices
  column_select_observe(input, ind, paste0("column_", ind, "_1"))
  column_select_observe(input, ind, paste0("column_", ind, "_2"))

}, ignoreInit = TRUE)
