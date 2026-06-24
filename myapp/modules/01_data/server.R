# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option (palaeoverse data)
observeEvent(input$mod01_add_option_1, {
  ind <- next_step_index()

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  add_shinypal_data_step(
    ind,
    data = metaReactive2({
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
    fun_workflow = mod01_ui_option_1, fun_report = mod01_report_option_1,
    # alternate code for the downloadable report: fully-qualified palaeoverse::
    ec_subs = list(
      get_int_data(paste0("occs_", ind)),
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
      }
    )
  )
}, ignoreInit = TRUE)

# handle adding the second option (PBDB data)
observeEvent(input$mod01_add_option_2, {
  ind <- next_step_index()

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  add_shinypal_data_step(
    ind,
    data = metaReactive2({
      req(input[[paste0("genus_", ind)]])
      metaExpr({
        pbdb_occurrences(taxon_name = ..(input[[paste0("genus_", ind)]]),
                         vocab = "pbdb", show = "coords")
      })
    }, varname = paste0("occs_", ind)),
    fun_workflow = mod01_ui_option_2, fun_report = mod01_report_option_2,
    libs = "paleobioDB"
  )
}, ignoreInit = TRUE)

# handle adding the third option (uploaded data)
observeEvent(input$mod01_add_option_3, {
  ind <- next_step_index()

  # validate the upload once and share it between the data reactive and the
  # code output below
  valid_upload <- reactive({
    validate(need(input[[paste0("file1_", ind)]], "Please upload a file"),
             need(input[[paste0("num_rows_", ind)]],
                  "Please specify the number of rows to skip"))
    file <- input[[paste0("file1_", ind)]]
    ext <- tools::file_ext(file$datapath)
    validate(need(ext == "csv", "Please upload a csv file"),
             need(input[[paste0("num_rows_", ind)]] >= 0,
                  "Number of rows must be greater than or equal to 0"),
             need(tryCatch(
               read.csv(file$datapath,
                        skip = input[[paste0("num_rows_", ind)]],
                        nrows = 1),
               error = function(e) {
                 FALSE
               }), paste("Invalid CSV file or # of rows to skip.",
                         "Try a different file or # of rows.")))
    file
  })

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  add_shinypal_data_step(
    ind,
    data = metaReactive2({
      file <- valid_upload()
      metaExpr({
        read.csv(..(file$datapath),
                 skip = ..(input[[paste0("num_rows_", ind)]]))
      })
    }, varname = paste0("occs_", ind)),
    fun_workflow = mod01_ui_option_3, fun_report = mod01_report_option_3,
    # show the upload validation messages before the generated code
    code_guard = function() valid_upload(),
    # alternate code for the downloadable report: read.csv on the uploaded name
    ec_subs = list(
      get_int_data(paste0("occs_", ind)),
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
      }
    )
  )

  file_observe(paste0("file1_", ind))
}, ignoreInit = TRUE)
