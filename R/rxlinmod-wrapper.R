
# Names of categorical variables should not end in digits
# rxLinMod must be called with coefLabelStyle="R"
get_rxlm_predictor_function <- function(the_model){
  fitted_coef <- coef(the_model)
  fitted_coef[is.na(fitted_coef)] <- 0
  coef_names <- names(fitted_coef)
  
  sigmoid <- function(x) 1/(1 + exp(-x)) # rxLogit coming soon
  flip_names <- function(v) sapply(strsplit(v, ":"), function(x) paste(rev(x), collapse=":"))
  
  function(newdata){
    for (factor_var in colnames(newdata)[sapply(newdata, is.factor)]){
      N <- length(levels(newdata[[factor_var]]))
      contrasts(newdata[[factor_var]], how.many=N) <- diag(N)
    }
    mm <- model.matrix(the_model$formula, newdata)
    mm_names <- colnames(mm)
    flipped <- !(coef_names %in% mm_names)
    coef_names[flipped] <- flip_names(coef_names[flipped])
    pred <- (mm[,coef_names] %*% fitted_coef)[,1]
    names(pred) <- NULL
    pred
  }
}

foo <- data.frame(height=sample(LETTERS[1:3], 100, replace=TRUE),
                  width=sample(LETTERS[1:3], 100, replace=TRUE),
                  age=runif(100),
                  iq=runif(100))
foo <- transform(foo, y=ifelse(height == width, age * iq, age + iq))

foo_model <- rxLinMod(y ~ (height + width + age + iq)^2, foo, coefLabelStyle="R")
foo_predictor <- get_rxlm_predictor_function(foo_model)

bar <- data.frame(height=sample(LETTERS[1:3], 100, replace=TRUE),
                  width=sample(LETTERS[1:3], 100, replace=TRUE),
                  age=runif(100),
                  iq=runif(100))
bar <- transform(bar, y=ifelse(height == width, age * iq, age + iq))

all.equal(foo_predictor(bar), rxPredict(foo_model, bar)[[1]]) # TRUE
