# Global Coffee Quality Assessment Platform

Explore how coffee origin, growing conditions and tasting scores relate through an interactive R Shiny dashboard.

<p align="center">
  <img src="assets/00-hero.png"
       alt="Top of the dashboard's Overview page, showing the six navigation tabs and summary cards for 772 coffees, 29 countries, 249 growing regions and 456 producers"
       width="900">
</p>

<p align="center"><em>The opening view summarises 772 coffee evaluations from 29 countries.</em></p>

## Overview

This project turns a table of coffee evaluations into six connected pages of charts, maps and comparisons. You can explore countries, inspect an origin's sensory profile, compare processing methods, and find recorded coffees with scores close to a flavour profile you choose.

It was designed for readers who want to understand the data without writing their own analysis, including coffee enthusiasts and people learning dashboard design.

**Data access:** `coffee.csv` is included in the repository, so a fresh clone runs without any extra downloads. It is a filtered subset of an MIT-licensed public dataset; see [data access and columns](data/README.md).

## Project motivation

The dashboard brings coffee evaluations into one place so readers can explore differences between origins, processing methods and sensory profiles through interactive visualisations. It explores recorded coffee quality; it does not determine which coffee everyone will enjoy.

## Dashboard highlights

The dashboard has six connected pages. Each is described below, with a full-page screenshot you can open.

### 1. Overview

Dataset counts, an average scorecard and short explanations of every tasting attribute, so a reader can start without any prior knowledge of coffee grading. The top of this page is the image above.

<details>
<summary>View the full Overview page</summary>

<br>

![Full Overview page showing dataset summary cards, the average scorecard donut with per-attribute bars, definitions of all nine sensory attributes, and navigation cards to each stage of the analysis](assets/01-overview.png)

</details>

### 2. Global

A shaded world map, a sortable country ranking table, bag-count filtering and a chart plotting each country's average against the number of coffees behind it. Selecting a country in the table opens its profile.

<details>
<summary>View the full Global page</summary>

<br>

![Full Global page showing a shaded world map of coffee origins beside a sortable country ranking table, summary cards, and a scatter plot of average score against sample size](assets/02-global-map.png)

</details>

### 3. Country profile

Country and harvest-year selection, an average scorecard for the origin, region and producer breakdowns, processing-method comparisons, a score distribution and a sensory radar chart against the dataset average.

<details>
<summary>View the full Country profile page</summary>

<br>

![Full Profile page for Mexico showing its average scorecard, a treemap and scatter of regions, processing-method pie and boxplots, a score distribution histogram, altitude and moisture boxplots, and a flavour radar chart](assets/03-country-profile.png)

</details>

### 4. Growth conditions

Processing-method boxplots, altitude and moisture scatterplots with trend lines, and a heatmap combining altitude and moisture bands across the full scored dataset.

<details>
<summary>View the full Growth conditions page</summary>

<br>

![Full Growth Conditions page showing total cup points boxplots by processing method, scatter plots of score against altitude and moisture, and a heatmap of mean score by altitude and moisture band](assets/04-growth-conditions.png)

</details>

### 5. Sensory analysis

Attribute correlations with the score, a clickable scatter that reveals any single coffee's ten-component breakdown, and a nine-slider finder returning the closest recorded coffees.

<details>
<summary>View the full Sensory analysis page</summary>

<br>

![Full Sensory Analysis page showing attributes ranked by correlation with the score, a scatter of one attribute against total score with a selected coffee's component breakdown, and the flavour-profile sliders with the closest matching coffees](assets/05-sensory-analysis.png)

</details>

### 6. Conclusion

Summary cards for the highest-scoring origin, altitude band and moisture band, followed by key findings and guidance on how far the comparisons can reasonably be taken.

<details>
<summary>View the full Conclusion page</summary>

<br>

![Full Conclusion page showing highest-scoring country, altitude and moisture cards, six key-finding cards, and a closing summary about the limits of the comparisons](assets/06-conclusion.png)

</details>

## How it works

```text
Authorised local CSV
        ↓
Trim labels, standardise case and extract harvest years
        ↓
Choose a page and adjust its controls
        ↓
Filter records and calculate summaries or score differences
        ↓
View charts, tables, comparisons and matching coffees
```

`global.R` loads the data once when the app starts. `ui.R` defines the page layout, and `server.R` connects the controls to the calculations. Each page has its own module in `R/`; Shiny loads these files automatically.

Filters belong to individual pages. For example, the Global bag-count filter does not carry into Profile: selecting a country opens its profile, where the harvest-year control determines the records shown. Growth Conditions and Sensory Analysis use the full scored dataset.

The coffee finder calculates the average absolute difference between your nine requested sensory scores and each eligible coffee's scores. It returns the three smallest differences, using the higher total score to break ties. Its displayed match percentage is `100 × (1 − average difference / 9)`. This is a similarity measure, not prediction accuracy or a probability.

The trend lines use simple linear fits. The attribute bars show correlations. There is no trained machine-learning model or model file.

## Technologies used

| Technology | Role |
| --- | --- |
| R | Data cleaning, calculations and application logic |
| Shiny | Interactive browser application |
| bslib | Page layout, cards, tabs and styling |
| ggplot2 | Statistical charts |
| plotly | Interactive world map and processing-method pie charts |
| DT | Sortable, paginated country ranking table |
| fmsb | Sensory radar charts |
| HTML, CSS and small JavaScript handlers | Presentation and navigation between pages |

Data manipulation mostly uses functions included with R. Python, pandas, TensorFlow, `maps` and a database are not required.

## Project structure

```text
coffee-quality-dashboard/
├── README.md
├── LICENSE
├── .gitignore
├── install.R
├── run.R
├── global.R
├── ui.R
├── server.R
├── coffee.csv
├── R/
│   ├── introduction.R
│   ├── location.R
│   ├── profile.R
│   ├── analysis.R
│   ├── flavor.R
│   ├── conclusion.R
│   └── helpers.R
├── assets/
│   ├── 00-hero.png
│   ├── 01-overview.png
│   ├── 02-global-map.png
│   ├── 03-country-profile.png
│   ├── 04-growth-conditions.png
│   ├── 05-sensory-analysis.png
│   └── 06-conclusion.png
├── data/
│   ├── README.md
│   └── DATA-LICENSE.txt
└── docs/
    └── VALIDATION.md
```

- `install.R` lists and installs the six required R packages.
- `run.R` starts the dashboard on your computer.
- `global.R`, `ui.R`, `server.R` and `R/` contain the application.
- `assets/` contains the numbered full-page screenshots and the cropped hero image. Numbered files can be replaced in place, keeping the same filenames.
- `coffee.csv` is the dataset the app reads; `data/` documents it and carries its source licence notice.
- `docs/VALIDATION.md` records the tested setup, checks and remaining limits.

One local item is intentionally absent from the tracked tree: `.R-library/`, which is created during installation.

## Dataset

The local file is called `coffee.csv`. The ratings originate from the **Coffee Quality Institute (CQI)**. The related public collection was assembled by **James LeDoux**, who reports collecting CQI review data in January 2018; **Diego Volpatto** later republished it on Kaggle and credits the original collection.

- [James LeDoux’s Coffee Quality Database](https://github.com/jldbc/coffee-quality-database)
- [Diego Volpatto’s Kaggle republication](https://www.kaggle.com/datasets/volpatto/coffee-quality-database-from-cqi)

The supplied file was checked against LeDoux's `arabica_data_cleaned.csv`: all 24 of its columns appear in that file, and all 772 of its rows match rows there on the twelve sensory measures and bag count. It is a filtered subset of that file, with accents stripped from partner names and combined harvest years reduced to a single year. That file is distributed under the MIT Licence, which permits redistribution when the copyright notice is kept, so the notice is reproduced in [data/DATA-LICENSE.txt](data/DATA-LICENSE.txt).

The columns carrying owner, company, farm, lot, ICO and certification-contact details in the upstream file are not present in this subset.

The file contains:

- **772 rows and 24 columns**, about **140 KiB**.
- **Arabica coffee only**, from **29 countries**.
- Harvest years from **2011 to 2018**.
- Origin, region, producer, grading partner, processing method, bag count, sensory scores, moisture and altitude fields.
- Nine sensory attributes, a grader's overall mark and total cup points.

After the application's label cleaning, it identifies 249 country/region combinations and 456 distinct producer labels. These are labels in this dataset, not verified counts of distinct farms worldwide.

Some questionable measurements are excluded from particular charts: altitude analyses use values above 0 and below 4,000 metres, and moisture analyses exclude zero values. The file has six altitude values outside that range and 103 zero-moisture records. Other views can still include those coffees.

The CSV sits in the repository root, beside `global.R`, which is where the application reads it from.

## Installation and running

### Prerequisites

- A current installation of [R](https://cran.r-project.org/). The source uses R's native pipe, so R 4.1 or newer is needed; testing used R 4.6.0 on macOS.
- [Git](https://git-scm.com/downloads) to clone the repository, or use GitHub's **Code → Download ZIP** option.
- A web browser.
- Internet access to install R packages. The world map may also retrieve geographic boundary data from Plotly's CDN.

RStudio is optional. No Python virtual environment, API key, `.env` file or account sign-in is required by the dashboard.

### 1. Get the project

```bash
git clone https://github.com/ishit-patel02/coffee-quality-dashboard.git
cd coffee-quality-dashboard
```

Cloning downloads a local copy. The second command opens its folder in your terminal. If you downloaded a ZIP instead, extract it and open the extracted folder.

### 2. Install dependencies

```bash
Rscript --vanilla install.R
```

The script installs `shiny`, `bslib`, `ggplot2`, `plotly`, `DT` and `fmsb`, along with packages they need. It places the direct packages in `.R-library/`, which Git ignores. R may reuse supporting packages already installed on your computer.

`--vanilla` prevents saved R sessions and personal startup settings from interfering. Package versions are not locked; the versions actually tested are recorded in [validation notes](docs/VALIDATION.md).

### 3. Start the dashboard

```bash
Rscript --vanilla run.R
```

Keep the terminal open. The app should open your browser at [http://127.0.0.1:3838](http://127.0.0.1:3838). If it does not, open that address yourself. This address runs on your own computer.

Press **Control+C** in the terminal to stop the app.

### Windows and Linux notes

The commands above are the same wherever `Rscript` is available. On Windows, if the terminal cannot find it, open R or RStudio, set the working directory to this project folder, and run these R-console commands:

```r
source("install.R")
source("run.R")
```

In RStudio, use **Session → Set Working Directory → Choose Directory** first. On Linux, install R through the instructions linked from CRAN; installing some packages from source may also require system development libraries. Windows and Linux were not tested in this preparation.

### Common startup problems

- **Missing `coffee.csv`:** the file ships with the repository and belongs beside `global.R`. If it has been moved or renamed, restore it; see `data/README.md`.
- **Missing R package:** run `Rscript --vanilla install.R` and check that installation finishes successfully.
- **Port 3838 is already in use:** stop another running copy of the app, or change `port = 3838` in `run.R` and open the matching address.
- **Blank world map:** check your internet connection and whether Plotly's geographic-data CDN is blocked. The country table still provides the numerical comparison.

## Example usage

1. Start the app and review the counts on **Overview**.
2. Open **Global**, choose **Total Cup Points**, and leave the bag range at its full extent.
3. Select **Ethiopia** in the ranking table to open its **Profile**.
4. Adjust the harvest-year range and open the profile panels to inspect the records behind the averages.
5. Open **Growth Conditions** and compare processing methods, altitude and moisture.
6. Open **Sensory Analysis → Select a Coffee**, adjust the nine sliders, and click **Find Coffee** to see the three closest recorded profiles.

## Results and output

The application produces browser-based charts, tables, summary cards and matching-coffee details. It does not automatically save a report or export a dataset.

For the complete supplied dataset, verified figures are:

| Measure | Value |
| --- | --- |
| Coffee samples | 772 |
| Countries represented | 29 |
| Mean total cup score | 82.07 / 100 |
| Total cup score range | 59.83–90.58 |
| Countries eligible for the ranking at the full bag range | 21 |

Country rankings require at least five samples. These figures describe the supplied file and will change if it is replaced or filtered.

The screenshots in this README show the dashboard running against the supplied local dataset. Results may differ when the data or filters change.

## Limitations

- The historical Arabica sample is uneven across countries and does not represent all coffee production or current market availability.
- Correlation does not establish cause and effect. Sensory scores contribute to the total, which partly explains their correlations with it.
- Heatmap cells can contain few records. No causal analysis, significance testing or predictive-model evaluation is performed.
- Some plots use fixed axes, including a 60–90 total-score range, which can hide extreme values. Relative radar axes can make small differences look large.
- Several explanatory statements are specific to the supplied data; replacing it requires reviewing those statements and chart limits.
- The app expects a specific CSV structure. It has no general file-upload workflow or comprehensive input validation.
- Package versions are not locked, and the map is not guaranteed to work offline.

## Future improvements

- Document the exact filtering steps that produced this 772-row subset.
- Record an R dependency lockfile to make future installations more consistent.
- Add stronger input checks and show excluded-record counts in the interface.
- Show sample counts in heatmap cells and improve uncertainty reporting.
- Make chart limits and explanatory text respond more fully to the data.
- Improve narrow-screen layouts and add a controlled export feature.

## Author

**Ishit Patel**

GitHub: [@ishit-patel02](https://github.com/ishit-patel02)

## Licence

This project is licensed under the MIT Licence. You are free to use, modify and distribute it, provided the copyright and permission notice are kept. See [LICENSE](LICENSE) for the full text.

The licence covers the code in this repository. `coffee.csv` is not the author's work: it is a subset of James LeDoux's Coffee Quality Database, distributed under its own MIT Licence, whose notice is kept in [data/DATA-LICENSE.txt](data/DATA-LICENSE.txt). The underlying ratings are the Coffee Quality Institute's. Keep both notices if you redistribute the data.
