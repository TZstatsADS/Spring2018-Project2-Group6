
##### Server #####

output$Writeup <- renderText({
  ifelse(input$CrimeVar02 == "Total","We observe that Misdemeanor has the highest number of cases, followed by Felony and Violations.",
  ifelse(input$CrimeVar02=="Felony","We observe that Grand Larceny followed by Serious assualts contribute the maximum to Felony crimes",
  ifelse(input$CrimeVar02=="Misdemeanor","We observe that Assaults followed by Criminal Mischief & Drug related crimes contribute significantly to Misdemeanor crimes",
  ifelse(input$CrimeVar02=="Violation", "We observe that most of the crimes related to Violations are related to Harassment",
                              "We observe that during the month of October, the crimes are the highest and they are lowest in the month of February"
                       ))))
})


#### UI #####

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
    textOutput("Writeup")
  )