library(shiny)
library(choroplethr)
library(choroplethrZip)
library(dplyr)
library(ggplot2)
library(plotly)
library(leaflet)
library(leaflet.minicharts)
library(maps)
library(rgdal)
library(leaflet)
## Define Manhattan's neighborhood
man.nbhd=c("all neighborhoods", "Central Harlem", 
           "Chelsea and Clinton",
           "East Harlem", 
           "Gramercy Park and Murray Hill",
           "Greenwich Village and Soho", 
           "Lower Manhattan",
           "Lower East Side", 
           "Upper East Side", 
           "Upper West Side",
           "Inwood and Washington Heights")
zip.nbhd=as.list(1:length(man.nbhd))
zip.nbhd[[1]]=as.character(c(10026, 10027, 10030, 10037, 10039))
zip.nbhd[[2]]=as.character(c(10001, 10011, 10018, 10019, 10020))
zip.nbhd[[3]]=as.character(c(10036, 10029, 10035))
zip.nbhd[[4]]=as.character(c(10010, 10016, 10017, 10022))
zip.nbhd[[5]]=as.character(c(10012, 10013, 10014))
zip.nbhd[[6]]=as.character(c(10004, 10005, 10006, 10007, 10038, 10280))
zip.nbhd[[7]]=as.character(c(10002, 10003, 10009))
zip.nbhd[[8]]=as.character(c(10021, 10028, 10044, 10065, 10075, 10128))
zip.nbhd[[9]]=as.character(c(10023, 10024, 10025))
zip.nbhd[[10]]=as.character(c(10031, 10032, 10033, 10034, 10040))

## Load housing data
#load("../output/count.RData")
#load("../output/mh2009use.RData")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  ## Neighborhood name
  output$text = renderText({"Selected:"})
  output$text1 = renderText({
      paste("{ ", man.nbhd[as.numeric(input$nbhd)+1], " }")
  })
  output$BeginningText = renderUI({
    HTML("<br/><br/><br/>Our project !!<br/><br/>
         Crime and Rent!<br/><br/><br/><br/>Group 6: A,B,C,D")
  })
  
  ## Panel 1: summary plots of time trends, 
  ##          unit price and full price of sales. 
  
  output$CrimeMap <- renderLeaflet({
    ## Control Icon size and looks
    new_data <- read.csv("crime_to_plot.csv")
    tilesURL <- "http://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}"
    basemap <- leaflet(width = "100%", height = "400px") %>%
      addTiles(tilesURL)
    colors = c("red", "orange", "yellow")
    basemap %>%
      addMinicharts(
        new_data$LONG, new_data$LAT,
        type = "pie",
        chartdata = new_data[, c("FELONY", "MISDEMEANOR", "VIOLATION")], 
        colorPalette = colors, 
        width = 60 * sqrt(new_data$TOTAL) / sqrt(max(new_data$TOTAL)), transitionTime = 0
      )
 
  })
  
  output$Writeup <- renderText({
    ifelse(input$CrimeVar02 == "Total","We observe that Misdemeanor has the highest number of cases, followed by Felony and Violations.",
           ifelse(input$CrimeVar02=="Felony","We observe that Grand Larceny followed by Serious assualts contribute the maximum to Felony crimes",
                  ifelse(input$CrimeVar02=="Misdemeanor","We observe that Assaults followed by Criminal Mischief & Drug related crimes contribute significantly to Misdemeanor crimes",
                         ifelse(input$CrimeVar02=="Violation", "We observe that most of the crimes related to Violations are related to Harassment",
                                "We observe that during the month of October, the crimes are the highest and they are lowest in the month of February"
                         ))))
  })
  
  
  ## 2D map
  output$mymap <- renderLeaflet({
    ## Control Icon size and looks
    levelIcon <- iconList(
      Rent = makeIcon("./new icon/3.png", iconWidth = 48, iconHeight = 48, 
                       iconAnchorX = 24, iconAnchorY = 48),
      FELONY = makeIcon("IconCrime1.png", iconWidth = 40, iconHeight = 40, 
                       iconAnchorX = 20, iconAnchorY = 20),
      MISDEMEANOR = makeIcon("IconCrime2.png", iconWidth = 40, iconHeight = 40, 
                       iconAnchorX = 20, iconAnchorY = 20),
      VIOLATION = makeIcon("IconCrime3.png", iconWidth = 40, iconHeight = 40, 
                          iconAnchorX = 20, iconAnchorY = 20),
      Subway = makeIcon("./new icon/5.png", iconWidth = 48, iconHeight = 48, 
                      iconAnchorX = 24, iconAnchorY = 48),
      Police = makeIcon("./new icon/4.png", iconWidth = 48, iconHeight = 48, 
                        iconAnchorX = 24, iconAnchorY = 48),
      Hospital = makeIcon("./new icon/2.png", iconWidth = 48, iconHeight = 48, 
                        iconAnchorX = 24, iconAnchorY = 48)
    )
    
    ## subset the data
    Data <- read.csv("QueryMapData_v2.5.csv")
    tmp <- subset(Data, (Type1 == "Rent" | Type1 == "Crime"))
    tmp$Value <- tmp$Value * input$RentArea / 12
    if (as.character(input$type) == "Rent") # type: Rent, Crime, or Total
      tmp <- subset(tmp, Type1 == "Rent")
    if (as.character(input$type) == "Crime")
      tmp <- subset(tmp, Type1 == "Crime")
    
    if (as.character(input$CrimeType) != "Default") # select crime type
    {
      if (as.character(input$CrimeType) == "Total")
        tmp <- subset(tmp, Type1 == "Crime")
      else
        tmp <- tmp[grep(as.character(input$CrimeType), tmp$Type3),]
    }
    tmp <- subset(tmp, ((Type1 != "Rent") | (Value <= input$Price[2] )))# select rent price
    tmp <- subset(tmp, ((Type1 != "Rent") | (Value >= input$Price[1] )))
    
    if (!any("Felony" == input$CrimeType2))
      tmp <- subset(tmp, ((Type1 != "Crime") | Type2 != "FELONY"))
    if (!any("Misdemeanor" == input$CrimeType2))
      tmp <- subset(tmp, ((Type1 != "Crime") | Type2 != "MISDEMEANOR"))
    if (!any("Violation" == input$CrimeType2))
      tmp <- subset(tmp, ((Type1 != "Crime") | Type2 != "VIOLATION"))
    for (i in input$others)
      tmp <- rbind(tmp, Data[Data$Icon == i,])
    
    #Log = paste("level",floor(log((tmp$value) - min + 1, base =1.0001)/log(max - min + 1, base =1.0001) * 7 + 1),sep = "")
    
    tmp$rank[tmp$Type1 == "Rent"] = paste("Building Type: ",tmp$Type2[tmp$Type1 == "Rent"],"<br/>",
      "Average rent: $",round(tmp$Value[tmp$Type1 == "Rent"] , 2)," per month","<br/>",
      "<a href='http://www1.nyc.gov/assets/finance/jump/hlpbldgcode.html'>What is Building Type?</a>","<br/>",sep = "")
    tmp$rank[tmp$Type1 == "Crime"] = paste("Crime Type: ",tmp$Type2[tmp$Type1 == "Crime"],"-","<br/>",
                                          tmp$Remark[tmp$Type1 == "Crime"],"<br/>",sep = "")
    tmp$rank[tmp$Type1 == "Subway"] = as.character(tmp$Remark[tmp$Type1 == "Subway"])# Add remark
    tmp$rank[tmp$Type1 == "Police"] = as.character(tmp$Remark[tmp$Type1 == "Police"])# Add remark
    tmp$rank[tmp$Type1 == "Hospital"] = as.character(tmp$Remark[tmp$Type1 == "Hospital"])# Add remark
    
         #"<a href='https://en.wikipedia.org/wiki/",tmp$Country,"'>Wikipedia Page</a>","<br/>",
         #"<a href='https://www.wsj.com/search/term.html?KEYWORDS=",tmp$Country,"'>Wall Street Journal Page</a>"
    
    #index = match(input$commodity_2D,c('Housing Rent', 'Crime','Mouse'))
    #Labels = c("House","Crime","Mouse")
    ##### end subset      
    
      leaflet(tmp)%>%addProviderTiles("Esri.WorldStreetMap")%>%
        addMarkers(clusterOptions = markerClusterOptions(),
                   popup = ~rank, icon = ~levelIcon[Icon])%>%
        setView(lng = -73.966991,lat = 40.781489, zoom=13)#put Central Park in the centre
        
    
  })
  ## end 2D map
  output$SummaryCrimePlot <- renderImage({ # method to insert image
    
    ifelse(input$CrimeVar02 == "Total",img <- "./www/total pie.png",    
    ifelse(input$CrimeVar02 == "Felony",img <- "./www/felony pie.png",
    ifelse(input$CrimeVar02 == "Misdemeanor",img <- "./www/mis pie.png",
    ifelse(input$CrimeVar02 == "Violation",img <- "./www/violation pie.png",
                                       img <- "./www/crime by month.png"
           ))))
    png(img, width = 950, height = 600)
    dev.off()
    list(src = img,
         width = 950,
         height = 600,
         align = "center")
  }, deleteFile = FALSE)
  
  output$SummaryRentArea <- renderImage({
    
    img <- paste("./www/attachments/", input$RentVar01, ".png", sep = "")
    
    png(img, width = 400, height = 400)
    dev.off()
    list(src = img,
         width = 400,
         height = 400)
  }, deleteFile = FALSE)
  
  output$Legend <- renderImage({
    
    img <- "./www/legend.png" 
    png(img, width = 107, height = 150)
    dev.off()
    list(src = img,
         width = 107,
         height = 150)
  }, deleteFile = FALSE)
  
  output$CrimeVSRent <- renderPlot({
    house2 <- read.csv("house2.csv")
    house2$area <- as.character(house2$area)
    tmp <- NA
    for (i in input$RentVar02)
    {
      tmp <- rbind(tmp, house2[house2$area == as.character(i),c("crime", "Value", "area")])
    }
    tmp <- tmp[-1,]
    Area = factor(tmp$area)
    p <- ggplot(tmp, aes(x = crime, y = Value,color = Area)) + geom_point() +
      ylab("Rent Price(per sqFt)") + xlab("Crime Frequency nearby")
    p
  })
  
  output$HeatMap <- renderPlotly({
    if (input$HeatMapVar == 3)
    {
      load("./heatmap/heatmap_3.rda")
      p <- plot_ly(z = heatmap8_3,type="heatmap")
      p
    }
    else if (input$HeatMapVar == 5)
    {
      load("./heatmap/heatmap_5.rda")
      p <- plot_ly(z = heatmap8_5,type="heatmap")
      p
    }
    else
    {
      load("./heatmap/heatmap_10.rda")
      p <- plot_ly(z = heatmap8_10,type="heatmap")
      p
    }
  })
})