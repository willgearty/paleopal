# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the first option
observeEvent(input$.mod01_add_option_1, {
  ind <- as.numeric(input$.accordion_version)

  # build reactive expressions for each instance of this component
  # anything that will be included as code in the report needs to be added to
  # intermediate list, input, or output (or some other global object)
  intermediate_list[[paste0("occs_", ind)]] <- metaReactive2({
    req(input[[paste0("genus_", ind)]])
    isolate(metaExpr({
      pbdb_occurrences(taxon_name = ..(input[[paste0("genus_", ind)]]),
                       vocab = "pbdb", show = "coords")
    }))
  }, varname = paste0("occs_", ind))
  output[[paste0("code_", ind)]] <- renderPrint({
    expandChain(invisible(intermediate_list[[paste0("occs_", ind)]]()))
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
           c("paleobioDB"))
}, ignoreInit = TRUE)
