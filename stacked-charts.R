library(ggplot2)
library(dplyr)

data_confirmed <- read.csv("time_series_covid19_confirmed_global.csv", head=TRUE)
data_recovered <- read.csv("time_series_covid19_recovered_global.csv", head=TRUE)
data_deaths <- read.csv("time_series_covid19_deaths_global.csv", head=TRUE)

diffs <- function(x) {
  diffs <- vector(length=1)
  diffs[1] <- 0
  for (i in 2:length(x)) {
    diffs[i] <- x[i] - x[i-1]
  }
  diffs
}

get_data <- function(country="worldwide") {
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

  data <- matrix(c(confirmed, deaths, recovered), ncol=3)
  colnames(data) <- c("confirmed", "deaths", "recovered")
  rownames(data) <- colnames(data_confirmed[,5:ncol(data_confirmed)])
  data
}

covid19_stacked_bar_chart <- function(country="worldwide") {
  data <- t(get_data(country))
  data["recovered",] <- diffs(data["recovered",])
  data["deaths",] <- diffs(data["deaths",])
  data["confirmed",] <- diffs(data["confirmed",])
  sums <- colSums(data)
  percentages <- data

  for (date in 1:ncol(data)) {
    if (sums[date] != 0) {
    percentages["recovered",date] <- data["recovered",date] / sums[date]
    percentages["deaths",date] <- data["deaths",date] / sums[date]
    percentages["confirmed",date] <- data["confirmed",date] / sums[date]
    }    
  }
  
  barplot(percentages, border="white", xlab="group", legend=rownames(percentages), args.legend = list(x="topleft"))
}

covid19_stacked_chart <- function(country="worldwide") {  

  data <- get_data(country)
  active <- data[,"confirmed"]-(data[,"recovered"] + data[,"deaths"])

  time <- rep(seq(1:length(data[,"recovered"])), 3)
  value <- c(data[,"recovered"], data[,"deaths"], active)
  group <- rep(c("recovered","deaths", "active"), each=length(data[,"confirmed"]))
  group <- factor(group, levels=c("recovered","deaths", "active"))
  data <- data.frame(time, value, group)
 
  ggplot(data, aes(x=time, y=value, fill=group)) + geom_area() + ggtitle(paste("COVID19 evolution in ", country)) + theme(legend.position="bottom") + scale_fill_manual(values=c("#4DF068", "#FF5B52", "#FFCD57")) 
}