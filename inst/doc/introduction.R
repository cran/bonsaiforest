## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(bonsaiforest)

## ----str_data-----------------------------------------------------------------
str(example_data)

## -----------------------------------------------------------------------------
naivepop_model <- naivepop(
  resp = "tt_pfs",
  trt = "arm",
  data = example_data,
  resptype = "survival",
  status = "ev_pfs"
)

## -----------------------------------------------------------------------------
summary_naivepop <- summary(naivepop_model)
summary_naivepop

## -----------------------------------------------------------------------------
naive_model <- naive(
  resp = "tt_pfs", trt = "arm",
  subgr = c("x_1", "x_2"),
  data = example_data, resptype = "survival",
  status = "ev_pfs"
)

## -----------------------------------------------------------------------------
summary_naive <- summary(naive_model, conf = 0.90)
summary_naive

## ----fig.dim = c(6, 6)--------------------------------------------------------
plot(summary_naive)

## -----------------------------------------------------------------------------
ridge_model <- elastic_net(
  resp = "tt_pfs", trt = "arm",
  subgr = c("x_1", "x_2"),
  covars = c(
    "x_1", "x_2", "x_3", "x_4", "x_5",
    "x_6", "x_7", "x_8", "x_9", "x_10"
  ),
  data = example_data, resptype = "survival",
  alpha = 0, status = "ev_pfs"
)

lasso_model <- elastic_net(
  resp = "tt_pfs", trt = "arm",
  subgr = c("x_1", "x_2"),
  covars = c(
    "x_1", "x_2", "x_3", "x_4", "x_5",
    "x_6", "x_7", "x_8", "x_9", "x_10"
  ),
  data = example_data, resptype = "survival",
  alpha = 1, status = "ev_pfs"
)

## -----------------------------------------------------------------------------
summary_ridge <- summary(ridge_model)
summary_ridge
summary_lasso <- summary(lasso_model)
summary_lasso

## ----fig.dim = c(6, 6)--------------------------------------------------------
plot(summary_ridge)
plot(summary_lasso)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  horseshoe_model <- horseshoe(
#    resp = "tt_pfs", trt = "arm",
#    subgr = c("x_1", "x_2"),
#    covars = c(
#      "x_1", "x_2", "x_3", "x_4", "x_5",
#      "x_6", "x_7", "x_8", "x_9", "x_10"
#    ),
#    data = example_data,
#    resptype = "survival",
#    status = "ev_pfs",
#    chains = 2,
#    seed = 0,
#    iter = 1000,
#    warmup = 800,
#    control = list(adapt_delta = 0.95)
#  )

## ----echo=FALSE---------------------------------------------------------------
# Load the saved object from the package to save
# compilation time for this vignette.
horseshoe_model <- horseshoe_fit_surv

## -----------------------------------------------------------------------------
horseshoe_model$fit

## -----------------------------------------------------------------------------
summary_horseshoe <- summary(horseshoe_model, conf = 0.9)
summary_horseshoe

## ----fig.dim = c(6, 6)--------------------------------------------------------
plot(summary_horseshoe)

## -----------------------------------------------------------------------------
comparison_data <- compare(naivepop_model, naive_model, ridge_model, lasso_model, horseshoe_model)
comparison_data

## ----fig.dim = c(6, 6)--------------------------------------------------------
plot(comparison_data)

