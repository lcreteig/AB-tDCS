Necessary files to create the [Rmarkdown website](https://rmarkdown.rstudio.com/lesson-13.html):

* `_site.yml` defines the general site layout
* `build_site.R` collects the necessary source files, renders to `html`, and then copies these to `/docs`
* `header.html` and `footer.html` contain some more info added to each page
* `style.css` overrides the default for the home page
