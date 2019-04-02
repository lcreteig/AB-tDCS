## ---- Function to load data from study 2
load_data_study2 <- function(dataDir, subs_incomplete) {
  
  subID = list.dirs(dataDir, full.names = FALSE, recursive = FALSE) # get subject names
  subID = subID[grep("S", subID)];
  numSubjects <- length(subID);
  
  # factors
  #stimulation <- c("Y", "X") # "Y" codes for either anodal or cathodal; "X" codes for the opposite polarity
  stimulation <- c("anodal", "cathodal") # "Y" codes for either anodal or cathodal; "X" codes for the opposite polarity
  tDCScode_batch1 <- c("B", "D") # from S01 through S21, setting "B" corresponds "Y" and setting "D" corresponds to "X"
  tDCScode_batch2 <- c("D", "I") # from S22 onwards, setting "D" corresponds "Y" and setting "I" corresponds to "X"
  block <- c("pre", "tDCS", "post")
  lag <- c(3,8)
  
  # initialize group data frame
  colHeader <- c("subject", "first.session", "stimulation", "block", "lag", "trials", "T1", "T2", "T2.given.T1") # name the variables (column header)
  frameCols <- length(colHeader)
  repRows <- length(stimulation)*length(block)*length(lag) # number of rows in data frame belonging to 1 subject
  frameRows <- numSubjects*repRows
  groupData <- data.frame(matrix(ncol=frameCols, nrow=frameRows)) # create group data frame with appropriate dimensions
  names(groupData) <- colHeader #assign variable names to the data frame
  
  # fill fixed variables
  groupData$subject <- rep(subID, each = repRows)
  groupData$stimulation <- factor(rep(stimulation, each = length(block)*length(lag), times = numSubjects))
  groupData$block <- factor(rep(block, each = length(lag), times = numSubjects), levels = block)
  groupData$lag <- factor(rep(lag, times = numSubjects))
  
  for (iSub in subID) {
    
    if (is.element(iSub, subs_incomplete)) { # if current subject should be excluded, skip to next one
      next
    }
    
    if ( (as.numeric(substr(iSub,2,3))) <= 21) { # if subject was in first batch
      tDCScode <- tDCScode_batch1 # these tDCS codes were used
    } else {
      tDCScode <- tDCScode_batch2
    }
    
    for (iStim in tDCScode) {
      for (iBlock in block) {
        
        # load file(s)
        dataFiles = Sys.glob(file.path(dataDir, iSub, paste("AB_", iSub, "_*", iStim, "_", iBlock, "*.txt", sep = ""))) #file name
        
        for (iFile in 1:length(dataFiles)) { # loop in the case of multiple files
          if (iFile == 1) {
            ABdata <- read.table(dataFiles[iFile], header = TRUE) #load single subject data
            next
          } else {
            tempData <- read.table(dataFiles[iFile], header = TRUE) # load next file, if there is one
            ABdata <- merge(ABdata, tempData, all = TRUE, sort = FALSE) # paste on to bottom of data frame
          }
          
        }
        
        for (iLag in lag) { # for each lag
          
          # extract single-subject measures
          trialsLag <- ABdata$lag == iLag # indices of trials with this lag
          numTrials <- sum(trialsLag) # number of trials of this lag
          
          trialsT1 <- ABdata$T1acc == 1 # indices of T1 correct trials
          T1 <- sum(trialsT1 & trialsLag) / numTrials # proportion of T1 correct trials
          
          trialsT2 <- ABdata$T2acc == 1 # indices of T2 correct trials
          T2 <- sum(trialsT2 & trialsLag) / numTrials  # proportion of T1 correct trials
          nonBlink <- sum(trialsLag & trialsT1 & trialsT2) / sum(trialsLag & trialsT1) # proportion of T2 given T1 correct trials
          
          # insert into data frame
          cellIdx = groupData$subject == iSub & groupData$stimulation == stimulation[tDCScode == iStim] & groupData$block == iBlock & groupData$lag == iLag # get index of current cell
          # fill with data
          groupData$trials[cellIdx] <- numTrials
          groupData$T1[cellIdx] <- T1
          groupData$T2[cellIdx] <- T2
          groupData$T2.given.T1[cellIdx] <- nonBlink
        }
        
      }
      
      if (grepl(paste("1", iStim, sep = ""), dataFiles[iFile])) { # if current file was the 1st session
        groupData$first.session[groupData$subject == iSub] <- stimulation[tDCScode == iStim] # store the stimulation type
      }
      
    }
  }
  groupData$first.session <- factor(groupData$first.session)
  return(groupData)
}

## ---- Function to format data from study 1 as in study 2
format_study2 <- function(df) {
  df %>%
    select(fileno, First_Session, ends_with("_NP"), -contains("Min")) %>% # keep only relevant columns
    gather(key, accuracy, -fileno, -First_Session) %>% # make long form
    # split key column to create separate columns for each factor
    separate(key, c("block", "stimulation", "target", "lag"), c(1,3,5)) %>% # split after 1st, 3rd, and 5th character
    # convert to factors, relabel levels to match those in study 2
    mutate(block = factor(block, levels = c("v", "t", "n"), labels = c("pre", "tDCS", "post")),
           stimulation = factor(stimulation, levels = c("b_", "d_"), labels = c("anodal", "cathodal")),
           lag = factor(lag, levels = c("_2_NP", "_4_NP", "_10_NP"), labels = c(2, 4, 10)),
           First_Session = factor(First_Session, labels = c("anodal first","cathodal first"))) %>%
    spread(target, accuracy) %>% # create separate columns for T2.given.T1 and T1 performance
    rename(T2.given.T1 = NB, session.order = First_Session, subject = fileno)# rename columns to match those in study 2
}

## ---- Function to create lag 3 in study 1 data
create_lag3_study1 <- function(df) {
  df %>%
  group_by(subject, session.order, block, stimulation) %>% # for each condition
    # calculate lag 3 as mean of 2 and 4; keep lag 10
    summarise(lag3_T2.given.T1 = (first(T2.given.T1) + nth(T2.given.T1,2)) / 2,
              lag3_T1 = (first(T1) + nth(T1,2)) / 2,
              lag10_T2.given.T1 = last(T2.given.T1), 
              lag10_T1 = last(T1)) %>%
    gather(condition, score, -subject, -session.order, -block, -stimulation) %>% # gather the 4 columns we created
    separate(condition, c("lag", "measure"), "_") %>% # separate lag and T1/T2|T1
    mutate(lag = str_remove(lag,"lag")) %>%
    mutate(lag = fct_relevel(lag, "3","10")) %>% #remake the lag factor
    spread(measure, score)  # make a column of T1 and T2|T1
}

## ---- Function to calculate AB magnitude
calc_ABmag <- function(df) {
  df %>% 
    group_by(subject, session.order, stimulation, block) %>% # for each unique factor combination
    summarise(AB.magnitude = last(T2.given.T1) - first(T2.given.T1), # subtract lags to replace data with AB magnitude,
              T1.short = first(T1)) # also keep T1 performance for short lag, to use as a covariate later
}

## ---- Function to calculate change scores
calc_change_scores <- function(df) {
  df %>%
    gather(measure, performance, AB.magnitude, T1.short) %>%
    group_by(subject, session.order, stimulation, measure) %>%
    summarise(baseline = first(performance), 
              during = nth(performance,2) - baseline,
              after = last(performance) - baseline) %>%
    gather(change, change.score, during, after) %>%
    mutate(change = fct_recode(change, "tDCS - baseline" = "during", "post - baseline" = "after"),
           change = fct_relevel(change, "tDCS - baseline")) %>%
    arrange(subject, stimulation)
}

## ---- Function to calculate partial correlations of anodal vs cathodal change scores
pcorr_anodal_cathodal <- function(df) {
  df %>%
    # create two columns of AB magnitude change score during tDCS: for anodal and cathodal
    filter(measure == "AB.magnitude") %>%
    select(-baseline) %>%
    spread(stimulation, change.score) %>%
    ungroup() %>% # remove grouping from previous steps, as we need to modify the dataframe
    select(session.order, change, anodal, cathodal) %>% # keep only relevant columns
    mutate(session.order = as.numeric(session.order)) %>% # dummy code to use as covariate
    nest(-change) %>% # split into two data frames, one for each comparison
    # partial correlation 
    mutate(r = map_dbl(data, ~pcor(c("anodal","cathodal","session.order"), var(.)))) %>%
    group_by(change) %>% # for each correlation
    # get t-stats, df and p-value of coefficient
    mutate(stats = list(as.data.frame(pcor.test(r, 1, n_distinct(df$subject))))) %>%
    unnest(stats, .drop = TRUE) # unpack resulting data frame into separate column
}

## ---- Function to plot anodal vs cathodal change scores
plot_anodalVScathodal <- function(df) {
  df %>% 
    # create two columns of AB magnitude change score during tDCS: for anodal and cathodal
    filter(measure == "AB.magnitude", change == "tDCS - baseline") %>%
    select(-baseline) %>%
    spread(stimulation, change.score) %>% 
    
    ggplot(aes(anodal, cathodal)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_smooth(method = "lm") +
    geom_point() +
    geom_rug() +
    scale_x_continuous("Effect of anodal tDCS (%)", limits = c(-.4,.4), breaks = seq(-.4,.4,.1), labels = scales::percent_format(accuracy = 1)) +
    scale_y_continuous("Effect of cathodal tDCS (%)", limits = c(-.4,.4), breaks = seq(-.4,.4,.1), labels = scales::percent_format(accuracy = 1) ) +
    coord_equal()
}