library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(data.table)
library(directlabels)
parks <- read.csv("~/Documents/parksvis1.csv", header = TRUE, stringsAsFactors = FALSE)
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
setkey(mparks, year)

mparks["2014"]
mparks[,ranks := rank(-visitors, na.last = TRUE, ties.method = "min"), by = year]
mparks[,name := abbreviate(park)]
p <- ggplot(mparks, aes(factor(year), -ranks, group = name, colour = name, label = name)) + labs(colour='Park')
p1 <- p + geom_line() + theme(legend.position='none') + expand_limits(x=1)
p2 <- p1 + geom_dl(aes(label =name), method = list(dl.trans(x = x -.19 ), "last.points", cex = 0.8)) + xlab("Year") + ylab("Rank")
p2
plot.new()
abbreviate(levels(as.factor(mparks$park)))
