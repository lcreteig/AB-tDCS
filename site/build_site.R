
###------------------------------------copy files to folder

# render_site wants all files to be in same folder, and that way we don't have to exclude files either
site_src <- "site" # in project root
site_rendered <- "docs" # in project root, should be named "docs" for gh-pages

# index
file.copy("README.md", file.path(site_src, "index.Rmd"), overwrite = TRUE) # copy to website folder

# analyses
# names of all the notebooks
nbs <- c("AB-tDCS_group.Rmd", "AB-tDCS_change-from-baseline.Rmd", "AB-tDCS_anodal-vs-cathodal.Rmd",
         "AB-tDCS_replication-analyses.Rmd", "AB-tDCS_questionnaires.Rmd")
file.copy(file.path("src", nbs), site_src, overwrite = TRUE) # copy all files) # copy to website folder

# paper
# with auxiliary files
paper_files <- c("AB-tDCS_paper.Rmd", "AB-tDCS_appendix.Rmd", "AB-tDCS.bib", "r-references.bib")
dir.create(file.path(site_src, "figures"))
figure_files <- c("figures/figure_1_procedure.png","figures/figure_2_task.png")
file.copy(file.path("paper", paper_files), 
          site_src, overwrite = TRUE, recursive = TRUE) # copy all files
file.copy(file.path("paper", figure_files), 
          file.path(site_src, "figures"), overwrite = TRUE, recursive = TRUE) # copy all files

###------------------------------------render

rmarkdown::render_site(file.path(site_src, "index.Rmd")) # home page
invisible(lapply(file.path(site_src,nbs), rmarkdown::render_site, output_format = "rmdformats::html_clean")) # notebooks
rmarkdown::render_site(file.path(site_src, "AB-tDCS_paper.Rmd"), output_format = "bookdown::html_document2") # paper page

###------------------------------------copy output

# copy only the files necessary to render the website
to_copy <- c("index.html", 
             gsub(pattern = ".Rmd", replacement = ".html", x = nbs),
             gsub(pattern = ".Rmd", replacement = "_files", x = nbs),
             "AB-tDCS_paper.html","AB-tDCS_paper_files","figures",
             "style.css","header.html","footer.html",
             "site_libs")
file.copy(file.path(site_src,"_site", to_copy), site_rendered, overwrite = TRUE, recursive = TRUE)

###------------------------------------clean-up

# delete all that remains
unlink(file.path(site_src, c(paper_files,"_site",nbs,"index.Rmd","figures")), recursive = TRUE)
