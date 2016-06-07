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


# create spark compute context
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