library(randomForest)
library(data.table)
library(reshape2)
library(ggplot2)
library(dplyr)
library(magrittr)
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

info <- read.csv("~/Documents/parkinfo.csv")
info <- info[complete.cases(info),]


mparks <- melt(parks, "park")
setDT(mparks)
xxx <- merge(mparks, info, by = "park", all.x = TRUE)
xxx <- xxx[complete.cases(xxx),]

xxx$year <- as.numeric(as.character((xxx$variable)))
xxx$date <- paste(xxx$year, "-01-01", sep = "")
xxx$date <- as.Date(xxx$date)
xxx$opened <- as.Date(xxx$opened)

xtrain <- xxx[xxx$year != 2015,]
xtest <- xxx[xxx$year == 2015,]
parkforest <- randomForest(value ~  year + city + country + date + operator + owner + lat + long, data = xtrain)

xtest$prediction <- predict(parkforest, xtest)

diff <- sqrt(( xtest$prediction - xtest$value)^2)
pctdiff <- diff/xtest$value
MRSE <- mean(sqrt(diff))


x1 <- xtest %>% select(park, value, prediction)
x1 <- melt(x1, "park")

g2<-ggplot(x1, aes(x = factor(park), y = value/1000000, fill=factor(variable))) + xlab("Park") +ylab("Visitors") + geom_bar(stat = "identity", position=position_dodge()) +theme(axis.text.x=element_blank())
  +
  geom_text(aes(y=value, ymax= value, label=round(value/1000000,2)), position= position_dodge(width=0.9), vjust=-.5, color="black") +
  scale_y_continuous("Visitors" ) + 
  scale_x_discrete("parks") + 
  scale_fill_discrete(name ="Park", labels=c("Observed", "Predicted"))
g2
  