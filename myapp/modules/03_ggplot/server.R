# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option
observeEvent(input$mod03_add_option_1, {
  ind <- input$accordion_version

  # make a map of occs with ggplot
  output[[paste0("map_", ind)]] <- metaRender2(renderPlot, {
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        get_int_data(input[[paste0("dataset_", ind)]]))
    df <- get_int_data(input[[paste0("dataset_", ind)]])()
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
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("dataset_", ind)]], input[[paste0("column_", ind, "_1")]],
        input[[paste0("column_", ind, "_2")]],
        get_int_data(input[[paste0("dataset_", ind)]]))
    df <- get_int_data(input[[paste0("dataset_", ind)]])()
    validate(need(is.numeric(df[[input[[paste0("column_", ind, "_1")]]]]),
                  "Longitude column must be numeric"),
             need(is.numeric(df[[input[[paste0("column_", ind, "_2")]]]]),
                  "Latitude column must be numeric"))
    metaExpr({
      expandChain_shared(output[[paste0("map_", ind)]]())
    })
  })

  clip_observe(input, output, ind,
               expr(
                 expandChain_shared(output[[paste0("map_", ind)]]())
               ))

  # add the UI elements to the workflow and report
  add_shinypal_step(
    input, ind, mod03_ui_option_1, mod03_report_option_1,
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
