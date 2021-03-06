library(plotly)

doInstall <- TRUE  # Change to FALSE if you don't want packages installed.
toInstall <- c("RColorBrewer")
if(doInstall){install.packages(toInstall, repos = "http://cran.us.r-project.org")}
lapply(toInstall, library, character.only = TRUE)

# Generate some data
nn <- 500
myData <- data.frame(X = rnorm(nn),
                     Y = rnorm(nn))

setK = 6  # How many clusters?
clusterSolution <- kmeans(myData, centers = setK)

myData$whichCluster <- factor(clusterSolution$cluster)

splitData <- split(myData, myData$whichCluster)
appliedData <- lapply(splitData, function(df){
  df[chull(df), ]  # chull really is useful, even outside of contrived examples 
  # to compute the subset of points which lie on the convex hull.
  # https://www.rdocumentation.org/packages/grDevices/versions/3.4.3/topics/chull
})
combinedData <- do.call(rbind, appliedData)

zp3 <- ggplot(data = myData,
              aes(x = X, y = Y))
zp3 <- zp3 + geom_polygon(data = combinedData,  # This is also a nice example of how to plot
                          aes(x = X, y = Y, fill = whichCluster),  # two superimposed geoms
                          alpha = 1/2)                             # from different data.frames
zp3 <- zp3 + geom_point(size=1)
zp3 <- zp3 + coord_equal()
zp3 <- zp3 + scale_fill_manual(values = colorRampPalette(rev(brewer.pal(11, "Spectral")))(setK))

p <- ggplotly(zp3)
p
#api_create(p, filename="convex")
