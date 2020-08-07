library(shiny)

shinyUI(fluidPage(
  titlePanel("Children's Weight and Height"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("sex",
                   "Sex:",
                   choices=c("Male","Female"),
                   selected="Male"),
      selectInput("age",
                 "Age in months (choose closest):",
                 choices=c(0,1,2,3,4,5,6,7,8,9,10,11,12,18,24,30,36,42,48,54,60),
                 selected=0),
       numericInput("weight",
                   "Weight in kg:",
                   value=3,
                   min=0),
      numericInput("height",
                   "Height in cm:",
                   value=48,
                   min=0),
      helpText("*Data obtained from the Cartilla Nacional de Salud (Mexico)"),
       width=2
    ),
    mainPanel(
       plotOutput("plot",height=700),
       width=10
    )
  )
))
