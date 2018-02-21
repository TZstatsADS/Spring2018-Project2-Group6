library(shiny)
library(leaflet)
library(ggplot2)
library(plotly)
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
            draggable = TRUE, top = 80, left = 30, right = "auto", bottom = "20",
            width = 360, height = "auto", cursor = "inherit",
            
            h3("User Defined Selection"),
            
            radioButtons(inputId = "type",
                         label  = "Choose Type",
                         choices = c('Total','Rent','Crime'),
                         selected ='Rent'),
            selectInput("CrimeType", "Choose a Crime Type",
                        c("Default","Total",'PETIT LARCENY','GRAND LARCENY','HARRASSMENT 2',
                          'ASSAULT 3', 'CRIMINAL MISCHIEF',"DANGEROUS DRUGS"),
                        selected ='Default'),
            sliderInput(inputId = "RentArea",
                        label = "Select ideal House Area(sqFt)",
                        min =100, max =2000, value = 310, step = 10),
            sliderInput(inputId = "Price",
                        label = "Select ideal rent(USD/month)",
                        min =400, max =4000, value = c(800,1500), step = 50),
            checkboxGroupInput("CrimeType2", "Check the CrimeType:",
                               c("Felony", "Misdemeanor", "Violation"),
                               selected =c("Felony", "Misdemeanor", "Violation")),
            checkboxGroupInput("others", "Check the following information:",
                               c("Subway", "Police", "Hospital"),
                               selected = c("Subway", "Police", "Hospital"))
          ),
          absolutePanel(id="Legend",class = "panel panel-default", fixed=TRUE,
                        draggable = TRUE, top = "auto", left = "auto",right=10, bottom=10,width=107,
                        height=150,
                        imageOutput("Legend",height=150)
            )
          )
      ),
      tabPanel
      (
        "Crime Pie Map",
        leafletOutput("CrimeMap",width = "100%", height = 640)
      ),
      tabPanel
      (
        "Rent Heat Map",
        br(),
        br(),
        h5("the heatmap is based on KNN methods to split Manhattan area in to
           1850*1500 cells, we consider the nearest houses to each cell and 
           average it as its own cell so as to smooth all over Manhattan island.",
           align = "center"),
        br(),
        br(),
        sidebarPanel(width = 3, 
                     selectInput(inputId = "HeatMapVar",
                                 label = "Select number of nearest neighbors",
                                 choices = c(3, 5, 10),
                                 selected = 3)
        ),
        mainPanel(
          plotlyOutput("HeatMap", width = "80%", height = "70%")
        )
      ),
      navbarMenu
      (
        "Summary Plot",
        br(),
        br(),
        tabPanel(
              "Crime",
              br(),
              h2("Crime Summary", align = "center"),
              br(),
              br(),
              sidebarPanel(width = 3, 
                  selectInput(inputId = "CrimeVar02",
                              label  = "Choose the type",
                              choices = c("Total","Felony","Misdemeanor","Violation","Crime By Month"),
                              selected ='Total')
                ),
               mainPanel(
                 br(),
                 br(),
                 br(),
                 verbatimTextOutput("Writeup"),
                 br(),
                 br(),
                 imageOutput("SummaryCrimePlot")
               )
            ),
            tabPanel(
              "Crime VS Rent 1",
                h2("Crime VS Rent 1", align = "center"),
                br(),
                br(),
                h5("There should be some Analysis and Comment", align = "center"),
                br(),
                br(),
                img(src='RentAndCrime.png',width = "70%",style="display: block; margin-left: auto; margin-right: auto;")
                
              ),
              tabPanel(
                "Crime VS Rent 2",
                h2("Crime VS Rent 2", align = "center"),
                br(),
                br(),
                h5("There should be some Analysis and Comment", align = "center"),
                br(),
                br(),
                img(src='scatterplot2.png',width = "70%",style="display: block; margin-left: auto; margin-right: auto;")
              ),
              tabPanel(
                "Crime VS Rent 3",
                h2("Crime VS Rent 3", align = "center"),
                br(),
                br(),
                h5("There should be some Analysis and Comment", align = "center"),
                br(),
                br(),
                sidebarPanel(width = 3,
                             checkboxGroupInput
                             (
                                    "RentVar02",
                                    "Choose the area",
                                    c("Central Harlem","Chelsea and Clinton",
                                                     "East Harlem","Gramercy Park and Murray Hill",
                                                     "Greenwich Village and Soho", "Inwood and Washington Heights",
                                                     "Lower East Side", "Lower Manhattan",
                                                     "Upper East Side", "Upper West Side"),
                                    selected =c("Central Harlem","Chelsea and Clinton",
                                                "East Harlem","Gramercy Park and Murray Hill",
                                                "Greenwich Village and Soho", "Inwood and Washington Heights",
                                                "Lower East Side", "Lower Manhattan",
                                                "Upper East Side", "Upper West Side"))
                             
                ),
                mainPanel(
                  plotOutput("CrimeVSRent")
                )
              )
      )
      
    )
  )
)

