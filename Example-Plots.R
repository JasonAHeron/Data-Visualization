require(reshape2)
require(ggplot2)

#read in merged GDP (for 10 years) + EPC
#replace <PATH TO> with your path
data <- read.csv("/Users/jason/Documents/UCSC/CS198/POP_GDP_MERGE_ENERGY_PER.csv", header=T, stringsAsFactors=F, na.strings=c("NA","--"))
gdp_epc <- read.csv("/Users/jason/Documents/UCSC/CS198/GDP10_MERGE_ENERGY_PER.csv", header=T, stringsAsFactors=F, na.strings=c("NA","--"))

#convert to numeric
for(i in 2:ncol(data)){data[,i] <- as.numeric(data[,i])}
for(i in 2:ncol(gdp_epc)){gdp_epc[,i] <- as.numeric(gdp_epc[,i])}

#subset on population
data_subset <- subset(data ,POP2010 > 32000)

##bar plot
ggplot(data_subset, aes(x=reorder(Country, -X2010),y=X2010)) + geom_bar(stat="identity") + geom_text(aes(label=round(X2010,0)),hjust=1.1,size=4,angle=90,color="white") + theme_bw() + theme(axis.text.x = element_text(angle=60,hjust=1)) + xlab("Countries") + ylab("Energy use per capita - Million BTU / Person") + ggtitle("Countries with EUPC above 32000MBTU/Person in year 2010")

#extract countries for line plots
country_epc <- (data[data$Country %in% c("Canada", "United States", "Russia", "Germany", "Australia"),])

#drop POP and GDP
country_epc$POP2010 <- NULL
country_epc$GDP2010 <- NULL

#now we need to "melt" using the "reshape2" library. you may need to install it.
#using specified countries pull off merged data and melt into a format R can handle for line graphs
country_epc <- melt(country_epc, id.vars="Country", value.name="EPC", variable.name="Year")

##line graph
ggplot(data=country_epc, aes(x=Year, y=EPC, group = Country, colour = Country)) +
    geom_line() +
    geom_point( size=4, shape=21, fill="white")

#energy per capita
country_epc_gdp_core <- (gdp_epc[gdp_epc$Country %in% c("Canada", "United States", "Russia", "Germany", "France", "Spain", "Italy", "Iran", "South Africa", "Ukraine", "Poland", "Argentina", "China", "Thailand", "Mexico", "Turkey", "Brazil", "Algeria", "Egypt", "Columbia", "Indonesia", "India", "Australia"),])
country_epc_gdp <- country_epc_gdp_core
country_epc_gdp2 <- country_epc_gdp_core
#temporarily drop off gdp values so we can melt EPC
drops <- c("G2000","G2001","G2002","G2003","G2004","G2005","G2006","G2007","G2008","G2009","G2010")
country_epc_gdp <- country_epc_gdp[,!names(country_epc_gdp) %in% drops]
#reshape
country_epc_gdp <- melt(country_epc_gdp, id.vars="Country", value.name="EPC", variable.name="Year")
#temporarily drop off EPC values so we can melt GDP
drops <- c("X2000","X2001","X2002","X2003","X2004","X2005","X2006","X2007","X2008","X2009","X2010")
country_epc_gdp2 <- country_epc_gdp2[,!names(country_epc_gdp2) %in% drops]
#reshape
country_epc_gdp2 <- melt(country_epc_gdp2, id.vars="Country", value.name="GDP", variable.name="Year")
#pull stuff back together post melt
country_epc_gdp$GDP <- (country_epc_gdp2[country_epc_gdp2$Country %in% c("Canada", "United States", "Russia", "Germany", "France", "Spain", "Italy", "Iran", "South Africa", "Ukraine", "Poland", "Argentina", "China", "Thailand", "Mexico", "Turkey", "Brazil", "Algeria", "Egypt", "Columbia", "Indonesia", "India", "Australia"),3])
country_epc_gdp2 <- NULL

#scatter plot
ggplot(data=country_epc_gdp, aes(x=GDP, y=EPC, color=Country, group=Country)) + geom_point() + stat_smooth(method=lm)