library(forecast)
library(ggplot2)
library(data.table)
library(randomForest)
options(scipen = 100)

info <- read.csv("~/Documents/parkinfo.csv")
info <- info[complete.cases(info),]

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
mparks$year <- as.numeric(as.character(mparks$year))

agparks <- mparks[,mean(visitors), by = year]
agparks <- ts(agparks$V1, start = min(agparks$year), end = max(agparks$year), frequency= 1)
agHW <- HoltWinters(agparks, beta=FALSE, gamma=FALSE)
plot.ts(agparks)
plot(agHW)

agarima <- Arima(agparks, order = c(0,2,0))
plot(forecast(agarima, agparks, h =10))

agmodel <- Arima(window(agparks, end = 2006 + 2),order=c(0,1,1),lambda=0)
plot(forecast(agmodel,h=48))
lines(agmodel)
# Apply fitted model to later data

agmodel2 <- Arima(window(agparks, start=2008),model= agmodel)
plot(forecast(agmodel2,h=1))            
xxx <- mparks[mparks$park %in% c("MAGIC KINGDOM", "UNIVERSAL STUDIOS FL", "UNIVERSAL STUDIOS JAPAN", "TOKYO DISNEYLAND"),]

for (i in 1:length(levels(as.factor(xxx$park))))
{
  mydata <- xxx[levels(as.factor(xxx$park))[i]]
  datts <- ts(mydata$visitors, start = 2006, end = 2015, frequency = 1)
  datHW <- auto.arima(datts, seasonal = FALSE)
  datHW <- Arima(datts, order = c(0,2,0))
  plot.new()
  datforecast <- forecast.Arima(datHW, h=10)
  plot.new()
  plot(x =0 , y = 0, main = levels(as.factor(xxx$park))[i], bty="n", axes = F, xlab = NA, ylab = NA)
  vvv <- data.frame("lower95" = datforecast$lower[,2], "upper95" = datforecast$upper[,2])
  print(grid.table(data.frame(year = seq(2016, 2025),vvv), rows = NULL))
  plot.new()
  plot(datforecast,  main = levels(as.factor(xxx$park))[i])
}

xtrain <- xxx[xxx$year != 2015,]

parkforest <- randomForest(visitors ~   + city + country + opened + operator   + owner + lat + long, data = xtrain)

xtest$prediction <- predict(parkforest, xtest)