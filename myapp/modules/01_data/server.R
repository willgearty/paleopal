# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option (palaeoverse data)
observeEvent(input$mod01_add_option_1, {
  ind <- input$accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("palaeoverse_", ind)]])
      if (input[[paste0("palaeoverse_", ind)]] == "reefs") {
        metaExpr({
          reefs
        })
      } else if (input[[paste0("palaeoverse_", ind)]] == "tetrapods") {
        metaExpr({
          tetrapods
        })
      }
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("palaeoverse_", ind)]])
    metaExpr({
      expandChain_shared(invisible(get_int_data(paste0("occs_", ind))()))
    })
  })

  clip_observe(
    input, output, ind,
    expr(
      expandChain_shared(invisible(get_int_data(paste0("occs_", ind))()))
    )
  )

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow, report, and downloadable markdown
  # note that any local variables need to be injected with !!
  add_shinypal_step(
    input, ind, mod01_ui_option_1, mod01_report_option_1,
    list(
      inject(quote(
        invisible(get_int_data(paste0("occs_", !!ind))())
      ))
    ),
    c(),
    list(get_int_data(paste0("occs_", ind)),
         function() {
           req(input[[paste0("palaeoverse_", ind)]])
           if (input[[paste0("palaeoverse_", ind)]] == "reefs") {
             metaExpr({
               palaeoverse::reefs
             })
           } else if (input[[paste0("palaeoverse_", ind)]] == "tetrapods") {
             metaExpr({
               palaeoverse::tetrapods
             })
           }
         })
  )
}, ignoreInit = TRUE)

# handle adding the second option (PBDB data)
observeEvent(input$mod01_add_option_2, {
  ind <- input$accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("genus_", ind)]])
      metaExpr({
        pbdb_occurrences(taxon_name = ..(input[[paste0("genus_", ind)]]),
                         vocab = "pbdb", show = "coords")
      })
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("genus_", ind)]])
    metaExpr({
      expandChain_shared(invisible(get_int_data(paste0("occs_", ind))()))
    })
  })

  clip_observe(
    input, output, ind,
    expr(
      expandChain_shared(invisible(get_int_data(paste0("occs_", ind))()))
    )
  )

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow, report, and downloadable markdown
  # note that any local variables need to be injected with !!
  add_shinypal_step(
    input, ind, mod01_ui_option_2, mod01_report_option_2,
    list(
      inject(quote(
        invisible(get_int_data(paste0("occs_", !!ind))())
      ))
    ),
    c("paleobioDB")
  )
}, ignoreInit = TRUE)

# handle adding the third option (uploaded data)
observeEvent(input$mod01_add_option_3, {
  ind <- input$accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  set_int_data(
    metaReactive2({
      req(input[[paste0("file1_", ind)]], input[[paste0("num_rows_", ind)]])
      file <- input[[paste0("file1_", ind)]]
      ext <- tools::file_ext(file$datapath)
      validate(need(ext == "csv", "Please upload a csv file"))
      validate(need(input[[paste0("num_rows_", ind)]] >= 0,
                    "Number of rows must be greater than or equal to 0"))
      metaExpr({
        read.csv(..(file$datapath),
                 skip = ..(input[[paste0("num_rows_", ind)]]))
      })
    }, varname = paste0("occs_", ind)),
    paste0("occs_", ind)
  )

  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("file1_", ind)]], input[[paste0("num_rows_", ind)]])
    metaExpr({
      expandChain_shared(invisible(get_int_data(paste0("occs_", ind))()))
    })
  })

  file_observe(input, paste0("file1_", ind))

  clip_observe(
    input, output, ind,
    expr(
      expandChain_shared(invisible(get_int_data(paste0("occs_", ind))()))
    )
  )

  df_modal_observe(input, output, ind, paste0("occs_", ind))

  # add the UI elements to the workflow, report, and downloadable markdown
  # note that any local variables need to be injected with !!
  add_shinypal_step(
    input, ind, mod01_ui_option_3, mod01_report_option_3,
    list(
      inject(quote(
        invisible(get_int_data(paste0("occs_", !!ind))())
      ))
    ),
    c(),
    list(get_int_data(paste0("occs_", ind)),
         function() {
           req(input[[paste0("file1_", ind)]],
               input[[paste0("num_rows_", ind)]])
           file <- input[[paste0("file1_", ind)]]
           ext <- tools::file_ext(file$datapath)
           validate(need(ext == "csv", "Please upload a csv file"))
           validate(need(input[[paste0("num_rows_", ind)]] >= 0,
                         "Number of rows must be greater than or equal to 0"))
           metaExpr(read.csv(..(file$name),
                             skip = ..(input[[paste0("num_rows_", ind)]])))
         })
  )
}, ignoreInit = TRUE)
