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
