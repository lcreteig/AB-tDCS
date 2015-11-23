library("ggplot2")
library("Hmisc")

# Create custom theme based on black and white theme

theme_custom <- theme_bw(base_size = 24, base_family="Helvetica") +
  theme(plot.title = element_text(face = "bold"), 
        axis.title = element_text(face = "bold"),
        axis.title.x = element_text(vjust = -0.2),
        axis.title.y = element_text(vjust = 1.8),
        strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
        strip.text = element_text(face="bold")
  )

# Line plots -------------------------------

# Line plot (roughly as in London et al.)
linePlot <- ggplot(groupDataMelt, aes(lag, proportion.correct, color = block, shape = block)) +
  facet_grid(target ~ stimulation) +
  stat_summary(fun.y = mean, geom = "point", size = 4) +
  stat_summary(fun.y = mean, geom = "line", aes(group = interaction(block, target)), size = 1) +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.1) +
  scale_x_discrete("Lag") +
  scale_y_continuous("Percentage correct", breaks = seq(30,90,20)) +
  scale_color_brewer(palette = "Set2") +
  theme_custom +
  theme(panel.grid.major.x = element_blank())
linePlot
# final argument to prevent ggplot from rendering dots as text with dingbats font, which illustrator does not like
#ggsave("line_study_dingbats.pdf", height = 120, width = 120*goldenRatio, units = "mm", useDingbats=FALSE)

# Individual subjects
ggplot(groupDataCorr, aes(block, AB.magnitude)) +
  facet_grid(~ stimulation) +
  stat_summary(fun.y = mean, geom = "point", shape = 16, size = 10, alpha = 0.2) +
  geom_line(aes(group = subject), color = "grey") +
  geom_point(aes(color = block), size = 3, shape = 16) +
  #stat_summary(fun.y = mean, geom = "line", size = 1) +
  theme_custom

# Scatterplots -------------------------------

labelText = round(c(as.numeric(corrPre$estimate), as.numeric(corrDur$estimate), as.numeric(corrPost$estimate)),3);
textOverlay <- data.frame(anodal = c(10,10,10),cathodal = c(60,60,60), rVals = labelText, block = factor(c("pre", "tDCS", "post")))

# performance in anodal session vs cathodal session
ggplot(groupDataCorr1, aes(anodal, cathodal)) +
  facet_wrap(~ block) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
  geom_smooth(method = "lm", size = 1, fill = "grey", color = "black") +
  geom_point(size = 3, aes(color = first.session)) +
  geom_rug(aes(color = first.session)) +
  scale_x_continuous("AB magnitude anodal session (%)", breaks = seq(0,60,10), limits = c(0,65), expand = c(0,0)) +
  scale_y_continuous("AB magnitude cathodal session (%)", breaks = seq(0,60,10), limits = c(0,65), expand = c(0,0)) +
  coord_equal() +
  geom_text(data = textOverlay, aes(label = paste("italic(r) == ", rVals)), parse = TRUE) +
  theme_custom

# change score vs baseline
ggplot(groupDataCorr2, aes(baseline, change.score)) +
  facet_grid(from.baseline ~ stimulation) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_smooth(method = "lm", size = 1, fill = "grey") +
  geom_point(size = 3) +
  geom_rug(color = "grey50") +
  scale_x_continuous("Baseline AB magnitude (%)", breaks = seq(0,100,20), limits = c(0,100)) +
  scale_y_continuous("Change in AB magnitude (%)", breaks = seq(-40,40,10), limits = c(-35,35)) +
  coord_equal() +
  theme_custom

# anodal change score vs. cathodal change score
ggplot(groupDataCorr3, aes(anodal, cathodal)) +
facet_wrap(~ from.baseline) +
geom_hline(yintercept = 0, linetype = "dashed") +
geom_vline(xintercept = 0, linetype = "dashed") +
geom_smooth(method = "lm", size = 1, fill = "grey") +
geom_point(size = 3) +
geom_rug(color = "grey50") +
scale_x_continuous("Effect of anodal tDCS (%)", breaks = seq(-30,30,30), limits = c(-35,35)) +
scale_y_continuous("Effect of cathodal tDCS (%)", breaks = seq(-30,30,30), limits = c(-35,35)) +
coord_equal() +
theme_custom
