#Load libaries
library(data.table)
library(ggplot2)

# Load the data
info <- read.csv("~/Documents/parkinfo.csv", stringsAsFactors = FALSE)
info <- info[complete.cases(info),] #Get rid of any empty trailling rows
setDT(info) #Make it a data.table because Data Science
info$opened <- as.Date(info$opened) # Tell R this is a date
setkey(info, park) # Order by park
setkey(info, opened) # Order by Opening date
cols = c("opened", "lat", "long", "operator")

xxx <- info[,cols, with = FALSE] # Select only the columns we'll cluster on
xxx$opened <- as.numeric(as.Date(xxx$opened)) #Convert this to a number because K-means only takes numbers.
xxx$operator <- as.numeric(as.factor(xxx$operator)) # Same for the operator factor.

wss <- NULL
for (i in 2:15) {wss[i] <- sum(kmeans(xxx, centers=i)$withinss)}
plot(wss, type = "l", xlab = "Clusters",ylab = "Within SS Error", main = "Error with different number of clusters")

# Create models with 3 and 6 clusters based on the elbow approach.
parksclusterreal <- kmeans(xxx, 3, nstart =10)
parksclusterfun <- kmeans(xxx, 6, nstart =10)

# Add the cluster labels to the data frame
info$cluster <- parksclusterreal$cluster
info$clusterfun <- parksclusterfun$cluster

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
 