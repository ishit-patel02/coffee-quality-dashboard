# Run from the project folder: Rscript --vanilla run.R
if (!all(file.exists(c("global.R", "ui.R", "server.R")))) {
  stop("Open the coffee-quality-dashboard folder before running this script.",
       call. = FALSE)
}

project_library <- file.path(getwd(), ".R-library")
if (dir.exists(project_library)) .libPaths(c(project_library, .libPaths()))

packages <- c("shiny", "bslib", "ggplot2", "plotly", "DT", "fmsb")
available <- vapply(packages, requireNamespace, logical(1), quietly = TRUE)
if (!all(available)) {
  stop(paste("Missing packages:", paste(packages[!available], collapse = ", "),
             "\nRun Rscript --vanilla install.R first."), call. = FALSE)
}

shiny::runApp(".", host = "127.0.0.1", port = 3838, launch.browser = TRUE)
