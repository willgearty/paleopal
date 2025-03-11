# common UI components ####

# a version of the accordion panel that includes a remove button
accordion_panel_paleopal <- function(ind, ...) {
  tmp <- accordion_panel(
    ...,
    actionButton(paste0(".remove_step_", ind), "Remove this step"),
    value = paste0("step_", ind)
  )
  # need this attribute for sortable_js_capture_input
  tmp$attribs$`data-rank-id` <- paste0("step_", ind)
  tmp
}

select_dataset_input <- function(ind) {
  df_names <- get_int_dfs()
  selectInput(paste0("dataset_", ind), "Choose a dataset:",
              choices = df_names)
}

select_column_input <- function(ind) {
  df_names <- get_int_dfs()
  selectInput(paste0("column_", ind), "Choose a column:",
              choices = colnames(intermediate_list[[df_names[[1]]]]()))
}
