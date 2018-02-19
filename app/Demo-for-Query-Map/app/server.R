library(shiny)
library(choroplethr)
library(choroplethrZip)
library(dplyr)
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
  
  ## 2D map
  output$mymap <- renderLeaflet({
    ## Control Icon size and looks
    levelIcon <- iconList(
      Rent = makeIcon("IconMoney.png", iconWidth = 36, iconHeight = 36, 
                       iconAnchorX = 18, iconAnchorY = 18),
      FELONY = makeIcon("IconCrime1.png", iconWidth = 36, iconHeight = 36, 
                       iconAnchorX = 18, iconAnchorY = 18),
      MISDEMEANOR = makeIcon("IconCrime2.png", iconWidth = 36, iconHeight = 36, 
                       iconAnchorX = 18, iconAnchorY = 18),
      VIOLATION = makeIcon("IconCrime3.png", iconWidth = 36, iconHeight = 36, 
                          iconAnchorX = 18, iconAnchorY = 18),
      Subway = makeIcon("IconSubway.png", iconWidth = 20, iconHeight = 20, 
                      iconAnchorX = 10, iconAnchorY = 10)
    )
    
    ## subset the data
    tmp <- read.csv("QueryMapData_v2.3.csv")
    tmp$Value <- tmp$Value * 309 / 12
    if (as.character(input$type) == "Rent") # type: Rent, Crime, or Total
      tmp <- subset(tmp, Type1 == "Rent" | Type1 == "Subway")
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
    
    #Log = paste("level",floor(log((tmp$value) - min + 1, base =1.0001)/log(max - min + 1, base =1.0001) * 7 + 1),sep = "")
    
    tmp$rank[tmp$Type1 == "Rent"] = paste("Building Type: ",tmp$Type2[tmp$Type1 == "Rent"],"<br/>",
      "Average rent: $",round(tmp$Value[tmp$Type1 == "Rent"] , 2)," per month","<br/>",
      "<a href='http://www1.nyc.gov/assets/finance/jump/hlpbldgcode.html'>What is Building Type?</a>","<br/>",sep = "")
    tmp$rank[tmp$Type1 == "Crime"] = paste("Crime Type: ",tmp$Type2[tmp$Type1 == "Crime"],"-","<br/>",
                                          tmp$Remark[tmp$Type1 == "Crime"],"<br/>",sep = "")
    tmp$rank[tmp$Type1 == "Subway"] = paste(tmp$Remark[tmp$Type1 == "Subway"],sep = "")# Add remark
    
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
  
})