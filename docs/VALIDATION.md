# Validation notes

Checked on 5 September 2026. These checks describe the prepared copy of the supplied project, not a published GitHub repository.

## Tested environment

- macOS, Apple Silicon
- R 4.6.0

| Direct package | Installed and tested version |
| --- | --- |
| shiny | 1.14.0 |
| bslib | 0.12.0 |
| ggplot2 | 4.0.3 |
| plotly | 4.12.1 |
| DT | 0.34.0 |
| fmsb | 0.7.6 |

The installer obtains available CRAN versions; it is not a lockfile. Supporting packages from the existing R installation were reused. The bslib and plotly binaries reported that they were built under R 4.6.1; they loaded and passed the checks under R 4.6.0. Windows, Linux and an entirely empty R package installation were not tested.

## Completed checks

- Parsed all ten application source files and both startup/install scripts.
- Installed all six direct dependencies into the project's ignored `.R-library/` folder.
- Loaded the CSV and confirmed 772 rows, 24 original columns, 29 countries, 2011–2018 harvest years, a mean total score of 82.065 and a range of 59.83–90.58.
- Constructed the Shiny application and its complete interface.
- Exercised the six modules with Shiny's server-testing interface: overview counts and scorecard; country map/table data and bag filters; profile plots and year/origin selections; growing-condition charts and an empty method selection; sensory plots and three correctly ordered matches; conclusion cards.
- Checked empty selections for Global and Profile.
- Opened the app in a browser, checked the Overview and map, and confirmed a country-table link opens the matching Profile.
- Re-ran all six module checks after the dataset rename and dialog removal. Captured new Overview and Global screenshots from the cleaned app.
- Checked the intended upload files for credentials, private identifiers, personal author details, local paths and large files. No credential values were detected.
- Created a temporary local Git repository from the 18 intended upload files, cloned it into a separate folder, and installed dependencies there. Confirmed that neither the CSV nor `.R-library/` was present in the clone. Startup without data gave the documented missing-file message; adding the local CSV allowed `run.R` to start the app, which opened in the browser. This check predates the decision to track `coffee.csv`, so the clone test needs re-running against the current file set.
- Compared `coffee.csv` against `data/arabica_data_cleaned.csv` from the Coffee Quality Database. All 24 columns appear among that file's 44, and all 772 rows match on the twelve sensory measures and bag count, with none unmatched. Differences are limited to accent stripping in partner names, single-year harvest labels and one encoding fix. The upstream owner, company, farm, lot, ICO and certification-contact columns are absent from the subset, and the file contains no email addresses or URLs.

## Source corrections

- Fixed a syntax error in `R/helpers.R`: the multi-line `measure_limits()` conditional needed braces to parse correctly. This prevented the supplied source from starting.
- Removed the optional information dialog and its header link.
- Renamed the local dataset to `coffee.csv` and updated all application/documentation references while keeping the data bytes unchanged.
- Added project-focused descriptions and added verified public dataset-source credits.
- Added a helpful missing-CSV message and clarified the map's possible internet requirement.
- Finished the incomplete conclusion sentence and replaced unsupported causal/significance claims with descriptions of what the analysis actually computes.
- Clarified correlation and score-similarity wording, corrected a spelling error and the heatmap colour explanation, and aligned map/profile descriptions with their actual outputs.
- Kept the existing source layout and original calculations, apart from the syntax repair.

## Remaining release requirements

- Re-run the clone check now that `coffee.csv` is tracked, confirming a fresh clone starts the app with no extra downloads.
- Confirm permission to publish the screenshots.

Resolved since the first pass: the code is released under the MIT Licence (`LICENSE`); `coffee.csv` is tracked as a subset of an MIT-licensed public dataset, with the upstream notice kept in `data/DATA-LICENSE.txt`; and the README's name and GitHub placeholders have been replaced.

Passing local checks does not resolve the remaining requirements. No GitHub repository has been created or uploaded as part of this preparation.

The local-clone check reused supporting packages from the same computer, so it is not a test on a completely new machine. A Plotly click-registration warning was also observed before the hidden Global chart was first rendered; the plot already registers its click event, and the map and country-table navigation rendered successfully. This warning should be reviewed if map navigation fails in another environment.
