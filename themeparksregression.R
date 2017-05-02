
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

info <- read.csv("~/Documents/parkinfo.csv", stringsAsFactors = FALSE)
info <- info[complete.cases(info),] #Get rid of any empty trailling rows
setDT(info)
xx <- info[,c("park", "operator", "country"), with =FALSE]


mparks <- melt(parks, "park")
setDT(mparks)
setnames(mparks, c("park", "variable", "value"), c("park", "year", "visitors"))
setkey(mparks, year)

yyy <- merge(mparks, xx, by = "park")
levels(as.factor(yyy$country))
zzz <- merge(parks, xx, by = "park")

lmset <- yyy
lmset[,asia:= ifelse(lmset$country %in%c("China", "Hong Kong", "Japan", "South Korea"), 1, 0),]
lmset[,universal := ifelse(lmset$operator == "Universal Parks and Resorts", 1, 0),]

asialm <- lm(data = lmset,  formula = visitors ~ as.numeric(year)  + universal + asia + universal*asia*as.numeric(year) , na.action = "na.omit")
summary(asialm)


s <- zzz[,c("park", "year", "asia", "universal", "visitors")]

universal <- lmset[universal==1]
universal$year <- as.numeric(universal$year)
not_universal <- lmset[universal==0]

a <- lm(data = universal, visitors ~ year)
b <- lm(data = not_universal, visitors ~ year)

asia <- lmset[asia ==1]
not_asia <- lmset[asia ==0]

c <- lm (data = asia, visitors ~ year)
d <- lm (data = not_asia, visitors ~ year)

g <- ggplot() +geom_point(data = lmset, aes(x = year, y = visitors), colour = lmset$universal+1, shape = 1) + geom_abline(intercept=a$coefficients[1],slope= a$coefficients[2], colour = "red") + geom_abline(intercept=b$coefficients[1],slope= b$coefficients[2]) + ggtitle("Visitor numbers by year (Universal vs Other)") + ylab("Visitor numbers") + theme_bw()
g

h <- ggplot() + geom_point(data = lmset, aes(x = year, y = visitors), colour = lmset$asia+1, shape = 1) + geom_abline(intercept=c$coefficients[1],slope=c$coefficients[2], colour = "red") +geom_abline(intercept=d$coefficients[1],slope=d$coefficients[2]) + ggtitle("Visitor numbers by year (Asia vs. Other)") + theme_bw()
h 

asia$year <- as.numeric(asia$year)
asia[,mean(visitors, na.rm = TRUE), by = year]