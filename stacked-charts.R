library(ggplot2)
library(dplyr)

covid19_stacked_chart <- function(country="worldwide") {  
  data_confirmed <- read.csv("time_series_covid19_confirmed_global.csv", head=TRUE)
  data_recovered <- read.csv("time_series_covid19_recovered_global.csv", head=TRUE)
  data_deaths <- read.csv("time_series_covid19_deaths_global.csv", head=TRUE)

  

  if (country == "worldwide") {
    #worldwide
    confirmed <- as.numeric(colSums(data_confirmed[,5:ncol(data_confirmed)]))
    recovered<- as.numeric(colSums(data_recovered[,5:ncol(data_recovered)]))
    deaths <- as.numeric(colSums(data_deaths[,5:ncol(data_deaths)]))
  } else {
    
    confirmed <- as.numeric(colSums(data_confirmed[data_confirmed[,"Country.Region"]==country,5:ncol(data_confirmed)]))
    recovered<- as.numeric(colSums(data_recovered[data_recovered[,"Country.Region"]==country,5:ncol(data_recovered)]))
    deaths <- as.numeric(colSums(data_deaths[data_deaths[,"Country.Region"]==country,5:ncol(data_deaths)]))
    
    
  }



  active <- confirmed-(recovered + deaths)

  time <- rep(seq(1:length(recovered)), 3)
  value <- c(recovered, deaths, active)
  group <- rep(c("recovered","deaths", "active"), each=length(confirmed))
  group <- factor(group, levels=c("recovered","deaths", "active"))
  data <- data.frame(time, value, group)
  ggplot(data, aes(x=time, y=value, fill=group)) + geom_area() + ggtitle(paste("COVID19 evolution in ", country)) + theme(legend.position="bottom") + scale_fill_manual(values=c("#4DF068", "#FF5B52", "#FFCD57")) 
}