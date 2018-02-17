library(shiny)
library(leaflet)
library(shinythemes)
# Define UI for application that draws a histogram
shinyUI
(
  ui = tagList
  (
    #shinythemes::themeSelector(),
    navbarPage
    (
      theme = shinytheme("cerulean"),
      "Our App Name",
      tabPanel
      (
        ##start 2D map
        "Query Map",
        sidebarPanel(
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
        ),
        mainPanel
        (
          #h4(textOutput("text")),
          titlePanel("Map title 001"),
          leafletOutput("mymap",width = "100%", height = 600)
          ##end 2D map
        )
      ),
      tabPanel
      (
        "Summary Map",
        sidebarPanel(
          
        ),
        mainPanel
        (
          
        )
      )
    )
  )
)

