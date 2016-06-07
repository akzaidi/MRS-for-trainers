system("sudo apt-get -y build-dep libcurl4-gnutls-dev")
system("sudo apt-get -y install libcurl4-gnutls-dev")
install.packages('devtools')
devtools::install_github("akzaidi/SparkRext")
