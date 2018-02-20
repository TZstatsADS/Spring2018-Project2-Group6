library(shiny)
library(leaflet)
library(shinythemes)
library(leaflet.minicharts)
# Define UI for application that draws a histogram
shinyUI
(
  ui = tagList
  (
    #shinythemes::themeSelector(),
    navbarPage
    (
      "Manhattan Housing Map",
      #theme=shinythemes::shinytheme("spacelab"),
      fluid=T,
      
      #####################################1. Home##############################################           
      tabPanel("Home",icon=icon("home"),
               
               div(class="home",
                   
                   
                   tags$head(
                     # Include our custom CSS
                     includeCSS("www/styles.css"),
                     includeScript("www/click_hover.js")
                     
                   ),
                   
                   align="center",
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   h1("Rent Easy in Manhattan",style="color:white;font-family: Times New Roman;font-size: 450%;font-weight: bold;text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;"),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   h2("Group 6-Spring 2018",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;"),
                   h3("Anshuma Chandak",style="color:white;font-family: Times New Roman;font-size: 150%;font-weight: bold;text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;"),
                   h4("Wenyuan Gu",style="color:white;font-family: Times New Roman;font-size: 150%;font-weight: bold;text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;"),
                   h5("Yuexuan Huang",style="color:white;font-family: Times New Roman;font-size: 150%;font-weight: bold;text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;"),
                   h6("Zhongxing Xue",style="color:white;font-family: Times New Roman;font-size: 150%;font-weight: bold;text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;"),
                   h6("Weibo Zhang",style="color:white;font-family: Times New Roman;font-size: 150%;font-weight: bold;text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;"),
                   br()
                   #h4("")
                   
                   # tags$head(
                   #   # Include our custom CSS
                   #   includeCSS("styles.css")
                   #   
                   # )
               )
      ),
      tabPanel
      (
        ##start 2D map
        "Query Map",
        div
        ( 
          class="outer",
          tags$head(
            # Include our custom CSS
            includeCSS("styles.css"),
            includeScript("gomap.js")
          ),
          leafletOutput("mymap",width = "100%", height = "100%"),
            
          absolutePanel(
            id = "controls", class = "panel panel-default", fixed = TRUE,
            draggable = TRUE, top = 80, left = "auto", right = 30, bottom = "auto",
            width = 360, height = "auto", cursor = "inherit",
            
            h3("Query"),
            
            radioButtons(inputId = "type",
                         label  = "Choose Type",
                         choices = c('Total','Rent','Crime'),
                         selected ='Rent'),
            selectInput("CrimeType", "Choose a Crime Type",
                        c("Default","Total",'PETIT LARCENY','GRAND LARCENY','HARRASSMENT 2',
                          'ASSAULT 3', 'CRIMINAL MISCHIEF',"DANGEROUS DRUGS"),
                        selected ='Default'),
            sliderInput(inputId = "Price",
                        label = "Select ideal rent",
                        min =400, max =4000, value = c(800,1500), step = 50),
            checkboxGroupInput("CrimeType2", "Check the CrimeType:",
                               c("Felony", "Misdemeanor", "Violation"),
                               selected =c("Felony", "Misdemeanor", "Violation")),
            checkboxGroupInput("others", "Check the following information:",
                               c("Subway", "Police", "Hospital"),
                               selected = c("Subway", "Police", "Hospital"))
          )
        )
      ),
      tabPanel
      (
        "Crime Map",
        leafletOutput("CrimeMap",width = "100%", height = 640)
      ),
      navbarMenu
      (
        "Summary Plot",
        tabPanel(
              "Crime",
                sidebarPanel(width = 3, 
                  selectInput(inputId = "CrimeVar02",
                              label  = "Choose the type",
                              choices = c("Total","Felony","Misdemeanor","Violation","Crime By Month"),
                              selected ='Total')
                ),
               mainPanel(
                 imageOutput("SummaryCrimePlot")
               )
            ),
            tabPanel(
              "Rent",
              sidebarPanel(width = 3,
                selectInput(inputId = "RentVar01",
                            label  = "Choose the area",
                            choices = c("Central Harlem","Chelsea and Clinton",
                                        "East Harlem","Gramercy Park and Murray Hill",
                                        "Greenwich Village and Soho", "Inwood and Washington Heights",
                                        "Lower East Side", "Lower Manhattan",
                                        "Upper East Side", "Upper West Side"),
                            selected ='Total')
                
              ),
              mainPanel(
                imageOutput("SummaryRentArea")
              ),
              tabsetPanel(type="pills",
              tabPanel(
                h6("Crime frequency & Rent Price", align = "center"),
                img(src='RentAndCrime.png',width = "70%",style="display: block; margin-left: auto; margin-right: auto;")
                
              ),
              tabPanel(
                h6("Crime frequency & Rent Price Scatter plot", align = "center"),
                img(src='scatterplot2.png',width = "70%",style="display: block; margin-left: auto; margin-right: auto;")
              ),
              tabPanel(
                h6("This plot will be replaced by R code", align = "center"),
                img(src='scatterplot.png',width = "70%",style="display: block; margin-left: auto; margin-right: auto;")
              ),
              tabPanel(
                h6("Heat map of Rent", align = "center"),
                sidebarPanel(width = 3, 
                             selectInput(inputId = "HeatMapVar",
                                         label = "Select ???",
                                         choices = c(3, 5, 10),
                                         selected = 3)
                ),
                mainPanel(
                plotlyOutput("HeatMap", width = "70%", height = "50%")
                )
              )
              )   
          )
      )
      
    )
  )
)

