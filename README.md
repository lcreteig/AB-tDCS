---
title: "AB-tDCS: Overview"
output:
  rmdformats::html_docco:
    includes:
      after_body: footer.html
    css: style.css
---

In this study we examined whether electrical brain stimulation of the prefrontal cortex can change the size of the [attentional blink](http://www.scholarpedia.org/article/Attentional_blink).

* __Project title__: _Effects of tDCS on the attentional blink revisited: A statistical evaluation of a replication attempt_
* __Project code__: AB-tDCS
* __Authors__: Reteig, L.C., Newman, L.A., Ridderinkhof, K.R., & Slagter, H.A.
* __Affiliation__: Department of Psychology, University of Amsterdam
* __Year__: 2019

Don't hesitate to get in touch if you have any questions; find my contact details on [my personal website](https://lcreteig.github.io).

# Resources

__Project website__: project website link FIXME

__Preprint__: bioRxiv - [bioRxiv link FIXME]

__Behavioral data and other resources__: Open Science Framework (OSF) - [OSF link FIXME]

__EEG data__: OpenNeuro - [OpenNeuro link FIXME]

__Code__: GitHub - [GitHub link FIXME]


# Project setup

## Directory structure

After downloading everything from Github and/or the OSF, your directory structure should look like this (N.B. this is just a sketch; does not include every single file):

```
AB-tDCS
│   AB-tDCS.Rproj
│   install.R
│   runtime.txt
│
└───data
│   │   subject_info.csv
│   │   tdcs_AE.csv
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
* `install.R` and `runtime.txt`: configuration files for running the code in the GitHub repository remotely with [Binder](https://mybinder.org/).

N.B. The following folders each have their own `README.md` (GitHub) and/or wiki page (OSF) with more detailed information on their contents.

* `EEG/`: Metadata files and one example subject for an EEG dataset in [BIDS] format associated with this project (see [Resources]).
* `data/`: All the behavioral and metadata collected during this project, as well as the task data from [London & Slagter (2015)](https://doi.org/10.1162/jocn_a_00867).
* `docs/`: Holds the project website's files
* `paper/`: `AB_tDCS_paper.Rmd` is the R Markdown source file for the paper; running it produces the rendered version on this website (`.html`) and the preprint (`.pdf`)
* `records/`: Documentation, logbooks and protocols
* `site/`: Source code for the website; runs the source code in `paper/` and `src/` to produce the website as in `docs/`
* `src/`: All other analysis code used in the project
* `task/`: Code for the experimental task used during data collection

# Reproducibility

1. Make sure you've downloaded all the data and code and that they're placed in the `data`, `src` and `paper` folders (as outlined in the [Directory structure] section).
2. Open the `AB-tDCS.Rproj` file in [RStudio](https://www.rstudio.com/).

Alternatively, skip these steps and follow this link to create a remote RStudio session in your browser with [Binder](https://mybinder.org/): [![Binder](https://mybinder.org/badge.svg)](FIXME add link)

This will already set everything up for you on the server, including all packages that the analysis code depends upon.

Then, run the `.Rmd` notebooks in the `src` folder to reproduce the contents under the _Analyses_ tab on this website. These contain all analyses (and their results) performed for this project.

Run the `paper/AB-tDCS_paper.Rmd` notebook to reproduce all the results, figures and statistics, and the paper as under the _Paper_ tab or in the preprint (see [Resources]).

# Licensing

All components of this project are open and under non-restrictive licenses:

* The data are released to the public domain under a [CC0 1.0 Universal license](https://creativecommons.org/publicdomain/zero/1.0/)

* The preprint and other written materials are licensed under a [CC-By Attribution 4.0 International license](https://creativecommons.org/licenses/by/4.0/)

* The code is licensed under the [MIT license](https://tldrlegal.com/license/mit-license)
