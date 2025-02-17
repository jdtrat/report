#' Automatic reporting of R objects
#'
#' Create reports of different objects. See the documentation for your object's
#' class:
#' \itemize{
#'  \item{[System and packages][report.sessionInfo] (`sessionInfo`)}
#'  \item{[Dataframes and vectors][report.data.frame]}
#'  \item{[Correlations and t-tests][report.htest] (`htest`)}
#'  \item{[ANOVAs][report.aov] (`aov, anova, aovlist, ...`)}
#'  \item{[Regression models][report.lm] (`glm, lm, ...`)}
#'  \item{[Mixed models][report.lm] (`glmer, lmer, glmmTMB, ...`)}
#'  \item{[Bayesian models][report.stanreg] (`stanreg, brms...`)}
#'  \item{[Bayes factors][report.bayesfactor_models] (from `bayestestR`)}
#'  \item{[Structural Equation Models (SEM)][report.lavaan] (from `lavaan`)}
#'  \item{[Model comparison][report.compare_performance] (from [`performance()`][performance::compare_performance])}
#' }
#' Most of the time, the object created by the `report()` function can be
#' further transformed, for instance summarized (using `summary()`), or
#' converted to a table (using `as.data.frame()`).
#'
#' @param x The R object that you want to report (see list of of supported
#'   objects above).
#' @param ... Arguments passed to or from other methods.
#'
#' @details
#'
#' \subsection{Organization}{
#' `report_table` and `report_text` are the two distal representations
#' of a report, and are the two provided in `report()`. However,
#' intermediate steps are accessible (depending on the object) via specific
#' functions (e.g., `report_parameters`).
#' }
#'
#' \subsection{Output}{
#'
#' The `report()` function generates a report-object that contain in itself
#' different representations (e.g., text, tables, plots). These different
#' representations can be accessed via several functions, such as:
#'
#' \itemize{
#' \item **`as.report_text(r)`**: Detailed text.
#'
#' \item **`as.report_text(r, summary=TRUE)`**: Minimal text giving
#' the minimal information.
#'
#' \item **`as.report_table(r)`**: Comprehensive table including most
#' available indices.
#'
#' \item **`as.report_table(r, summary=TRUE)`**: Minimal table.
#' }
#'
#' Note that for some report objects, some of these representations might be
#' identical.
#' }
#'
#' @return A list-object of class `report`, which contains further
#'   list-objects with a short and long description of the model summary, as
#'   well as a short and long table of parameters and fit indices.
#'
#' @seealso Specific components of reports (especially for stats models):
#' \itemize{
#'   \item [report_table()]
#'   \item [report_parameters()]
#'   \item [report_statistics()]
#'   \item [report_effectsize()]
#'   \item [report_model()]
#'   \item [report_priors()]
#'   \item [report_random()]
#'   \item [report_performance()]
#'   \item [report_info()]
#'   \item [report_text()]
#' }
#' Other types of reports:
#' \itemize{
#'   \item [report_system()]
#'   \item [report_packages()]
#'   \item [report_participants()]
#'   \item [report_sample()]
#'   \item [report_date()]
#' }
#' Methods:
#' \itemize{
#'   \item [as.report()]
#' }
#' Template file for supporting new models:
#' \itemize{
#'   \item [report.default()]
#' }
#'
#' @examples
#' library(report)
#'
#' model <- t.test(mpg ~ am, data = mtcars)
#' r <- report(model)
#'
#' # Text
#' r
#' summary(r)
#'
#' # Tables
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' @export
report <- function(x, ...) {
  UseMethod("report")
}


# Generic Methods --------------------------------------------------


#' @export
print.report <- print.report_text


#' @include report_text.R
#' @export
as.data.frame.report <- function(x, ...) {
  as.report_table(x, ...)
}

# @export
# as.table.report <- as.data.frame.report


# Values ------------------------------------------------------------------


# @export
# as.list.report <- function(x, ...) {
#   if (any(class(x) %in% c("parameters_model")) && "Parameter" %in% names(x)) {
#     vals <- list()
#
#     for (param in x$Parameter) {
#       vals[[param]] <- as.list(x[x$Parameter == param, ])
#     }
#   } else if ("values" %in% names(x)) {
#     vals <- x$values
#   } else if ("report" %in% class(x)) {
#     vals <- as.list(x$tables$table_long, ...)
#   } else {
#     as.list(x, ...)
#   }
#   vals
# }






#' Create or test objects of class [report].
#'
#' Allows to create or test whether an object is of the `report` class.
#'
#' @param x An arbitrary R object.
#' @param text Text obtained via `report_text()`
#' @param table Table obtained via `report_table()`
#' @param plot Plot obtained via `report_plot()`. Not yet implemented.
#' @param summary Add a summary as attribute (to be extracted via `summary()`).
#' @param prefix The prefix to be displayed in front of each parameter.
#' @param ... Args to be saved as attributes.
#'
#' @return A report object or a `TRUE/FALSE` value.
#'
#' @export
as.report <- function(text, table = NULL, plot = NULL, ...) {
  class(text) <- unique(c("report", class(text)))
  attributes(text) <- c(attributes(text), list(...))

  if (!is.null(table)) {
    attr(text, "table") <- table
  }

  text
}



#' @rdname as.report
#' @export
is.report <- function(x) inherits(x, "report")
