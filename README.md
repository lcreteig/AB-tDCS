---
title: "AB-tDCS: Overview"
output:
  rmdformats::html_docco:
    includes:
      after_body: footer.html
    css: style.css
---

[![DOI](https://zenodo.org/badge/177798991.svg)](https://zenodo.org/badge/latestdoi/177798991)

In this study we examined whether electrical brain stimulation of the prefrontal cortex can change the size of the [attentional blink](http://www.scholarpedia.org/article/Attentional_blink).

* __Project title__: _Effects of tDCS on the attentional blink revisited: A statistical evaluation of a replication attempt_
* __Project code__: AB-tDCS
* __Authors__: Reteig, L.C., Newman, L.A., Ridderinkhof, K.R., & Slagter, H.A.
* __Affiliation__: Department of Psychology, University of Amsterdam
* __Year__: 2021

Don't hesitate to get in touch if you have any questions; find my contact details on [my personal website](https://lcreteig.github.io).

# Resources

__Project website__: <https://lcreteig.github.io/AB-tDCS>

__Published paper__: [PLOS ONE](https://doi.org/10.1371/journal.pone.0262718)

__Preprint__: [bioRxiv](https://doi.org/10.1101/2021.06.16.448698)

__Behavioral data and other resources__: [Open Science Framework (OSF)](https://osf.io/y6hsf/)

__EEG data__: [OpenNeuro](https://openneuro.org/datasets/ds001810)

__Code__: [GitHub](https://github.com/lcreteig/AB-tDCS)


# Project setup

## Directory structure

After downloading everything from Github and/or the OSF, your directory structure should look like this (N.B. this is just a sketch; does not include every single file):

```
AB-tDCS
│   AB-tDCS.Rproj
|   renv.lock
│
└───data
│   │   subject_info.csv
│   │   tDCS_AE.csv
│   │   AB-tDCS_study1.txt
│   │
│   └───S01
│   │   │   AB_S01_1B_pre.txt
│   │   │   AB_S01_1B_tDCS.txt
│   │   │   AB_S01_1B_post.txt
│   │   │   AB_S01_2D_pre.txt
│   │   │   AB_S01_2D_tDCS.txt
│   │   │   AB_S01_2D_post.txt
│   │   
│   └───S02
│       │  ...
│
└───docs
│
└───paper
│   │   AB-tDCS_paper.Rmd
│   │   AB-tDCS_paper_appendix.Rmd
│   │   AB-tDCS.bib
│   │
│   └───figures
│   
└───records
│   │   participant_log.csv
│   │   study_protocol.pdf
│   │   tDCS_blinding.md
│   │
│   └───questionnaires
│
└───renv
│   │   .gitignore
│   │   activate.R
│   │   settings.dcf
│
└───site
│   │   _site.yml_
│   │   build_site.R
│   │   footer.html
│   │   header.html
│   │   styles.css
│
└───src
│   │   AB-tDCS_anodal-vs-cathodal.Rmd
│   │   AB-tDCS_change-from-baseline.Rmd
│   │   AB-tDCS_group.Rmd
│   │   AB-tDCS_questionnaires.Rmd
│   │   AB-tDCS_replication-analyses.Rmd
│   │
│   └───func
│   │   │   behavioral_analysis.R
│   │   │   load_data.Rmd
│   │   │   
│   └───lib
│       │   appendixCodeFunctionsJeffreys.R
│       │   corr_change_baseline.R
│   
└───task
    │   AB_tDCS-EEG.exp
    │   mainTask.sce
    │   practice.sce
```

## Descriptions

* `AB-tDCS.Rproj`: Config file with options for the R project; also determines top-level folder.
* `renv.lock`: Contains information on all the packages and their versions that were used for this project, and (along with the contents of the `renv/` folder) can be used to recreate the computational environment

N.B. The following folders each have their own `README.md` (GitHub) and/or wiki page (OSF) with more detailed information on their contents.

* `EEG/`: Metadata files and one example subject for an EEG dataset in [BIDS] format associated with this project (see [Resources]).
* `data/`: All the behavioral and metadata collected during this project, as well as the task data from [London & Slagter (2021)](https://doi.org/10.1162/jocn_a_01679).
* `docs/`: Holds the project website's files
* `paper/`: `AB_tDCS_paper.Rmd` is the R Markdown source file for the paper; running it produces the rendered version on this website (`.html`) and the preprint (`.pdf`)
* `records/`: Documentation, logbooks and protocols
* `site/`: Source code for the website; runs the source code in `paper/` and `src/` to produce the website as in `docs/`
* `src/`: All other analysis code used in the project
* `task/`: Code for the experimental task used during data collection

# Reproducibility

1. Make sure you've downloaded all the data and code and that they're placed in the `data`, `src` and `paper` folders (as outlined in the [Directory structure] section). To do so:
    - Download or clone the [GitHub](https://github.com/lcreteig/AB-tDCS) repository, using the big green "Code" button in the top right.
    - From the Open Science Framework, download the contents of the [Data](https://osf.io/rju7f/) and [Records](https://osf.io/ka3xp/) (optional) components.
    - Download `appendixCodeFunctionsJeffreys.R` per the instructions in `src/README`, and place in `src/lib`.
2. Open the `AB-tDCS.Rproj` file in [RStudio](https://www.rstudio.com/).
3. Run the command `renv::restore()` in the Console to install all the required packages in a separate library for this project.
4. If you're interested in recreating the paper, run the command `tinytex::install_tinytex()` to install a LaTeX distribution, which will enable you to build the pdf.

> 💡 Or, if you just want to quickly play around with the code, simply click this link to create a remote RStudio session in your browser with [Binder](https://mybinder.org/): [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/lcreteig/AB-tDCS/master?urlpath=rstudio)
>
> This will already set everything up for you on the server, including all packages (and LaTeX) that the analysis code depends upon.

Then, run the `.Rmd` notebooks in the `src` folder to reproduce the contents under the _Analyses_ tab on the project website. These contain all analyses (and their results) performed for this project.

Run the `paper/AB-tDCS_paper.Rmd` notebook to reproduce all the results, figures and statistics, and the paper as under the _Paper_ tab on the project website, or in the preprint (see [Resources]).

# Licensing

All components of this project are open and under non-restrictive licenses:

* The data are released to the public domain under a [CC0 1.0 Universal license](https://creativecommons.org/publicdomain/zero/1.0/)

* The preprint and other written materials are licensed under a [CC-By Attribution 4.0 International license](https://creativecommons.org/licenses/by/4.0/)

* The code is licensed under the [MIT license](https://tldrlegal.com/license/mit-license)
