MRS for Trainers
================

[Signup Sheet](https://onedrive.live.com/redir?resid=38B5EC7C9195C01B!224&authkey=!ABNM-z62PPZ2KC8&ithint=file%2cxlsx)
[Feedback Survey](https://www.surveymonkey.com/r/HZFVHR8)

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

## Data
+ [Link to Data](https://microsoft-my.sharepoint.com/personal/alizaidi_microsoft_com/_layouts/15/guestaccess.aspx?guestaccesstoken=z93XnvZYkC%2fv9wIByirEMaSnm0uKyK33T6MLfWov0aw%3d&docid=2_11ba7b32a07954f26bdc0e4e3fec4c0f9&rev=1)

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

# Todo
+ ~~give one source for the presentation
    * add params for different source types~~
+ packrat the installation process
+ create function for data transform and plot
+ add do section in intro-to-r
+ add magrittr section in intro-to-r
+ move data to one drive personal or azure blob storage
+ send out recommendations algorithm
+ how to make interative plots in jupyter
