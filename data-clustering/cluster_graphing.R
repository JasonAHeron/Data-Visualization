##clustering
require(reshape2)
require(ggplot2)
require(grid)

TEU_3_means <- read.csv("~/Documents/UCSC/CS198/data-clustering/TEU_3_means.csv")
TEU_3_means <- melt(TEU_3_means, id.vars="Trends", value.name="TEU", variable.name="Year")
p1 <- ggplot(data=TEU_3_means, aes(x=Year, y=TEU, group = Trends, colour = Trends)) +
    geom_line() +
    geom_point( size=4, shape=21, fill="white") + ggtitle("Total Energy k=3 clustering")


TEU_5_means <- read.csv("~/Documents/UCSC/CS198/data-clustering/TEU_5_means.csv")
TEU_5_means <- melt(TEU_5_means, id.vars="Trends", value.name="TEU", variable.name="Year")
p2 <- ggplot(data=TEU_5_means, aes(x=Year, y=TEU, group = Trends, colour = Trends)) +
    geom_line() +
    geom_point( size=4, shape=21, fill="white") + ggtitle("Total Energy k=5 clustering")

EPC_5_means <- read.csv("~/Documents/UCSC/CS198/data-clustering/EPC_5_means.csv")
EPC_5_means <- melt(EPC_5_means, id.vars="Trends", value.name="EPC", variable.name="Year")
p4 <- ggplot(data=EPC_5_means, aes(x=Year, y=EPC, group = Trends, colour = Trends)) +
    geom_line() +
    geom_point( size=4, shape=21, fill="white") + ggtitle("Energy Usage Per Capita k=5 clustering")


EPC_3_means <- read.csv("~/Documents/UCSC/CS198/data-clustering/EPC_3_means.csv")
EPC_3_means <- melt(EPC_3_means, id.vars="Trends", value.name="EPC", variable.name="Year")
p3 <- ggplot(data=EPC_3_means, aes(x=Year, y=EPC, group = Trends, colour = Trends)) +
    geom_line() +
    geom_point( size=4, shape=21, fill="white") + ggtitle("Energy Usage Per Capita k=3 clustering")


multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


multiplot(p1,p2,p3,p4,cols=2)