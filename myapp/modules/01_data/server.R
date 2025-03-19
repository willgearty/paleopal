# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option
observeEvent(input$.mod01_add_option_1, {
  ind <- input$.accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  intermediate_list[[paste0("occs_", ind)]] <- metaReactive2({
    req(input[[paste0("file_", ind)]], input[[paste0("num_rows_", ind)]])
    file <- input[[paste0("file_", ind)]]
    ext <- tools::file_ext(file$datapath)
    validate(need(ext == "csv", "Please upload a csv file"))
    metaExpr({
      read.csv(..(file$datapath), skip = ..(input[[paste0("num_rows_", ind)]]))
    })
  }, varname = paste0("occs_", ind))
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("file_", ind)]], input[[paste0("num_rows_", ind)]])
    ec <- newExpansionContext()
    ec$substituteMetaReactive(
      intermediate_list[[paste0("occs_", ind)]],
      function() {
        metaExpr(read.csv(..(input[[paste0("file_", ind)]]$name),
                          skip = ..(input[[paste0("num_rows_", ind)]])))
      }
    )
    metaExpr({
      expandChain(invisible(intermediate_list[[paste0("occs_", ind)]]()),
                  .expansionContext = ec)
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

  # add the UI elements to the workflow, report, and downloadable markdown
  # note that any local variables need to be injected with !!
  add_step(ind, mod01_ui_option_1, mod01_report_option_1,
           list(
             inject(quote(
               invisible(intermediate_list[[paste0("occs_", !!ind)]]())
             ))
           ),
           c())
}, ignoreInit = TRUE)


# handle adding the second option
observeEvent(input$.mod01_add_option_2, {
  ind <- input$.accordion_version

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  intermediate_list[[paste0("occs_", ind)]] <- metaReactive2({
    req(input[[paste0("genus_", ind)]])
    metaExpr({
      pbdb_occurrences(taxon_name = ..(input[[paste0("genus_", ind)]]),
                       vocab = "pbdb", show = "coords")
    })
  }, varname = paste0("occs_", ind))
  output[[paste0("code_", ind)]] <- metaRender2(renderPrint, {
    req(input[[paste0("genus_", ind)]])
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

  # add the UI elements to the workflow, report, and downloadable markdown
  # note that any local variables need to be injected with !!
  add_step(ind, mod01_ui_option_2, mod01_report_option_2,
           list(
             inject(quote(
               invisible(intermediate_list[[paste0("occs_", !!ind)]]())
             ))
           ),
           c("paleobioDB"))
}, ignoreInit = TRUE)
