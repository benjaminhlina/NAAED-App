
# ---- create fileted summary ----
create_filtered_data <- function(input_source,
                                 data) {
  # check_input_source(input_source_name)

  reactive({
    # if (!exists(input_source_name, envir = parent.frame(2), inherits = TRUE)) {
    #   cli::cli_abort(c(
    #     "Object {.val {input_source_name}} does not exist",
    #     "i" = "Make sure {.val {input_source_name}} is defined before using this reactive"
    #   ))
    # }
    #
    # input_source <- get(input_source_name, envir = parent.frame())

    df <- data()

    grouping_vars <- input_source$grouping_vars()
    waterbody_f <- input_source$waterbody_filter()
    species_f <- input_source$species_filter()

    req(df, grouping_vars)

    if (!(waterbody_f %in% "All")) {
      df <- df |>
        filter(Waterbody == waterbody_f)
    }

    if (!(species_f %in% "All")) {
      df <- df |>
        filter(`Common Name` == species_f)
    }

    return(df)
  })
}



# ----- mean summarized table -----
create_mean_data <- function(input_source,
                             data,
                             numeric_cols) {
  reactive({

    df <- data()
    req(df)

    summary_grouping_vars <- input_source$grouping_vars()
    summary_numeric_cols  <- numeric_cols()
    y_vals <- input_source$y_variable()


    if (is.null(y_vals) || length(y_vals) == 0) {
      # Return just the grouped counts
      summary_df <- df |>
        group_by(across(all_of(summary_grouping_vars))) |>
        summarise(n = n(), .groups = "drop")
      return(summary_df)
    }

    summary_numeric_cols <- setdiff(summary_numeric_cols,
                                    c("sample_id","source_id","cal_id",
                                      "proxcomp_id","iso_id",
                                      "Conversion Factor","Composite (n)"))


    if (nrow(df) == 0) return(df)

    mapped_vars <- lapply(y_vals, function(v)
      fix_var_generic(df, v, get_nice_name))

    for (m in mapped_vars) {
      df <- m$df
    }

    # df <- Reduce(function(d1, d2)
    #   dplyr::intersect(d1, d2), lapply(mapped_vars, `[[`, "df"))

    vars_to_summarise <- unique(sapply(mapped_vars, `[[`, "var"))
    # vars_to_summarise <- intersect(y_vals, summary_numeric_cols)

    req(length(vars_to_summarise) > 0)



    summary_df <- df |>
      group_by(across(all_of(summary_grouping_vars))) |>
      summarise(
        n = n(),
        across(
          all_of(vars_to_summarise),
          list(mean = ~ mean(.x, na.rm = TRUE),
               sd = ~ sd(.x, na.rm = TRUE)),
          .names = "{.col} ({.fn})"
        ),
        .groups = "drop"
      ) |>
      mutate(across(where(is.numeric), ~ round(.x, 2)))


    nice_labels <- sapply(mapped_vars, `[[`, "var_label")

    for (i in seq_along(vars_to_summarise)) {
      summary_df <- summary_df |>
        rename_with(~ gsub(vars_to_summarise[i],
                           nice_labels[i], .x, fixed = TRUE),
                    starts_with(vars_to_summarise[i]))
    }


    return(summary_df)
  })
}

# ---- create numerical_col
create_numeric_col <- function(data) {
  reactive({
    df <- data()
    req(df)
    get_numeric_cols(df)
  })
}

# ---- sumary data -----
# args here are con and main input with tab being used in view_summary and
# view_plot
create_summary_data <- function(con, main_input, tab = NULL) {
  reactive({

    if (!is.null(tab)) {
      check_tab_name(tab)

      req(main_input$tabs == tab)
    }

    table_name <- get_selected_table(main_input)

    req(table_name)

    check_table_name(table_name)

    # ---- acctuat gert data =----
    df <- get_summary_data(con = con, table_name)

    df
  })
}
