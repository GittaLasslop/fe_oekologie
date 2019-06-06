# R commands zum handout NPP

for (p in c("raster", "rgeos", "ggplot2", "rworldmap", "maps", 
            "mapproj", "rgdal")) {
  if (!require(p, character.only=TRUE)) {
    install.packages(p)
    library(p, character.only=TRUE)
  }
}

setwd('/home/gitta/R/Lehre/FE_OEKOLOGIE/fe_oekologie_2019/handouts/')

geotiff2df <- function(file, name, valid_range, scale_factor=1){
  rdata=raster(file)
  rdata[rdata<valid_range[1]]=NA
  rdata[rdata>valid_range[2]]=NA
  rdata=rdata*scale_factor
  
  dfdata=as.data.frame(rasterToPoints(rdata))
  names(dfdata)=c('x','y',name)
  
  return(dfdata)
}

nppScaleFactor <- 0.0001
nppValidRange  <- c(0, 65500)

data.dir <- 'data/NPP/MEXICO'
file <- file.path(data.dir, "MOD17A3_2010-01-01.Npp_1km.tif")
dfNPP <- geotiff2df(file, "NPP", valid_range = nppValidRange, 
                    scale_factor = nppScaleFactor)

p=ggplot(data=dfNPP,aes(x = x, y = y))
p = p + geom_raster(aes(fill = NPP))
p = p + scale_fill_gradient(low = "yellow", high = "green")
p = p + coord_fixed()
print(p)

LatNPP=aggregate(dfNPP[3],by=list(lat=dfNPP$y),FUN='mean')

plot(LatNPP$lat,LatNPP$NPP,xlab='Latitude', ylab='NPP [kg C/m²/Jahr]',type='l',lwd=3)

LCTlookuptable=read.table('data/NPP/MEXICO/LCT3Lookuptable.txt',header=TRUE)
file <-file.path(data.dir, "MCD12Q1_2010-01-01.Land_Cover_Type_3.tif")
dfLCT <- geotiff2df(file, 'id', valid_range = c(0, 253))
dfLCT = merge(dfLCT, LCTlookuptable, by="id", all.x=TRUE)

p <- ggplot(dfLCT, aes(x = x, y = y))
p = p + geom_raster(aes(fill = name))
p = p + coord_fixed()
print(p)

dfData <- merge(dfNPP, dfLCT, by=c("x", "y"))
ind=which(dfData$name=='Non-vegetated'|dfData$name=='Deciduous Needleleaf forest'|dfData$name=='Water')
dfData=dfData[-ind,]
p <- ggplot(dfData, aes(x=name, y=NPP, fill=name))
p <- p + geom_boxplot(na.rm=T)
p <- p + guides(fill=FALSE)
p <- p + xlab(NULL)
p <- p + ylab("NPP [kg(C)/m^2]")
p <- p + coord_flip()
p

file <- paste0("plots/NPP/Borneo_NPP.pdf")
pdf( file, paper="special", width=8, height=8)
print(p)
dev.off()
