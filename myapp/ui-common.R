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

# a select input to choose an intermediate dataset
select_dataset_input <- function(ind, label = "Choose a dataset:") {
  df_names <- get_int_dfs(ind)
  # TODO: selected should be the most recent dataset?
  selectInput(paste0("dataset_", ind), label, choices = df_names)
}

# a select input to choose a column from a dataset
# should be paired with a select_dataset_input
select_column_input <- function(ind, label = "Choose a column:",
                                default = NULL) {
  df_names <- get_int_dfs(ind)
  varSelectInput(paste0("column_", ind), label,
                 data = intermediate_list[[df_names[[1]]]](),
                 selected = default)
}

# a button to view the relevant dataset in a modal
df_modal_button <- function(ind, text = "View data") {
  actionButton(paste0("df_modal_", ind), text)
}

# a verbatimTextOutput with a button to copy the code to the clipboard
# make sure to set up an observer for when the actionButton is clicked
verbatimTextOutput_copy <- function(ind) {
  div(
    verbatimTextOutput(paste0("code_", ind)),
    actionButton(paste0("copy_", ind), icon("copy")),
    class = "code_wrapper"
  )
}

