M1 <- lm(paupratiodiff ~ outratiodiff + year + Type, data = pauperism)
M2 <- lm(paupratiodiff ~ outratiodiff + (popratiodiff + oldratiodiff) * (year + Type), data = pauperism)
M3 <- lm(-1  + paupratiodiff ~ (outratiodiff + popratiodiff + oldratiodiff) * (year + Type), data = pauperism)
M4 <- lm(paupratiodiff ~ (outratiodiff + popratiodiff + oldratiodiff) * (year + Type), data = pauperism)

M1
M2
M3
M4


### y in a linear regression is predicted value.

### difference between residual and error: distance computed from a data set (in a model) is a residual; error is the true value of the residual. basically, residual is error with hat on it (estimation of the error)


# Bootstrapping

bsdata <- modelr::bootstrap(car::Duncan, n = 1024)
glimpse(bsdata)

bsdata[["strap"]][[1]]
str(bsdata[["strap"]][[1]])

library(broom)
bs_coef <- map_df(bsdata$strap, function(dat) {
  lm(prestige ~ type + income + education, data = dat) %>%
    tidy() %>%
    select(term, estimate)
})


# The quantile confidence intervals:
alpha <- 0.95
bs_coef %>%
  group_by(term) %>%
  summarise(
    conf.low = quantile(estimate, (1-alpha) / 2),
    conf.high = quantile(estimate, 1 - (1 - alpha) / 2)
    ) %>%
  left_join(select(tidy(mod),
                   term, estimate),
            by = "term") %>%
  select(term, estimate)

library(devtools)
install_github("jrnold/resamplr")

bsdata <- bootstrap(group_by(car::Duncan, type), 1024)




