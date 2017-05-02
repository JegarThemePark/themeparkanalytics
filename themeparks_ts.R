library(forecast)
library(ggplot2)
library(data.table)
library(gridExtra)
library(spacetime)
options(scipen = 100)
parks <- read.csv("~/Documents/parksvis1.csv", header = TRUE, stringsAsFactors = FALSE)
parks <- parks[complete.cases(parks),]
parks$X2006 <- as.numeric(gsub(",", "", parks$X2006))
parks$X2007 <- as.numeric(gsub(",", "", parks$X2007))
parks$X2008 <- as.numeric(gsub(",", "", parks$X2008))
parks$X2009 <- as.numeric(gsub(",", "", parks$X2009))
parks$X2010 <- as.numeric(gsub(",", "", parks$X2010))
parks$X2011 <- as.numeric(gsub(",", "", parks$X2011))
parks$X2012 <- as.numeric(gsub(",", "", parks$X2012))
parks$X2013 <- as.numeric(gsub(",", "", parks$X2013))
parks$X2014 <- as.numeric(gsub(",", "", parks$X2014))
parks$X2015 <- as.numeric(gsub(",", "", parks$X2015))
names(parks) <- gsub("X", "", names(parks)) 


mparks <- melt(parks, "park")
setDT(mparks)
setnames(mparks, c("park", "variable", "value"), c("park", "year", "visitors"))
setkey(mparks, park)
mparks$year <- as.numeric(mparks$year)
myts <- ts(mparks$visitors, start = min(mparks$year), end = max(mparks$year), frequency= 1)

agparks <- mparks[,mean(visitors), by = year]
agparks <- ts(agparks, start = min(agparks$year), end = max(agparks$year), frequency= 1)
agHW <- HoltWinters(agparks, beta=FALSE, gamma=FALSE)
plot.ts(agparks)
plot(agHW)

xxx <- mparks[mparks$park %in% c("DISNEYLAND", "MAGIC KINGDOM", "UNIVERSAL STUDIOS FL"),]

for (i in 1:length(levels(as.factor(xxx$park))))
{
  mydata <- xxx[levels(as.factor(xxx$park))[i]]
  datts <- ts(mydata$visitors/1000000, start = 2006, end = 2015, frequency = 1)
  #plot.ts(datts, main = levels(as.factor(mparks$park))[i])
  datHW <- HoltWinters(datts, beta=FALSE, gamma=FALSE)
  plot.new()
  plot(datHW, main = levels(as.factor(xxx$park))[i], ylim = c(2,20))
  datforecast <- forecast.HoltWinters(datHW, h=10)
  plot.new()
  print(levels(as.factor(xxx$park))[i])
  plot.new()
  print(grid.table(datforecast$lower))
  plot.new()
  print(grid.table(datforecast$upper))
  plot.new()
  plot.forecast(datforecast,  main = levels(as.factor(xxx$park))[i], ylim = c(2,25))
}
datforecast$upper[,1]
plot.new()
grid.table( cbind(abbreviate(levels(as.factor(mparks$park)))))
