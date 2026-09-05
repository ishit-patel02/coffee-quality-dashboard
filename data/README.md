# Dataset access

The dashboard reads `coffee.csv` from the project root, beside `global.R`. This folder documents the data and carries its source licence; it is not the location from which the app reads the CSV.

## Availability and permission

The CSV is included in the repository, so a fresh clone runs without any extra downloads. It is a filtered subset of a file distributed under the MIT Licence, whose notice is reproduced in [DATA-LICENSE.txt](DATA-LICENSE.txt). Keep that notice with any copy you redistribute.

## Original source and public publishers

- **Coffee Quality Institute (CQI):** the organisation whose professional ratings underlie the public collection.
- **James LeDoux:** collected the ratings from CQI review pages in January 2018 and published the [Coffee Quality Database](https://github.com/jldbc/coffee-quality-database).
- **Diego Volpatto:** republished the collection as [Coffee Quality database from CQI on Kaggle](https://www.kaggle.com/datasets/volpatto/coffee-quality-database-from-cqi), explicitly crediting the original GitHub collection.

The GitHub repository is distributed under the MIT Licence, with the data files inside it. The Kaggle page lists “Database: Open Database, Contents: Database Contents”.

## Relationship to the public file

`coffee.csv` was compared against `data/arabica_data_cleaned.csv` in LeDoux's repository:

- All 24 of its columns appear among that file's 44.
- All 772 of its rows match rows there on the twelve sensory measures and the bag count, with no unmatched rows.
- Differences are confined to label cleaning: accents removed from in-country partner names (121 rows, for example “Almacafé” to “Almcafe”), combined harvest years reduced to a single year (40 rows, for example “2015/2016” to “2015”), and one encoding fix for “Cote d?Ivoire”.
- The row selection appears to keep records that are complete across these 24 columns.

This establishes it as a filtered subset of the MIT-licensed file rather than a separately sourced dataset. Redistribution under that licence requires keeping the copyright notice, which [DATA-LICENSE.txt](DATA-LICENSE.txt) does.

Two things this does not settle: MIT is a software licence being applied to data, which is the convention in this dataset's ecosystem rather than a bespoke data licence; and the underlying ratings are the Coffee Quality Institute's work, collected by scraping. Anyone redistributing this data is in the same position as every other downstream user of the collection.

## Inspected file

- Filename: `coffee.csv`
- Size: 143,463 bytes (about 140 KiB)
- Shape: 772 rows and 24 columns
- Species: Arabica
- Countries: 29
- Harvest years: 2011–2018
- No blank/NA cells or exact duplicate rows were found, but some measurements use zero or implausible values.

## Required columns

Keep these exact column names:

```text
Species
Country.of.Origin
Region
Producer
Number.of.Bags
In.Country.Partner
Harvest.Year
Grading.Date
Processing.Method
Aroma
Flavor
Aftertaste
Acidity
Body
Balance
Uniformity
Clean.Cup
Sweetness
Cupper.Points
Total.Cup.Points
Moisture
altitude_low_meters
altitude_high_meters
altitude_mean_meters
```

Origin, producer, partner, method and date/year fields contain labels. Bag counts, sensory scores, total scores, moisture and altitude fields must be numeric. Sensory components are on a 0–10 scale and total cup points on a 0–100 scale. Moisture is stored as a fraction, so `0.12` means 12%; altitude columns use metres.

The app trims country, region, producer and processing labels; standardises case for the latter three; and extracts a four-digit harvest year. It does not rewrite the original CSV. Most altitude calculations keep only `0 < altitude_mean_meters < 4000`; moisture calculations generally keep only positive values. The matching feature requires positive, non-missing values for all nine sensory attributes.

Producer fields carry labels that can name people as well as organisations. They are reproduced from the public collection unchanged. The upstream columns holding owner, company, farm name, lot number, ICO number and certification contact and address details are not part of this subset.

## Replacing the file

The app reads whatever `coffee.csv` sits in the repository root. To analyse different records, replace that file, keeping the exact filename and the column names listed above, then run:

```bash
Rscript --vanilla run.R
```

Several figures quoted in the README and in the dashboard's explanatory text describe the supplied 772 rows. Replacing the data means reviewing those statements and the fixed chart limits.
