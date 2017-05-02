library(ggmap)
library(ggplot2)
library(maptools)
library(maps)
library(data.table)

info <- read.csv("~/Documents/parkinfo.csv", stringsAsFactors = FALSE)
#vis <- read.csv("~/Documents/parksvis.csv")
info <- info[complete.cases(info),]
setDT(info)
info$opened <- as.Date(info$opened)
setkey(info, park)
setkey(info, opened)


# Setup for an animation 
a_vec <- seq(1840, 2016 , by=1)

anim <- info$park
B = matrix( rep(0, length(a_vec)*length(info$park)),
     nrow= length(a_vec), 
     ncol= length(info$park))
x= 1
i =1 
for (i in 1:ncol(B))
{
  for (x in 1: nrow(B))
  {open_date <- as.numeric(year(info$opened[i]))
  c_year <- a_vec[x]
  #if the park hasn't opened yet give the cell 0
  if ( open_date < c_year)
  {B[x,i] <- 0} else
    if (open_date == c_year)
    {B[x,i] <- 10}
  }}

for (i in 1:ncol(B))
{
  for (x in 2: nrow(B))
  {if (B[x-1, i] > 1){ B[x,i] <- B[x-1, i] - 1}else
    if(B[x-1, i] == 1){ B[x,i] <- 1}
  }}


B <- data.frame(B)
B <- cbind( a_vec, B)
setDT(B)
names(B) <- c("years", info$park)

xxx <- melt(B, "years")
loc <- data.table("variable" = info$park, "lat"= info$lat, "long"= info$long)
xxx <- merge(xxx, loc, by = "variable", all.x = TRUE)

setkey(xxx, years)
xxx[years ==1856]

for (i in 1: length(a_vec))
{mydata <- xxx[years ==a_vec[i]]
mydata <- mydata[mydata$value!=0,]
jpeg(filename = paste("~/Documents/theme/themepics/anim", i, ".jpeg", sep = ""), width = (429*2) , height = (130*2), units = "px") 
mp <- NULL
mapWorld <- borders("world", colour="gray50", fill="gray50") 
mp <- ggplot() +   mapWorld + theme_bw() + ggtitle(a_vec[i])
mp <- mp+ geom_point(aes(x=mydata$long, y=mydata$lat) ,color = "orange", size = mydata$value/1.5) + ylim(c(0, 60))
plot(mp)
dev.off()
}










## Locations of Florida theme Parks
florida <- map_data("state")
florida <- florida[florida$region=="florida",]
p <- ggplot()
p <- p + geom_polygon( data=florida, aes(x=long, y=lat, group = group),colour="white", fill="grey10" )
p + geom_point( data=info[info$city == "Orlando",], aes(x=long, y=lat), color="coral1")


xxx <- as.3dpoints(info$long, info$lat, info$opened)


info$coord<- paste(info$long, info$lat, sep=",")
coord <- data.frame(info$long, info$lat)
c_points <- SpatialPoints(coord)
stConstruct(info,  info$opened, info$coord, interval = FALSE, max(info$opened))
## Crappy looking park map in baseish code

map("world", fill=TRUE, col="white", bg="lightblue", ylim=c(-60, 90), mar=c(0,0,0,0))
points(info$long,info$lat, col="red", pch=1)

### World map of parks using ggplot
mp <- NULL
mapWorld <- borders("world", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() +   mapWorld + theme_bw()
mp <- mp+ geom_point(aes(x=info$long, y=info$lat, frame = info$opened) ,color="blue", size=1) + ylim(c(0, 60))
mp
