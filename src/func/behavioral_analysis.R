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
          T1 <- sum(trialsT1 & trialsLag) / numTrials * 100 # percentage of T1 correct trials
          
          trialsT2 <- ABdata$T2acc == 1 # indices of T2 correct trials
          T2 <- sum(trialsT2 & trialsLag) / numTrials * 100 # percentage of T1 correct trials
          nonBlink <- sum(trialsLag & trialsT1 & trialsT2) / sum(trialsLag & trialsT1) * 100 # percentage of T2 given T1 correct trials
          
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