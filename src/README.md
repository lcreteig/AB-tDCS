These [R Markdown](http://rmarkdown.rstudio.com/) files contain all analysis code used for the project.

* `AB-tDCS_anodal-vs-cathodal.Rmd`
* `AB-tDCS_change-from-baseline.Rmd`
* `AB-tDCS_group.Rmd`
* `AB-tDCS_questionnaires`
* `AB-tDCS_replication-analyses.Rmd`

Simply open an `Rmd` file in [RStudio](https://www.rstudio.com/) and click "Run" to run the code.

See the `docs/` folder for the `html` versions of the files, which contain all the output of the code as well.

# `/func`

Functions written specifically for this project:

* `behavioral_analysis.R`: collection of functions for loading and tidying data, displayed and called in the `.Rmd`
* `load_data.Rmd` contains code to load data from study 1 and 2, which is also called and displayed in all the `.Rmd` files

# `/lib`

Other code not written specifically for this project that is not available in package format:

* `appendixCodeFunctionsJeffreys.R` computes replication Bayes Factors as described in [Ly & Wagenmakers (2016)](http://doi.org/10.3758/s13428-015-0593-0), and was downloaded from their [OSF page](https://osf.io/cabmf/)
* `corr_change_baseline.R` implements test for correlation between baseline (_test_) and change scores (_retest - test_), as further described [here](http://imaging.mrc-cbu.cam.ac.uk/statswiki/FAQ/rxxy_correction)
