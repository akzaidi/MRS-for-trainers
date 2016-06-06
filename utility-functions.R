pkgs_to_install <- c("data.table", "stringr")
pks_missing <- pkgs_to_install[!(pkgs_to_install %in% available.packages()[, 1])]

install.packages(pks_missing)

dev_pkgs <- c("hadley/dplyr", 
              "RevolutionAnalytics/dplyrXdf", 
              "rstudio/RMarkdown", 
              "hadley/ggplot2", "rOpenSci/plotly")

devtools::install_github(dev_pkgs)

create_rand_split <- function(xdf, num_splits = 2,
                              split_freq = rep(1/num_splits, num_splits)) {
  
  
  rxDataStep(inData = xdf,
             outFile = xdf,
             transforms = list(
               kSplits = factor(sample(LETTERS[1:k], size = .rxNumRows, replace = TRUE, prob = prbs))
               ),
             transformObjects = list(LETTERS = LETTERS, k = num_splits, prbs = split_freq),
             overwrite = TRUE)
  
}

# taxi <- RxXdfData("yellow_tripdata_2015.xdf")

# taxi_xdf <- create_rand_split(taxi_xdf, 10)
# taxi_sample <- RxTextData('sample_taxi.csv')
# rxDataStep(inData = taxi, outFile = taxi_sample, rowSelection = kSplits == "A")
