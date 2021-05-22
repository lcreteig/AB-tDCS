corr_change_baseline <- function(X,Y) {
  # Performs a (two-tailed) test for equal variances in the two input vectors. 
  # This is one way to do an unbiased assesment of the correlation between baseline and change from baseline (retest - baseline).
  # In this case, X would be the baseline, and Y the retest.
  #
  # Returns a list of 4 values, following Maloney & Rastogi (1970)
  #   -r: correlation of X-Y vs. X+Y. Assessing significance of this correlation is equivalent to a variance test
  #   -t: t-value constructed from the r-value
  #   -df: degrees of freedom for "r" and "t"
  #   -p: p-value for the variance test. If significant, this means the two vectors do not have equal variances,
  #       suggesting presence of a correlation between baseline and change from baseline.
  #
  # This implementation was inspired by and checked against an Excel spreadsheet, available at:
  # http://imaging.mrc-cbu.cam.ac.uk/statswiki/FAQ/rxxy_correction
  # This page is a great resource for further background on the issue of variance tests / correlations
  #
  # The relevant methods are contained in the following papers:
  #
  #   Jin, P. (1992). Toward a reconceptualization of the law of initial value. Psychological Bulletin 111(1) 176-184.
  #   Maloney, C. J. and Rastogi, S. C. (1970). Significance test for Grubb's estimators. Biometrics 26 671-676.
  #   Myrtek, M. and Foerster, F. (1986). The law of initial value: a rare exception. Biological Psychology 22 227-237
  #   Tu, Y-K. and Gilthorpe, M. S. (2007). Revisiting the relation between change and initial value: A review and evaluation. 
  #     Statistics in Medicine 26 443-457
  
  # This approach of testing the correlation correlation of X-Y and X+Y 
  # is equivalent to testing the variance of X vs. the variance of Y (Tu & Gilthorpe, 2007) 
  r_cor <- cor(X - Y, X + Y)
  n <- length(X) # number of observations 
  df <- n - 2 # degrees of freedom for r and t
  
  t_MR_1970 <- r_cor*sqrt(df) / sqrt(1 - r_cor^2) # t-value proposed by Maloney & Rastogi (1970); equation taken from Tu & Gilthorpe (2007)
  p_MR_1970 <- 2*pt(-abs(t_MR_1970), df) # p-value from t-value (for a two-sided test)
  return(list(r = r_cor, df = df, t = t_MR_1970, p = p_MR_1970))
  
  # Myrtek & Foerster (1986) proposed a different test. The approach is equivalent to Maloney & Rastogi (1970) and yields the same p-value.
  # It is only included here for the sake of completeness.
  
  B_e <- ( var(Y) - var(X) + sqrt((var(Y) - var(X))^2 + 4*(cov(X,Y))^2) ) / (2*cov(X,Y)) # structural relation, from Jin (1992)
  # N.B. this is a simplifaction of the equation in the paper, as "cor(X,Y) * sd(X) * sd(Y)"
  # simply reduces to "cov(X,Y)". The formula as literally in Jin (1992):
  # B_e_paper <- ( var(Y) - var(X) + sqrt((var(Y) - var(X))^2 + 4*(cor(X,Y) * sd(X) * sd(Y))^2) ) / (2*cor(X,Y) * sd(X) * sd(Y))
  # This simplification is also used in the formula below.
  
  # t-value proposed by Myrtek & Foerster, 1986; equation taken from from Jin (1992)
  t_MF_1986 <- sqrt( df * sin(2*(atan(B_e) - atan(1)))^2 *
                       ( (1/4) * (var(X) - var(Y))^2 + cov(X,Y)^2 ) / 
                       ( var(X) * var(Y) - cov(X,Y)^2) )
  p_MF_1986 <- 2*pt(-abs(t_MF_1986), df) #p-value from t-value (for a two-sided test)
  # return(list(df = df, t = t_MF_1986, p = p_MF_1986)) # the t- and p-values are identical to t_MR_1970 and p_MR_1970, so only return those
}