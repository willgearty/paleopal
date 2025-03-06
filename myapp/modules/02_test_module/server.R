# this file includes the server-side logic for the module
# this includes adding libraries to the report, handling dynamic UI elements,
# and setting up listeners

# handle adding the second option
observeEvent(input$.mod02_add_option_1, {
  ind <- as.numeric(input$.accordion_version)

  output[[paste0("text_", ind)]] <- renderText({
    "This is the second step"
  })

  # add the UI elements to the workflow and report
  add_step(ind, mod02_ui_option_1, mod02_report_option_1,
           list(quote("#This is the second step")),
           c("dplyr"))
}, ignoreInit = TRUE)

# handle adding the third option
observeEvent(input$.mod02_add_option_2, {
  ind <- as.numeric(input$.accordion_version)

  output[[paste0("text_", ind)]] <- renderText({
    "This is the third step"
  })

  # add the UI elements to the workflow and report
  add_step(ind, mod02_ui_option_2, mod02_report_option_2,
           list(quote("#This is the third step")),
           c())
}, ignoreInit = TRUE)
