#Load libaries
library(data.table)
library(ggplot2)

# Load the data
parks <- read.csv("~/Documents/parksvis1.csv", stringsAsFactors = FALSE)
parks1 <- parks[complete.cases(parks),] #Get rid of any empty trailling rows
setDT(parks1) #Make it a data.table because Data Science

names(parks1) <- gsub("X", "", names(parks)) 

setkey(parks1, park) # Order by park

mparks <- melt(parks1, "park")
mparks1 <- mparks
mparks$park = NULL

wss <- NULL
for (i in 2:15) {wss[i] <- sum(kmeans(mparks, centers=i)$withinss)}
plot(wss, type = "l", xlab = "Clusters",ylab = "Within SS Error", main = "Error with different number of clusters")

# Create models with 3 and 6 clusters based on the elbow approach.
parksclusterreal <- kmeans(mparks, 3, nstart =10)
parksclusterfun <- kmeans(mparks, 6, nstart =10)

# Add the cluster labels to the data frame
mparks$cluster <- parksclusterreal$cluster
mparks$clusterfun <- parksclusterfun$cluster
mparks$park <- mparks1$park
mparks[, c("park", "cluster", "clusterfun"), with = FALSE]
mparks[park == "UNIVERSAL STUDIOS JAPAN"]$cluster
mparks[clusterfun == 6]

setkey(mparks, park)

mparks[, sixcluster := names(table(clusterfun)[table(clusterfun)==max(table(clusterfun))]), by = park]
mparks[,threecluster := names(table(cluster)[table(cluster)==max(table(cluster))]), by = park]
mparks[, lastcluster6 := last(clusterfun), by = park]
mparks[,lastcluster3 := last(cluster), by = park]

mparks[park == "UNIVERSAL STUDIOS JAPAN"]
parkshort <- mparks[,c("park", "threecluster", "sixcluster", "lastcluster3", "lastcluster6"), with = FALSE]
setkey(parkshort, park)
parkshort <- unique(parkshort)
setkey(parkshort, lastcluster6)
parkshort[lastcluster6 == 6]

### World map of parks by cluster using ggplot

jpeg(filename = "~/Documents/theme/themepics/clusters6.jpeg" , width = (429*2) , height = (130*2), units = "px") 

mp <- NULL
mapWorld <- borders("world", colour="gray10", fill="gray10") # create a layer of borders
mp <- ggplot(data = info, aes(x= long, y= lat , color= as.factor(clusterfun))) +   mapWorld + theme_bw()
mp <- mp+ geom_point(size = 5, shape = 5) + ylim(c(0, 60))+ ggtitle("Clusters of theme parks by location, operator, and opening date") + labs(colour='Cluster')
mp
dev.off()

jpeg(filename = "~/Documents/theme/themepics/clusters3.jpeg" , width = (429*2) , height = (130*2), units = "px") 

mp <- NULL
mapWorld <- borders("world", colour="gray10", fill="gray10") # create a layer of borders
mp <- ggplot(data = info, aes(x= long, y= lat , color= as.factor(cluster))) +   mapWorld + theme_bw()
mp <- mp+ geom_point(size = 5, shape = 5) + ylim(c(0, 60)) + ggtitle("Clusters of theme parks by location, operator, and opening date")+ labs(colour='Cluster')
mp
dev.off()

yyy <- info[,c("park", "cluster", "clusterfun"), with = FALSE]
setkey( yyy, cluster)
setkey(yyy, clusterfun)
yyy[clusterfun == 6]
