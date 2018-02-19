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
      theme = shinytheme("cerulean"), # change the topic
      "Our App Name",
      tabPanel
      (
        "Home Page",
        h1("Rent & Crime", align = "center"),
        h3(htmlOutput("BeginningText"), align = "center")
        
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
                        min =400, max =4000, value = c(800,1500), step = 50)
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
                sidebarPanel(
                  selectInput(inputId = "CrimeVar02",
                              label  = "choose the Type",
                              choices = c("Total","Felony","Mis","Vio"),
                              selected ='Total')

                ),
               mainPanel(
                 imageOutput("SummaryCrimePlot")
               ),
              
              h3("Crime frequency by month(2017.01-2017.12)", align = "center"),
              # way to insert a single picture(and align to center)
              img(src='crime by month.png',width = "50%",style="display: block; margin-left: auto; margin-right: auto;")
            ),
            tabPanel(
              "Rent",
              sidebarPanel(
                selectInput(inputId = "RentVar01",
                            label  = "choose the Area",
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
                h5("Crime frequency & Rent Price", align = "center"),
                img(src='RentAndCrime.png',width = "70%",style="display: block; margin-left: auto; margin-right: auto;")
                
              ),
              tabPanel(
                h5("Crime frequency & Rent Price Scatter plot", align = "center"),
                img(src='scatterplot2.png',width = "70%",style="display: block; margin-left: auto; margin-right: auto;")
              ),
              tabPanel(
                h5("This plot will be replaced by R code", align = "center"),
                img(src='scatterplot.png',width = "70%",style="display: block; margin-left: auto; margin-right: auto;")
              )
              )   
          )
      )
      
    )
  )
)

