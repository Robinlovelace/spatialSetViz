# Aim: generate data for set viz

# Data generation
set.seed(2017)
x = runif(n = 20, min = 0, max = 1)
y = runif(n = 20, min = 0, max = 1)
red = runif(n = 20, min = 0, max = 1) > 0.5
blue = runif(n = 20, min = 0, max = 1) > 0.2
yellow = runif(n = 20, min = 0, max = 1) > 0.1
p = data.frame(x, y, red, blue, yellow)

# Convex hull generation
library(sp)
p_sp = SpatialPointsDataFrame(coords = cbind(x, y), data = p)
cv_red = rgeos::gConvexHull(p_sp[red,])
cv_blue = rgeos::gConvexHull(p_sp[blue,])
cv_yellow = rgeos::gConvexHull(p_sp[yellow,])

# visualise
library(tmap)
qtm(p_sp, symbols.size = 3) +
  qtm(cv_red, "red", fill.alpha = 0.2) +
  qtm(cv_blue, "blue", fill.alpha = 0.2) +
  qtm(cv_yellow, "yellow", fill.alpha = 0.2) 

# convert to graph
library(igraph)
library(tidygraph)
g = graph(n = nrow(p), edges = c(1, 2, 1, 3))

dists = spDists(p_sp)
mst = mst(graph = g, weights = unlist(dists))


tidygraph::