library("ggm")
library("ez")

# Mixed ANOVA

groupDataFull <- dplyr::filter(groupData, !is.na(T2.given.T1))
T2model <- ezANOVA(data = groupDataFull, dv = .(T2.given.T1), wid = .(subject), between = .(first.session), within = .(stimulation, block, lag), type = 3, detailed = TRUE)
T1model <- ezANOVA(data = groupDataFull, dv = .(T1), wid = .(subject), between = .(first.session), within = .(stimulation, block, lag), type = 3, detailed = TRUE)

# Correlating performance in both sessions ----------------------------------------------

# zero-order correlation
corrPre <- cor.test(groupDataCorr$AB.magnitude[groupDataCorr$block == "pre" & groupDataCorr$stimulation == "anodal"],
                    groupDataCorr$AB.magnitude[groupDataCorr$block == "pre" & groupDataCorr$stimulation == "cathodal"],
                    method = "pearson")

corrDur <- cor.test(groupDataCorr$AB.magnitude[groupDataCorr$block == "tDCS" & groupDataCorr$stimulation == "anodal"],
                    groupDataCorr$AB.magnitude[groupDataCorr$block == "tDCS" & groupDataCorr$stimulation == "cathodal"],
                    method = "pearson")

corrPost <- cor.test(groupDataCorr$AB.magnitude[groupDataCorr$block == "post" & groupDataCorr$stimulation == "anodal"],
                     groupDataCorr$AB.magnitude[groupDataCorr$block == "post" & groupDataCorr$stimulation == "cathodal"],
                     method = "pearson")

# partial correlation ("controlling" for sesssion order)
pCorrFrame <- data.frame(anodal = groupDataCorr$AB.magnitude[groupDataCorr$block == "pre" & groupDataCorr$stimulation == "anodal"], cathodal = groupDataCorr$AB.magnitude[groupDataCorr$block == "pre" & groupDataCorr$stimulation == "cathodal"], first = as.numeric(groupDataCorr$first.session[seq(1,nrow(groupDataCorr),6)]))
pc<- pcor(c("anodal","cathodal","first"), var(pCorrFrame, na.rm = TRUE))
pcor.test(pc, 1, 19)


# 4 correlations (anodal,cathodal; tdcs-pre, post-pre) ----------------------------------------------

# Anodal, during
pCorrFrameAD <- groupDataCorr2 %>%
  filter(stimulation == "anodal", from.baseline == "during") %>% #keep only rows of this condition
  filter(!is.na(change.score)) %>% # throw out missing subjects
  mutate(first.session = as.numeric(first.session)) %>% # dummy code first session factor
  select(first.session, baseline, change.score, T1.change) # keep only columns involved in correlation

pcAD<- pcor(c("baseline","change.score","first.session", "T1.change"), var(pCorrFrameAD)) # compute partial correlation coefficient
pcor.test(pcAD, length(pCorrFrameAD)-2, nrow(pCorrFrameAD)) # significance test

# Anodal, after
pCorrFrameAA <- groupDataCorr2 %>%
  filter(stimulation == "anodal", from.baseline == "after") %>%
  filter(!is.na(change.score)) %>%
  mutate(first.session = as.numeric(first.session)) %>%
  select(first.session, baseline, change.score, T1.change) 

pcAA<- pcor(c("baseline","change.score","first.session", "T1.change"), var(pCorrFrameAA))
pcor.test(pcAA, length(pCorrFrameAA)-2, nrow(pCorrFrameAA))

# Cathodal, during
pCorrFrameCD <- groupDataCorr2 %>%
  filter(stimulation == "cathodal", from.baseline == "during") %>%
  filter(!is.na(change.score)) %>%
  mutate(first.session = as.numeric(first.session)) %>%
  select(first.session, baseline, change.score, T1.change)  

pcCD<- pcor(c("baseline","change.score","first.session", "T1.change"), var(pCorrFrameCD))
pcor.test(pcCD, length(pCorrFrameCD)-2, nrow(pCorrFrameCD))

# Cathodal, after
pCorrFrameCA <- groupDataCorr2 %>%
  filter(stimulation == "cathodal", from.baseline == "after") %>%
  filter(!is.na(change.score)) %>%
  mutate(first.session = as.numeric(first.session)) %>%
  select(first.session, baseline, change.score, T1.change) 

pcCA<- pcor(c("baseline","change.score","first.session", "T1.change"), var(pCorrFrameCA))
pcor.test(pcCA, length(pCorrFrameCA)-2, nrow(pCorrFrameCA))

# anodal vs. cathodal correlations ----------------------------------------------

# during
pCorrFrameADCD <- groupDataCorr3 %>%
  filter(from.baseline == "during") %>%
  filter(!is.na(anodal)) %>%
  mutate(first.session = as.numeric(first.session)) %>%
  select(first.session, anodal, cathodal) 

pcADCD<- pcor(c("anodal","cathodal","first.session"), var(pCorrFrameADCD))
pcor.test(pcADCD, length(pCorrFrameADCD)-2, nrow(pCorrFrameADCD))

# after
pCorrFrameAACA <- groupDataCorr3 %>%
  filter(from.baseline == "after") %>%
  filter(!is.na(anodal)) %>%
  mutate(first.session = as.numeric(first.session)) %>%
  select(first.session, anodal, cathodal)

pcAACA<- pcor(c("anodal","cathodal","first.session"), var(pCorrFrameAACA))
pcor.test(pcAACA, length(pCorrFrameAACA)-2, nrow(pCorrFrameAACA))