MRS for Trainers
================

# Decisions

+ Topics
    * R Fundamentals
    * Data Manipulation with Open Source R
    * Data Visualization with Open Source R
    * Statistical Modeling with Open Source R
    * All the Above with MRS
+ Datasets
    * NYC Taxi Data
    * Flights Data
    * Pick Your Own?
+ Compute Contexts
    * Local
    * LocalParallel
    * RxSpark
    * RxInSqlServer
+ Train the trainer curriculum
+ IDE Choices
    * should be RTVS
    * using RStudio for a few reasons
+ Jupyter Notebooks, RMarkdowns, PPTs
+ Infrastructure
    * DSVM
    * Local install
    * multi-tenant server
    * logistics become trickier when dealing with compute contexts

# Logistics
+ need MRO 3.2.2, MRS >= 7.5 (most likely 8.0)
+ an R IDE
+ Packages
    * dplyr
    * data.table
    * stringr
    * dplyrXdf
    * RMarkdown
    * ggplot2
    * plotly
    * pryr

# Course Repository

+ Current content:
    * [MRS for SAS Users](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Tutorials/MRS-for-SAS-Users/MRS%20for%20SAS%20Users.md)
    * [R for SAS Users](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Tutorials/R-for-SAS-Users/R%20for%20SAS%20Users.md)

# Day One - R Fundamentals

+ R Data Types
+ Data Manipulation with dplyr
+ AzureML package

# Day Two - MRS Fundamentals

+ dplyrXdf
+ rxDataStep and rxTransforms complex pipelines

# Day Three - Compute Contexts

+ RxSpark
+ SparkR
+ Train the trainer