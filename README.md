This assignment works through an example in Yule (1899):

Yule (1899) is a published example multiple regression analysis in its
modern form.[1]

Yule wrote this paper to analyze the effect of policy changes and
implementation on pauperism (poor receiving benefits) in England under
the [English Poor
Laws](https://en.wikipedia.org/wiki/English_Poor_Laws). In 1834, a new
poor law was passed that established a national welfare system in
England and Wales. The New Poor Law created new administrative districts
(Poor Law Unions) to adminster the law. Most importantly, it attempted
to standardize the provision of aid to the poor. There were two types of
aid provided: in-relief or aid provided to paupers in workhouses where
they resided, and out-relief or aid provided to paupers residing at
home. The New Poor Law wanted to decrease out-relief and increase
in-relief in the belief that in-relief, in particular the quality of
life in workhouses, was a deterrence to poverty and an encouragement for
the poor to work harder to avoid poverty.

Yule identifies that there are various potential causes of the change in
rate of pauperism, including changes in the (1) law, (2) economic
conditions, (3) general social character, (4) moral character, (5) age
distribution of the population (pg. 250).

He astutely notes the following:

> If, for example, we should find an increase in the proportion of
> out-relief associated with (1) an increase in the proportion of the
> aged to the whole population, and also (2) an increase in the rate of
> pauperism, it might be legitimate to interpret the result in the sense
> that changes in out-relief and pauperism were merely simultaneous
> concomitants of changes in the proportion of aged-the change of
> pauperism not being a direct consequence of the change of
> administration, but both direct consequenices of the change in age
> distribution. It is evidently most important that we should be able to
> decide between two such differenit ilnterpretations of the same facts.
> This the method I have used is perfectly competernt to do --- Yule
> (1899 pg. 250)

Setup
=====

    library("tidyverse")
    library("modelr")

While only a subset of the original data of Yule (1899) was printed in
the article itself, Plewis (2015) reconstructed the orginal data and
Plewis (2017) replicated the original paper. This data is included in
the package **datums**. This package is not on CRAN, but can be
downloaded from github. **IMPORTANT** install the latest version of
**datums** since a few fixes were recently made to the `pauperism`
dataset.

    # devtools::install_github("jrnold/datums")
    library("datums")

The data for Yule (1899) is split into two data frames: `pauperism_plu`
contains data on the Poor Law Unions (PLU), and `pauperism_year`, panel
data with the PLU-year as the unit of observation.

    pauperism <-
      left_join(datums::pauperism_plu, datums::pauperism_year,
                by = "ID") %>%
      mutate(year = as.character(year))

The data consist of 599 PLUs and the years: 1871, 1881, 1891 (years in
which there was a UK census).

Yule (1899) is explcitly using regression for causal inference. The
outcome variable of interest is:

-   **Pauperism** the percentage of the population in receipt of relief
    of any kind, less lunatics and vagrants

The treatment (policy intervention) is the ration of numbers receiving
outdoor relief to those receiving indoor relief.

-   **Out-Relief Ratio:** the ratio of numbers relieved outdoors to
    those relieved indoors

He will control for two variables that may be associated with the
treatment

-   **Proportion of Old:** the proportion of the aged (65 years) to the
    whole population since the old are more likely to be poor.
-   **Population:** in particular changes in population that may be
    proxying for changes in the economic, social, or moral factors of
    PLUs.

There is also **Grouping of Unions**, which is a locational
classification based on population density that consists of Rural,
Mixed, Urban, and Metropolitan.

Instead of taking differences or percentages, Yule worked with "percent
ratio differences", $100 \\times \\frac{x\_{t}}{x\_{t-1}}$, because he
did not want to work with negative signs, presumably a concern at the
because he was doing arithmetic by hand and this would make calculations
more tedious or error-prone.

Original Specification
----------------------

Run regressions of `pauper` using the yearly level data with the
following specifications. In Yule (1899), the regressions are

-   *M1:* `paupratiodiff ~ outratiodiff + year + Type`
-   *M2:*
    `paupratiodiff ~ outratiodiff + (popratiodiff + oldratiodiff) * (year + Type)`
-   *M3:*
    `-1  + paupratiodiff ~ (outratiodiff + popratiodiff + oldratiodiff) * (year + Type)`
-   *M4:*
    `paupratiodiff ~ (outratiodiff + popratiodiff + oldratiodiff) * (year + Type)`

1.  Present the regressions results in a regression table
2.  Interpret the coefficients for `outratiodiff` for each model.
3.  Write the equations for each or all models, and describe the model
    with a sentence or two. Try to be as concise as possible. Look at
    recent journal articles for examples of the wording and format.
4.  What is the difference between *M3* and *M4*. What are the pros and
    cons of each parameterization?
5.  Conduct F-tests on the hypotheses:

    1.  All interactions in *M4* are 0
    2.  The coefficients on `outratiodiff` in *M4* are the same across
        years
    3.  The coefficients on `outratiodiff` in *M4* are the same across
        PLU Types
    4.  The coefficients on `outratiodiff` in *M4* are the same across
        PLU Types and years.

6.  Calculate the predicted value and confidence interval for the PLU
    with the median value of `outratiodiff`, `popratiodiff`, and
    `oldratiodiff` in each year and PLU Type for these models. Plot the
    predicted value and confidence interval of these as point-ranges.
7.  As previously, calculate the predicted value of the median PLU in
    each year and PLU Type. But instead of confidence intervals include
    the prediction interval. How do the confidence and prediction
    intervals differ? What are their definitions?

Functional Forms
----------------

The regression line of the model estimated in Yule (1899) (ignoring the
year and region terms and interactions) can be also written as
$$
\\begin{aligned}\[t\]
100 \\times \\frac{\\mathtt{pauper2}\_t / \\mathtt{Popn2\_t}}{\\mathtt{pauper2}\_{t-1} / \\mathtt{Popn2\_{t-1}}} 
&= \\beta\_0 + \\beta\_1 \\times 100 \\times \\frac{\\mathtt{outratio}\_t}{\\mathtt{outratio\_{t-1}}} \\\\
& \\quad + \\beta\_2 \\times 100 \\times \\frac{\\mathtt{Popn65}\_t / \\mathtt{Popn2}\_{t}}{\\mathtt{Popn65}\_{t-1} / \\mathtt{Popn2}\_{t-1}} + \\beta\_3 \\times 100 \\times \\frac{\\mathtt{Popn2}\_t}{\\mathtt{Popn2}\_{t - 1}}
\\end{aligned}
$$

1.  Take the logarithm of each side, and simplify so that
    log(`p``a``u``p``e``r``2`<sub>*t*</sub>/`p``a``u``p``e``r``2`<sub>*t* − 1</sub>)
    is the outcome and the predictors are all in the form
    log(*x*<sub>*t*</sub>)−log(*x*<sub>*t* − 1</sub>)=log(*x*<sub>*t*</sub>/*x*<sub>*t* − 1</sub>).
2.  Estimate the model with logged difference predictors, Year, and
    month and interpret the coefficient on
    log(*o**u**t**r**a**t**i**o*<sub>*t*</sub>).
3.  What are the pros and cons of this parameterization of the model
    relative to the one in Yule (1899)? Focus on interpretation and the
    desired goal of the inference rather than the formal tests of the
    regression. Can you think of other, better functional forms?

Non-differenced Model
---------------------

Suppose you estimate the model (*M5*) without differencing,

    pauper2 ~ outratio + (Popn2 + Prop65) * (year + Type)

-   Interpret the coefficient on `outratio`. How is this different than
    model *M5*
-   What accounts for the different in sample sizes in *M5* and *M2*?
-   What model do you think will generally have less biased estimates of
    the effect of out-relief on pauperism: *M5* or *M2*? Explain your
    reasoning.

Substantive Effects
-------------------

Read Gross (2014) and McCaskey and Rainey (2015). Use the methods
described in those papers to assess the substantive effects of out-ratio
on the rate of pauperism. Use the model(s) of your choosing.

Influential Observations and Outliers
-------------------------------------

### Influential Observations for the Regression

For this use *M2*:

1.  For each observation, calculate and explain the following:

-   hat value (`hatvalues`)
-   standardized error (`rstandard`)
-   studentized error (`rstudent`)
-   Cook's distance (`cooksd`)

1.  Create an outlier plot and label any outliers. See the example
    [here](https://jrnold.github.io/intro-methods-notes/outliers.html#iver-and-soskice-data)
2.  Using the plot and rules of thumb identify outliers and influential
    observations

Influential Observations for a Coefficient
------------------------------------------

1.  Run *M2*, deleting each observation and saving the coefficient for
    `outratiodirff`. This is a method called the jackknife. You can use
    a for loop to do this, or you can use the function `jackknife` in
    the package [resamplr](https://github.com/jrnold/resamplr).

    -   For which observations is there the largest change in the
        coefficient on `outratiodiff`?

    1.  Which observations have the largest effect on the estimate of
        `outratiodiff`?
    2.  How do these observations compare with those that had the
        largest effect on the overall regression as measured with Cook's
        distance?
    3.  Compare the results of the jackknife to the `dfbeta` statistic
        for `outratiodiff`

2.  Aronow and Samii (2015) note that the influence of observations in a
    regression coefficient is different than the the influence of
    regression observations in the entire regression. Calculate the
    observation weights for `outratiodiff`.

    1.  Regress `outratiodiff` on the control variables
    2.  The weights of the observations are those with the highest
        squared errors from this regression. Which observations have the
        highest coefficient values?
    3.  How do the observations with the highest regression weights
        compare with those with the highest changes in the regression
        coefficient from the jackknife?

Omitted Variable Bias
---------------------

An informal way to assess the potential impact of omitted variables on
the coeficient of the variable of interest is to coefficient variation
when covariates are added as a measure of the potential for omitted
variable bias (Oster 2016). Nunn and Wantchekon (2011) (Table 4)
calculate a simple statistic for omitted variable bias in OLS. This
statistic "provide\[s\] a measure to gauge the strength of the likely
bias arising from unobservables: how much stronger selection on
unobservables, relative to selection on observables, must be to explain
away the full estimated effect."

1.  Run a regression without any controls. Denote the coefficient on the
    variable of interest as $\\hat\\beta\_R$.
2.  Run a regression with the full set of controls. Denote the
    coefficient on the variable of interest in this regression as
    $\\hat\\beta\_F$.
3.  The ratio is $\\hat\\beta\_F / (\\hat\\beta\_R - \\hat\\beta\_F)$

Calculate this statistic for *M2* and interpret it.

Heteroskedasticity
------------------

1.  Run *M2* and *M3* with a heteroskedasticity consistent (HAC), also
    called robust, standard error. How does this affect the standard
    errors on `outratio` coefficients? Use the **sandwich** package to
    add HAC standard errors (Zeileis 2004).
2.  Model *M3* is almost equivalent to running separate regressions on
    each combination of `Type` and `Year`.

    1.  Run a regression on each subset of combination of `Type` and
        `Year`.
    2.  How do the coefficients, standard errors, and regression
        standard errors (*σ*) differ from those of *M3*.
    3.  Compare the robust standard errors in *M3* to those in the
        subset regressions. What is the relationship between
        heteroskedasticity and difference between the single regression
        with interactions (*M3*) and the multiple regressions.

Weighted Regression
-------------------

1.  Run *M2* and *M3* as weighted regressions, weighted by the
    population (`Popn`) and interpret the coefficients on `outratiodiff`
    and interactions. Informally assess the extent to which the
    coefficients are different. Which one does it seem to affect more?
2.  What are some rationales for weighting by population? See the
    discussion in Solon, Haider, and Wooldridge (2013) and Angrist and
    Pischke (2014).

**BELOW THIS STILL IN PROGRESS**

Average Marginal Effects
------------------------

Cross-Validation
----------------

When using regression causal estimation, model specification and choice
should largely be based on avoiding omitted variables. Another criteria
for selecting models is to use their fit to the data. But a model's fit
to data should not be assessed using only the in-sample data. That leads
to overfitting---and the best model would always be to include an
indicator variable for every observation Instead, a model's fit to data
can be assessed by using its out-of-sample fit. One way to estimate the
*expected* fit of a model to *new* data is cross-validation.

Bootstrapping
-------------

Estimate the 95% confidence intervals of model with simple
non-parametric bootstrapped standard errors. The non-parametric
bootstrap works as follows:

Let $\\hat\\theta$ be the estimate of a statistic. To calculate
bootstrapped standard errors and confidence intervals use the following
procedure.

For samples *b* = 1, ..., *B*.

1.  Draw a sample with replacement from the data
2.  Estimate the statistic of interest and call it
    *θ*<sub>*b*</sub><sup>\*</sup>.

Let
*θ*<sup>\*</sup> = {*θ*<sub>1</sub><sup>\*</sup>, …, *θ*<sub>*B*</sub><sup>\*</sup>}
be the set of bootstrapped statistics.

-   standard error: $\\hat\\theta$ is $\\sd(\\theta^\*)$.
-   confidence interval:

    -   normal approximation. This calculates the confidence interval as
        usual but uses the bootstrapped standard error instead of the
        classical OLS standard error:
        $\\hat\\theta \\pm t\_{\\alpha/2,df} \\cdot \\sd(\\theta^\*)$
    -   quantiles: A 95% confidence interval uses the 2.5% and 97.5%
        quantiles of *θ*<sup>\*</sup> for its upper and lower bounds.

References
----------

Angrist, Joshua D., and Jörn-Steffen Pischke. 2014. *Mastering
‘Metrics*. Princeton UP.

Aronow, Peter M., and Cyrus Samii. 2015. “Does Regression Produce
Representative Estimates of Causal Effects?” *American Journal of
Political Science* 60 (1). Wiley-Blackwell: 250–67.
doi:[10.1111/ajps.12185](https://doi.org/10.1111/ajps.12185).

Freedman, David. 1997. “From Association to Causation via Regression.”
*Advances in Applied Mathematics* 18 (1). Elsevier BV: 59–110.
doi:[10.1006/aama.1996.0501](https://doi.org/10.1006/aama.1996.0501).

Gross, Justin H. 2014. “Testing What Matters (If You Must Test at All):
A Context-Driven Approach to Substantive and Statistical Significance.”
*American Journal of Political Science* 59 (3). Wiley-Blackwell: 775–88.
doi:[10.1111/ajps.12149](https://doi.org/10.1111/ajps.12149).

McCaskey, Kelly, and Carlisle Rainey. 2015. “Substantive Importance and
the Veil of Statistical Significance.” *Statistics, Politics and Policy*
6 (1-2). Walter de Gruyter GmbH.
doi:[10.1515/spp-2015-0001](https://doi.org/10.1515/spp-2015-0001).

Nunn, Nathan, and Leonard Wantchekon. 2011. “The Slave Trade and the
Origins of Mistrust in Africa.” *American Economic Review* 101 (7):
3221–52.
doi:[10.1257/aer.101.7.3221](https://doi.org/10.1257/aer.101.7.3221).

Oster, Emily. 2016. “Unobservable Selection and Coefficient Stability:
Theory and Evidence.” *Journal of Business & Economic Statistics*,
September. Informa UK Limited, 0–0.
doi:[10.1080/07350015.2016.1227711](https://doi.org/10.1080/07350015.2016.1227711).

Plewis, Ian. 2015. “Census and Poor Law Union Data, 1871-1891.” SN 7822.
UK Data Service; data collection.
doi:[10.5255/UKDA-SN-7822-1](https://doi.org/10.5255/UKDA-SN-7822-1).

———. 2017. “Multiple Regression, Longitudinal Data and Welfare in the
19th Century: Reflections on Yule (1899).” *Journal of the Royal
Statistical Society: Series A (Statistics in Society)*, February.
Wiley-Blackwell.
doi:[10.1111/rssa.12272](https://doi.org/10.1111/rssa.12272).

Solon, Gary, Steven Haider, and Jeffrey Wooldridge. 2013. “What Are We
Weighting for?” National Bureau of Economic Research.
doi:[10.3386/w18859](https://doi.org/10.3386/w18859).

Stigler, Stephen M. 1990. *The History of Statistics: The Measurement of
Uncertainty Before 1900*. HARVARD UNIV PR.
<http://www.ebook.de/de/product/3239165/stephen_m_stigler_the_history_of_statistics_the_measurement_of_uncertainty_before_1900.html>.

———. 2016. *The Seven Pillars of Statistical Wisdom*. Harvard University
Press.
<http://www.ebook.de/de/product/25237216/stephen_m_stigler_the_seven_pillars_of_statistical_wisdom.html>.

Yule, G. Udny. 1899. “An Investigation into the Causes of Changes in
Pauperism in England, Chiefly During the Last Two Intercensal Decades
(Part I.).” *Journal of the Royal Statistical Society* 62 (2). JSTOR:
249. doi:[10.2307/2979889](https://doi.org/10.2307/2979889).

Zeileis, Achim. 2004. “Econometric Computing with Hc and Hac Covariance
Matrix Estimators.” *Journal of Statistical Software* 11 (1): 1–17.
doi:[10.18637/jss.v011.i10](https://doi.org/10.18637/jss.v011.i10).

[1] See Freedman (1997), Stigler (1990), Stigler (2016), and Plewis
(2017) for discussions of Yule (1899).
