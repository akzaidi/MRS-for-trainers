# update cran
r <- getOption('repos')
# set mirror to something a bit more recent
r["CRAN"] <- "https://mran.revolutionanalytics.com/snapshot/2016-06-07/"
options(repos = r)
install.packages('magrittr')
install.packages('ggplot2')


load("manhattan.RData")

# Spark Cluster Package Installation Help ---------------------------------

system("sudo apt-get -y build-dep libcurl4-gnutls-dev")
system("sudo apt-get -y install libcurl4-gnutls-dev")
install.packages('devtools')
devtools::install_github("akzaidi/SparkRext")


rxHadoopListFiles("/nyctaxi")
rxHadoopCommand("fs -cat /nyctaxi/sample_taxi.csv | head")

# add SparkR location to your library paths
.libPaths(c(.libPaths(),
            file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# load SparkR
library(SparkR)


# Spark Context and Import ------------------------------------------------


# create sql context to create Spark DataFrames
sparkEnvir <- list(spark.executor.instance = '10',
                   spark.yarn.executor.memoryOverhead = '8000')

sc <- sparkR.init(
  sparkEnvir = sparkEnvir,
  sparkPackages = "com.databricks:spark-csv_2.10:1.3.0"
)

sqlContext <- sparkRHive.init(sc)


dataframe_import <- function(path) {
  
  library(SparkR)
  path <- file.path(path)
  path_df <- read.df(sqlContext, path,
                     source = "com.databricks.spark.csv",
                     header = "true", inferSchema = "true", delimiter = ",")
  
  return(path_df)
  
}

sample_taxi <- dataframe_import("/nyctaxi/sample_taxi.csv")


library(magrittr)
sample_taxi <- mutate(sample_taxi, tip_pct = sample_taxi$tip_amount/sample_taxi$fare_amount)

taxi_hood_sum <- function(taxi_data = taxi_df, ...) {
  
  taxi_data %>% 
    filter(taxi_data$pickup_nhood %in% manhattan_hoods) %>%
    filter(taxi_data$dropoff_nhood %in% manhattan_hoods) %>% 
    group_by(taxi_data$dropoff_nhood, taxi_data$pickup_nhood) %>% 
    summarize(ave_tip = mean(taxi_data$tip_pct), 
              ave_dist = mean(taxi_data$trip_distance)) %>% 
    filter("ave_tip > 0.05") %>% 
    filter("ave_dist > 3") -> sum_df
  
  return(sum_df)
  
}


tile_plot_hood <- function(df = taxi_hood_sum()) {
  
  
  ggplot(data = df, aes(x = pickup_nhood, y = dropoff_nhood)) + 
    geom_tile(aes(fill = ave_tip), colour = "white") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = 'bottom') +
    scale_fill_gradient(low = "white", high = "steelblue") -> gplot
  
  return(gplot)
}


# SparkRext version is prettier -------------------------------------------
library(SparkRext)


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


taxi_summary <- taxi_hood_sum(sample_taxi)
taxi_df <- taxi_summary %>% collect
tile_plot_hood(taxi_df)


# RxSpark rxLinMod Example ------------------------------------------------

rxHadoopListFiles("/user/RevoShare/")
data_path <- "/user/RevoShare/alizaidi"

write.df(sample_taxi, 
         file.path(data_path, "sampleTaxi"), 
         "com.databricks.spark.csv", 
         "overwrite", 
         header = "true")

sparkR.stop()

file_to_delete <- file.path(data_path, 
                            "sampleTaxi", "_SUCCESS")
delete_command <- paste("fs -rm", file_to_delete)
rxHadoopCommand(delete_command)


myNameNode <- "default"
myPort <- 0
hdfsFS <- RxHdfsFileSystem(hostName = myNameNode, 
                           port = myPort)

taxi_text <- RxTextData(file.path(data_path,
                                  "sampleTaxi"),
                        fileSystem = hdfsFS)

taxi_xdf <- RxXdfData(file.path(data_path, "taxiXdf"),
                      fileSystem = hdfsFS)


rxImport(inData = taxi_text, taxi_xdf, overwrite = TRUE)


# create RxSpark compute context
computeContext <- RxSpark(consoleOutput = TRUE)
rxSetComputeContext(computeContext)



taxi_Fxdf <- RxXdfData(file.path(data_path, "taxiXdfFactors"),
                       fileSystem = hdfsFS)


rxFactors(inData = taxi_xdf, outFile = taxi_Fxdf, 
          factorInfo = c("pickup_hour", "pickup_nhood")
)


system.time(linmod <- rxLinMod(tip_pct ~ trip_distance + pickup_hour + 
                                 pickup_nhood, 
                               data = taxi_Fxdf, blocksPerRead = 2))
