library("tidyr")
library("dplyr")

# For Mixed Anova / line plots
groupDataMelt <- gather(groupData, target, proportion.correct, T1, T2.given.T1)  # make data frame more long-form so T1 vs. T2|T1 can be used as a factor

# Basic data frame with AB magnitude
maxLag = max(as.numeric(levels(groupData$lag))[groupData$lag]) 
minLag = min(as.numeric(levels(groupData$lag))[groupData$lag])
groupDataCorr <- groupData %>% 
  group_by(subject, first.session, stimulation, block) %>% # for each unique factor combination
  summarise(AB.magnitude=T2.given.T1[lag==maxLag]-T2.given.T1[lag==minLag], # subtract lags to replace data with AB magnitude,
            T1.short = T1[lag==minLag]) # also keep T1 performance for short lag

# for correlating anodal and cathodal session for each block
groupDataCorr1 <- groupDataCorr  %>%
  spread(stimulation, AB.magnitude) # create separate columns for anodal and cathodal AB magnitude

# for correlating change scores and/or baseline
groupDataCorr2 <- groupDataCorr %>%
  summarise(baseline = AB.magnitude[block == "pre"], # create baseline column, subtract blocks to replace data with change scores
            during = AB.magnitude[block == "tDCS"] - AB.magnitude[block == "pre"],
            after = AB.magnitude[block == "post"] - AB.magnitude[block == "pre"],
            T1.during = T1.short[block == "tDCS"] - T1.short[block == "pre"],
            T1.after = T1.short[block == "post"] - T1.short[block == "pre"]) %>%
  gather(from.baseline, change.score, during, after) %>% # make change scores long form, so "during" vs. "after" can be used as a factor
  gather(temp, T1.change, T1.after, T1.during) %>%
  filter((from.baseline == "during" & temp == "T1.during") | (from.baseline == "after" & temp == "T1.after")) %>% # remove duplicate rows due to double gather operation
  select(-temp) %>%
  arrange(subject, stimulation) # sort by fixed variables

# for correlating anodal and cathodal change scores
groupDataCorr3 <- groupDataCorr %>%
  summarise(during = AB.magnitude[block == "tDCS"] - AB.magnitude[block == "pre"],
            after = AB.magnitude[block == "post"] - AB.magnitude[block == "pre"]) %>%
  gather(from.baseline, change.score, during, after) %>%
  spread(stimulation, change.score) # create separate columns for anodal and cathodal change scores

# for entry into "rxx-r" spreadsheet (variance tests)
rttmData <- groupDataCorr %>%
  filter(!is.na(AB.magnitude)) %>%
  unite(stimBlock, stimulation, block, sep = "_") %>%
  select(subject, stimBlock, AB.magnitude) %>%
  group_by(subject) %>%
  spread(stimBlock, AB.magnitude)
#write.table(rttmData, file = "rttmData.txt", sep = "\t", row.names = FALSE)

#   mutate(tDCS.min.pre = AB.magnitude[block == "tDCS"] - AB.magnitude[block == "pre"]) %>%
#   mutate(post.min.pre = AB.magnitude[block == "post"] - AB.magnitude[block == "pre"]) %>%
#   gather(from.baseline, change.score, tDCS.min.pre, post.min.pre)
#   
#   arrange(block)
#   group_by(subject, stimulation)
#   
#   spread(block, AB.magnitude) %>%
#   mutate(tdcs.min.pre = tDCS - pre) %>%
#   mutate(post.min.pre = post - pre) %>%
#   gather(block, tdcs.min.pre, post.min.pre)


# # create new data frame for correlation analyses
# groupDataCorr1 <- groupData %>%
#   group_by(subject,stimulation,block) %>% # for each combination of subject, stimulation and block
#   mutate(AB.magnitude = T2.given.T1 - lag(T2.given.T1)) %>%# create new column with difference score between lags (N.B. "lag" here is a dplyr function!)
#   #filter(AB.magnitude = !is.na(AB.magnitude)) %>%
#   select(-lag, -T1, -T2.given.T1, -trials) # drop lag column from data frame
#   #REMOVE FACTOR WITH MISSING VALUES?!  
# 
# # create new data frame for correlation analyses
# groupDataCorr2 <- groupData %>%
#   mutate(AB.magnitude = T2.given.T1 - lag(T2.given.T1)) %>% # create new column with difference score between lags (N.B. "lag" here is a dplyr function!)
#   filter(lag == 8) %>% # keep only rows that reflect the lag 8 - lag 3 subtraction (AB magnitude)
#   select(-lag, -T1, -T2.given.T1, -trials) # drop obsolete columns from data frame