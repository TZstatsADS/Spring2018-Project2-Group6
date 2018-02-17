library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("2009 Manhattan Housing Sales"),
  
  # Sidebar with a selector input for neighborhood
  sidebarLayout(
    sidebarPanel(
      selectInput("nbhd", label = h5("Choose a Manhattan Neighborhood"), 
                         choices = list("all neighborhoods"=0,
                                        "Central Harlem"=1, 
                                        "Chelsea and Clinton"=2,
                                        "East Harlem"=3, 
                                        "Gramercy Park and Murray Hill"=4,
                                        "Greenwich Village and Soho"=5, 
                                        "Lower Manhattan"=6,
                                        "Lower East Side"=7, 
                                        "Upper East Side"=8, 
                                        "Upper West Side"=9,
                                        "Inwood and Washington Heights"=10), 
                         selected = 0)
      #sliderInput("p.range", label=h3("Price Range (in thousands of dollars)"),
      #            min = 0, max = 20000, value = c(200, 10000))
    ),
    # Show two panels
    mainPanel(
      #h4(textOutput("text")),
      h3(code(textOutput("text1"))),
      tabsetPanel(
        # Panel 1 has three summary plots of sales. 
        #tabPanel("Sales summary", plotOutput("distPlot")), 
        # Panel 2 has a map display of sales' distribution
        #tabPanel("Sales map", plotOutput("distPlot1")),
        tabPanel(
          
          ##start 2D map
          "2D Map",
          titlePanel("Map title 001"),
          
          leafletOutput("mymap",width = "100%", height = 600),
          
          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                        draggable = TRUE, 
                        top = 180, left = 60, right = "auto", bottom = "auto",
                        width = 350, height = "auto",
                        
#                        h2("2D Explorer"),
                        
                        radioButtons(inputId = "type",
                                     label  = "Choose Type",
                                     choices = c('Total','Rent','Crime'),
                                     selected ='Rent'),
                        radioButtons(inputId = "CrimeType",
                                     label  = "Choose a Crime Type",
                                     choices = c("Default","Total",'PETIT LARCENY','GRAND LARCENY','HARRASSMENT 2',
                                                'ASSAULT 3', 'CRIMINAL MISCHIEF',"DANGEROUS DRUGS"),
                                     selected ='Default'),
                        sliderInput(inputId = "Price",
                                    label = "Select ideal rent",
                                    min =400, max =4000, value = c(800,1500), step = 50)
#                        sliderInput(inputId = "num_countries",
#                                    label = "Top Countries in Trade",
#                                    value = 20,min = 1,max = 50),
#                        selectInput(inputId = "commodity_2D",
#                                    label  = "Select the commodity",
#                                    choices = c('Annual Aggregate','Chocolate', 'Coffee','Cocoa','Spices','Tea'),
#                                    selected ='Coffee')
                        
          ))
          ##end 2D map
        )
      
    )
 )
))

