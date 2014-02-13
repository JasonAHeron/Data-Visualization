# population from http://esa.un.org/wpp/Excel-Data/population.htm. Data in thousands
# energy data from eia.gov. Data per capita in MBTU/person , TEU in QBTU

######################### data importing and cleaning
#read in GDP data
gdp <- read.csv("~/Documents/UCSC/CS198/GDP_DATA.csv", header=T, stringsAsFactors=F)
#read in population data
pop <- read.csv("~/Documents/UCSC/CS198/POPULATION_DATA_THOUSANDS.csv", header=T, stringsAsFactors=F)
#read in merged data GDP + POP +EPC
merge_per <-read.csv("~/Documents/UCSC/CS198/POP_GDP_MERGE_ENERGY_PER.csv", header=T, stringsAsFactors=F)
#read in merged data GDP + POP + TEU
merge_total <-read.csv("~/Documents/UCSC/CS198/POP_GDP_MERGE_ENERGY.csv", header=T, stringsAsFactors=F)

#convert raw GDP data to numeric
for(i in 2:ncol(gdp)){gdp[,i] <- as.numeric(gdp[,i])}
#convert raw population data to numeric
for(i in 2:ncol(pop)){pop[,i] <- as.numeric(pop[,i])}
#convert fully merged GDP+POP+EPC to numeric
for(i in 2:ncol(merge_per)){merge_per[,i] <- as.numeric(merge_per[,i])}
#convert fully merged GDP+POP+TEU to numeric
for(i in 2:ncol(merge_total)){merge_total[,i] <- as.numeric(merge_total[,i])}

######################### dependancies
require(ggplot2)
require(reshape2)
require(grid)

######################### simple energy use per capita
#take reasonable simple subset resulting in 33 elements
epc_simple_subset <- subset(merge_per,X2010 > 200)
#plot0
p0 <- ggplot(epc_simple_subset, aes(x=reorder(Country, -X2010),y=X2010)) + geom_bar(stat="identity") + geom_text(aes(label=round(X2010,0)),hjust=1.1,size=4,angle=90,color="white") + theme_bw() + theme(axis.text.x = element_text(angle=60,hjust=1)) + xlab("Countries") + ylab("Energy use per capita - Million BTU / Person") + ggtitle("Countries with EUPC above 200MBTU/Person in year 2010")

######################### energy use per capita subset by population
#take reasonable subset by population resulting in 33 elements
epc_pop_subset <- subset(merge_per,POP2010 > 32000)
#plot1
p1 <- ggplot(epc_pop_subset, aes(x=reorder(Country, -X2010),y=X2010)) + geom_bar(stat="identity") + geom_text(aes(label=round(X2010,0)),vjust=-0.3,size=4,angle=0,color="black") + theme_bw() + theme(axis.text.x = element_text(angle=60,hjust=1)) + xlab("Countries") + ylab("Energy use per capita - Million BTU / Person") + ggtitle("Countries with population above 32000000 ordered MBTU/Person in year 2010")

######################### energy use per capita subset by GDP
#take reasonable subset by GDP resulting in 33 elements
epc_gdp_subset <- subset(merge_per,GDP2010 > 300000000000)
#plot1
p2 <- ggplot(epc_gdp_subset, aes(x=reorder(Country, -X2010),y=X2010)) + geom_bar(stat="identity") + geom_text(aes(label=round(X2010,0)),vjust=-0.3,size=4,angle=0,color="black") + theme_bw() + theme(axis.text.x = element_text(angle=60,hjust=1)) + xlab("Countries") + ylab("Energy use per capita - Million BTU / Person") + ggtitle("Countries with GDP above 300000000000 ordered MBTU/Person in year 2010")

######################### simple total energy use
#take reasonable simple subset resulting in 33 elements
teu_simple_subset <- subset(merge_total,X2010 > 4)
#plot2
p3 <- ggplot(teu_simple_subset, aes(x=reorder(Country, -X2010),y=X2010)) + geom_bar(stat="identity") + geom_text(aes(label=round(X2010,0)),vjust=-0.3,size=4,angle=0,color="black") + theme_bw() + theme(axis.text.x = element_text(angle=60,hjust=1)) + xlab("Countries") + ylab("Total Energy Use - Quadrillion BTU") + ggtitle("Countries with TEU above 4QBTU in year 2010")

######################### total energy use subset by population
#take reasonable subset by population resulting in 33 elements
teu_pop_subset <- subset(merge_total,POP2010 > 32000)
#plot 3
p4 <- ggplot(teu_pop_subset, aes(x=reorder(Country, -X2010),y=X2010)) + geom_bar(stat="identity") + geom_text(aes(label=round(X2010,0)),vjust=-0.3,size=4,angle=0,color="black") + theme_bw() + theme(axis.text.x = element_text(angle=60,hjust=1)) + xlab("Countries") + ylab("Total Energy Use - Quadrillion BTU") + ggtitle("Countries with population above 32000000 ordered by TEU in year 2010")

######################### total energy use subset by GDP
#take reasonable subset by GDP resulting in 33 elements
teu_gdp_subset <- subset(merge_total,GDP2010 > 315000000000)
#plot 3
p5 <- ggplot(teu_gdp_subset, aes(x=reorder(Country, -X2010),y=X2010)) + geom_bar(stat="identity") + geom_text(aes(label=round(X2010,0)),vjust=-0.3,size=4,angle=0,color="black") + theme_bw() + theme(axis.text.x = element_text(angle=60,hjust=1)) + xlab("Countries") + ylab("Total Energy Use - Quadrillion BTU") + ggtitle("Countries with GDP above 315000000000 ordered by TEU in year 2010")

######################### line plots
#using specified countries pull off merged data and melt into a format R can handle for line graphs
#energy per capita
country_epc <- (merge_per[merge_per$Country %in% c("Canada", "United States", "Russia", "Germany", "France", "Spain", "Italy", "Iran", "South Africa", "Ukraine", "Poland", "Argentina", "China", "Thailand", "Mexico", "Turkey", "Brazil", "Algeria", "Egypt", "Columbia", "Indonesia", "India", "Australia"),])
country_epc$POP2010 <- NULL
country_epc$GDP2010 <- NULL
country_epc <- melt(country_epc, id.vars="Country", value.name="EPC", variable.name="Year")
#plot 6
p6 <- ggplot(data=country_epc, aes(x=Year, y=EPC, group = Country, colour = Country)) +
    geom_line() +
    geom_point( size=4, shape=21, fill="white")
#total energy
country_teu <- (merge_total[merge_total$Country %in% c("Canada", "United States", "Russia", "Germany", "France", "Spain", "Italy", "Iran", "South Africa", "Ukraine", "Poland", "Argentina", "China", "Thailand", "Mexico", "Turkey", "Brazil", "Algeria", "Egypt", "Columbia", "Indonesia", "India", "Australia"),])
country_teu$POP2010 <- NULL
country_teu$GDP2010 <- NULL
country_teu <- melt(country_teu, id.vars="Country", value.name="TEU", variable.name="Year")
#plot 7
p7 <- ggplot(data=country_teu, aes(x=Year, y=TEU, group = Country, colour = Country)) +
    geom_line() +
    geom_point( size=4, shape=21, fill="white")

######################### multiplot (http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/)
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

#plot graphs
######################### bar graphs
#multiplot(p0,p1,p2,p3,p4,p5, cols=2)
######################### line graphs
multiplot(p6,p7,cols=2)