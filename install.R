# Run from the project folder: Rscript --vanilla install.R
# These are the six packages directly used by the dashboard.
packages <- c("shiny", "bslib", "ggplot2", "plotly", "DT", "fmsb")

if (getRversion() < "4.1.0") {
  stop("R 4.1 or newer is required. A current R release is recommended.", call. = FALSE)
}

# Keep project packages separate from your other R projects.
project_library <- file.path(getwd(), ".R-library")
dir.create(project_library, recursive = TRUE, showWarnings = FALSE)
.libPaths(c(project_library, .libPaths()))
options(timeout = max(300, getOption("timeout")))

# Install required packages and their dependencies from CRAN.
# Versions are deliberately not guessed; tested versions are in docs/VALIDATION.md.
install.packages(packages, lib = project_library,
                 repos = "https://cloud.r-project.org", dependencies = NA)

available <- vapply(packages, requireNamespace, logical(1), quietly = TRUE)
if (!all(available)) {
  stop(paste("Installation incomplete:", paste(packages[!available], collapse = ", ")),
       call. = FALSE)
}
message("Dependencies are ready. Run: Rscript --vanilla run.R")
