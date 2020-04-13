Just another opinionated daily report generator regarding the COVID19 pandemic
==============================================================================

The objective of this project is to create a daily report (maybe in PDF), with some updated charts and a table of contents with links to each country.

Requirements
------------

* Bash
* R
* R packages: dplyr, ggplot2

Instructions
------------
Before running the R scripts, you should update the data CSV files, by issuing:

```bash
./download-files.sh
```

After that, you have to run R and import the source file:

```R
source("stacked-charts.R")
```

In order to show the worldwide epidemy evolution, just write:

```R
covid19_stacked_chart()
```

If you want to see the same data for a specific country:

```R
covid19_stacked_chart("Spain")
```

To see the daily new events type distribution, you can use the `covid19_stacked_bar_chart`:

```R
covid19_stacked_bar_chart("Spain")
```


The list of different countries can be found in the CSV data files.




