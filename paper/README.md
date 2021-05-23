This folder contains the files that make up the journal article.

# Files

* `AB-tDCS_paper.Rmd` The [Rmarkdown](https://rmarkdown.rstudio.com/) source file for the paper. Contains the text and the code to produce the figures and statistical results.
* `AB-tDCS_paper.pdf` The rendered version of the paper (see below).
* `figures/figure_1_procedure.png` and `figures/figure_2_task.png` These figures are the only ones that were not generated through code, so they need to be present
* `AB-tDCS_appendix.Rmd` Supplemental material (automatically integrated with `AB_tDCS_paper.Rmd`).
* `AB-tDCS.bib` A [BibTeX](www.bibtex.org/) file containing the bibliographic information of the references cited in the paper.

# Recreating the finished paper

The `.pdf` is created from these files using the [`papaja` package](https://github.com/crsh/papaja). Simply open the `AB-tDCS_paper.Rmd` file in [RStudio](https://www.rstudio.com/) and click "Knit" (to `apa6_pdf`), or run the following:

``` r
rmarkdown::render("paper/AB-tDCS_paper.Rmd")
```

Alternatively, to recreate the `.html` version on the website, click "Knit" > to `html_document2`, (requires the `bookdown` package), or run

``` r
rmarkdown::render("paper/AB-tDCS_paper.Rmd", output_format = bookdown::html_document2)
```
