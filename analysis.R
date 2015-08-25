dataDir = "data/main" #data directory (relative to project root)
subs2exclude = c("S04", "S14") 
subID = list.dirs(dataDir, full.names = FALSE, recursive = FALSE) # get subject names
numSubjects <- length(subID);

# factors
tDCScode <- c("B", "D") # corresponds to "stimulation": B = anodal, D = cathodal
stimulation <- c("anodal", "cathodal")
block <- c("pre", "tDCS", "post")
lag <- c(3,8)

# initialize group data frame
colHeader <- c("subject", "gender", "date.of.birth", "first.session", "stimulation", "block", "lag", "trials", "T1", "T2.given.T1") # name the variables (column header)
frameCols <- length(colHeader)
repRows <- length(stimulation)*length(block)*length(lag) # number of rows in data frame belonging to 1 subject
frameRows <- numSubjects*repRows
groupData <- data.frame(matrix(ncol=frameCols, nrow=frameRows)) # create group data frame with appropriate dimensions
names(groupData) <- colHeader #assign variable names to the data frame

# fill fixed variables
subjectInfo <- read.table(file.path(dataDir, "subject_info.txt"), header = TRUE, sep = "\t") # read auxilliary text file with time-invariant data
groupData$subject <- rep(subID, each = repRows)
groupData$gender <- rep(subjectInfo$gender, each = repRows)
groupData$date.of.birth <- rep(as.Date(as.Date(subjectInfo$date.of.birth, "%d-%b-%Y")), each = repRows) # convert strings to R date format
groupData$stimulation <- factor(rep(stimulation, each = length(block)*length(lag), times = numSubjects))
groupData$block <- factor(rep(block, each = length(lag), times = numSubjects), levels = block)
groupData$lag <- factor(rep(lag, times = numSubjects))

for (iSub in subID) {
  
  if (is.element(iSub, subs2exclude)) { # if current subject should be excluded, skip to next one
    next
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
        nonBlink <- sum(ABdata$T2acc[trialsLag & trialsT1 & trialsT2]) / numTrials * 100 # percentage of T2 given T1 correct trials
        
        # insert into data frame
        cellIdx = groupData$subject == iSub & groupData$stimulation == stimulation[tDCScode == iStim] & groupData$block == iBlock & groupData$lag == iLag # get index of current cell
        # fill with data
        groupData$trials[cellIdx] <- numTrials
        groupData$T1[cellIdx] <- T1
        groupData$T2.given.T1[cellIdx] <- nonBlink
      }
      
    }
    
    if (grepl(paste("1", iStim, sep = ""), dataFiles[iFile])) { # if current file was the 1st session
      groupData$first.session[groupData$subject == iSub] <- stimulation[tDCScode == iStim] # store the stimulation type
    }
    
  }
}
groupData$first.session <- factor(groupData$first.session)

