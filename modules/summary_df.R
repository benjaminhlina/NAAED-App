
create_summary_df <- function(con, main_input) {

  reactive({
    req(main_input)
    df <- get_summary_data(con, get_selected_table(main_input))
    req(df)
    df
  })
}
