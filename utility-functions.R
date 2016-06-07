pkgs_to_install <- c("devtools", "data.table", "stringr")
pks_missing <- pkgs_to_install[!(pkgs_to_install %in% installed.packages()[, 1])]

install.packages(pks_missing)

install.packages('shiny')

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


load("manhattan.RData")
taxi_df <- mutate(taxi_df, tip_pct = tip_amount/fare_amount)

taxi_hood_sum <- function(taxi_data = taxi_df, ...) {
  
  taxi_data %>% 
    filter(pickup_nhood %in% manhattan_hoods,
           dropoff_nhood %in% manhattan_hoods, ...) %>% 
    group_by(dropoff_nhood, pickup_nhood) %>% 
    summarize(ave_tip = mean(tip_pct), 
              ave_dist = mean(trip_distance)) %>% 
    filter(ave_dist > 3, ave_tip > 0.05) -> sum_df
  
  return(sum_df)
  
}


tile_plot_hood <- function(df = taxi_hood_sum()) {
  
  library(ggplot2)
  
  ggplot(data = df, aes(x = pickup_nhood, y = dropoff_nhood)) + 
    geom_tile(aes(fill = ave_tip), colour = "white") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = 'bottom') +
    scale_fill_gradient(low = "white", high = "steelblue") -> gplot
  
  return(gplot)
}

# data.frame version
tile_plot_hood(taxi_hood_sum(taxi_df))

# xdf version
# taxi_group_xdf <- taxi_hood_sum(taxi_transform,
#                                 .rxArgs = list(transformObjects =
#                                                  list(manhattan_hoods = manhattan_hoods)))

# tile_plot_hood(as.data.frame(taxi_group_xdf))

# Spark DataFrame version
library(SparkRext)
taxi_summary <- taxi_hood_sum(sample_taxi)
taxi_df <- taxi_summary %>% collect
tile_plot_hood(taxi_df)