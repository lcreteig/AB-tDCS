library("tidyr")
library("dplyr")

dataDir <- "data" #data directory (relative to project root)
dataFile <- "AB-tDCS_SPSS_18Dec_VoorLeon.txt"

inData <- read.table(file.path(dataDir, dataFile), header = TRUE, dec = ",") # data is in wide format

groupData <- inData %>%
  # Keep only relevant columns
  select(fileno, First_Session, #IDs
         vb_T1_2_NP, vb_T1_4_NP, vb_T1_10_NP, #anodal, pre, T1
         tb_T1_2_NP, tb_T1_4_NP, tb_T1_10_NP, #anodal, tDCS, T1
         nb_T1_2_NP, nb_T1_4_NP, nb_T1_10_NP, #anodal, post, T1
         vd_T1_2_NP, vd_T1_4_NP, vd_T1_10_NP, #cathodal, pre, T1
         td_T1_2_NP, td_T1_4_NP, td_T1_10_NP, #cathodal, tDCS, T1
         nd_T1_2_NP, nd_T1_4_NP, nd_T1_10_NP, #cathodal, post, T1
         vb_NB_2_NP, vb_NB_4_NP, vb_NB_10_NP, #anodal, pre, T2|T1
         tb_NB_2_NP, tb_NB_4_NP, tb_NB_10_NP, #anodal, tDCS, T2|T1
         nb_NB_2_NP, nb_NB_4_NP, nb_NB_10_NP, #anodal, post, T2|T1
         vd_NB_2_NP, vd_NB_4_NP, vd_NB_10_NP, #cathodal, pre, T2|T1
         td_NB_2_NP, td_NB_4_NP, td_NB_10_NP, #cathodal, tDCS, T2|T1
         nd_NB_2_NP, nd_NB_4_NP, nd_NB_10_NP  #cathodal, post, T2|T1
         ) %>% 
  rename(subject = fileno, first.session = First_Session) %>% # rename columns to match those in study 2
  gather(ID, performance, -subject, -first.session) %>% # make long form
  separate(ID, c("block", "stimulation", "target", "lag"), c(1,3,5)) %>% # create columns for factors
  mutate(performance = performance *100) %>% # convert to percentage correct
  # create factors, relabel levels
  mutate(block = factor(block, levels = c("v", "t", "n"), labels = c("pre", "tDCS", "post"))) %>%
  mutate(stimulation = factor(stimulation, levels = c("b_", "d_"), labels = c("anodal", "cathodal"))) %>%
  mutate(lag = factor(lag, levels = c("_2_NP", "_4_NP", "_10_NP"), labels = c(2, 4, 10))) %>%
  mutate(first.session = factor(first.session, labels = c("anodal","cathodal"))) %>%
  # create separate columns for T2.given.T1 and T1 performance
  spread(target, performance) %>% 
  rename(T2.given.T1 = NB)