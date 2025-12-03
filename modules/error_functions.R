
# ---- check table name -----
check_table_name <- function(table_name) {

  if (is.null(table_name) || is.na(table_name)) {
    cli::cli_alert_danger("table_name is NULL, cannot run query")
  } else {
    cli::cli_alert_success("table_name from get_selected_table():
                               {.val {table_name}}")
  }
}
# ---- check tab name -----

check_tab_name <- function(tab) {
  if (!(tab %in% c("summary_info",
                   "scatter_plot"))) {

    cli::cli_abort("Cannot execute function for {.val {tab}} tab")
  }
}

# ---- ehck if summary data is being triggered ----
check_summary_data <- function() {
  observe({
  # tell me what is being triggered
  cli::cli_alert_success("summary_data triggered")

  # if try is false
  df <- try(summary_data(),
            silent = TRUE)

  if (inherits(df, "try-error")) {
    cli::cli_alert_danger("summary_data() failed completely")
  } else if ("Message" %in% names(df)) {
    cli::cli_alert_danger(
      "get_summary_data() returned error message: {.val {df$Message[1]}}")
  } else {
    cli::cli_alert_success(
      "summary_data() rows: {.val {nrow(df)}}, cols: {.val {ncol(df)}}")
    cli::cli_alert_info("Column names:")

  }
  # cli::cli_ul(names(df))  # Bulleted list
  # # or
  cli::cli_text("{.field {sort(names(df))}}")  # Inline with field styling
})
}
