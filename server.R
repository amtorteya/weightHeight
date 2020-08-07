library(shiny)
library(ggplot2)
library(gridExtra)

#Database (Cartilla Nacional de Salud - Mexico)
db<-data.frame(
  underweightG=c(2.8,3.6,4.5,5.2,5.7,6.1,6.5,6.8,7,7.3,7.5,7.7,7.9,9.1,10.2,11.2,12.2,13.1,14,14.9,15.8),
  overweightG=c(3.7,4.8,5.8,6.6,7.3,7.8,8.2,8.6,9,9.3,9.6,9.9,10.1,11.6,13,14.4,15.8,17.2,18.5,19.9,21.2),
  obesityG=c(4.2,5.5,6.6,7.5,8.2,8.8,9.3,9.8,10.2,10.5,10.9,11.2,11.5,13.2,14.8,16.5,18.1,19.8,21.5,23.2,24.9),
  stuntG=c(47.3,51.7,55,57.7,59.9,61.8,63.5,65,66.4,67.7,69,70.3,71.4,77.8,83.2,87.1,91.2,95,98.4,101.6,104.7),
  underweightB=c(2.9,3.9,4.9,5.7,6.2,6.7,7.1,7.4,7.7,8,8.2,8.4,8.6,9.8,10.8,11.8,12.7,13.6,14.4,15.2,16),
  overweightB=c(3.9,5.1,6.3,7.2,7.8,8.4,8.8,9.2,9.6,9.9,10.2,10.5,10.8,12.2,13.6,15,16.2,17.4,18.3,19.8,21),
  obesityB=c(4.4,5.8,7.1,8,8.7,9.3,9.8,10.3,10.7,11,11.4,11.7,12,13.7,15.3,16.9,18.3,19.7,21.2,22.7,24.2),
  stuntB=c(48,52.8,56.4,59.4,61.8,63.8,65.5,67,68.4,69.7,71,72.2,73.4,79.6,84.8,88.5,92.4,95.9,99.1,102.3,105.3),
  age=c(0,1,2,3,4,5,6,7,8,9,10,11,12,18,24,30,36,42,48,54,60))
colors<-list(red="#ff684c",yellow="#ffda66",green="#8ace7e")

shinyServer(function(input, output) {
  plotWeight<-reactive({
    if(input$sex=="Male")
    {
      db$underweight<-db$underweightB
      db$overweight<-db$overweightB
      db$obesity<-db$obesityB
      titleW<-"Boys' Weight Chart"
    }
    else
    {
      db$underweight<-db$underweightG
      db$overweight<-db$overweightG
      db$obesity<-db$obesityG
      titleW<-"Girls' Weight Chart"
    }
    ggplot(db,aes(x=age/12)) +
      geom_ribbon(aes(ymin=obesity,ymax=obesity*1.15,fill="red")) +
      geom_ribbon(aes(ymin=overweight,ymax=obesity,fill="yellow")) +
      geom_ribbon(aes(ymin=underweight,ymax=overweight,fill="green")) +
      geom_ribbon(aes(ymin=underweight/1.15,ymax=underweight,fill="yellow")) +
      geom_point(aes(x=as.numeric(input$age)/12,y=input$weight,size=3),
                 show.legend=FALSE) +
      scale_fill_manual(values=c(red="#ff684c",yellow="#ffda66",green="#8ace7e"),
                        breaks=c("green","yellow","red"),
                        labels=c("Ideal weight","Low risk\n(over or underweight)","High risk\n(obesity)")) +
      theme_minimal(base_size=12) +
      theme(legend.title=element_blank()) +
      labs(x="Age (years)",y="Weight (kg)") +
      ggtitle(titleW)
  })
  
  plotHeight<-reactive({
    if(input$sex=="Male")
    {
      db$stunt<-db$stuntB
      titleH<-"Boys' Height Chart"
    }
    else
    {
      db$stunt<-db$stuntG
      titleH<-"Girls' Height Chart"
    }
    ggplot(db,aes(x=age/12)) +
      geom_ribbon(aes(ymin=stunt-15,ymax=stunt,fill="yellow")) +
      geom_ribbon(aes(ymin=stunt,ymax=stunt*1.15,fill="green")) +
      geom_point(aes(x=as.numeric(input$age)/12,y=input$height,size=3),
                 show.legend=FALSE) +
      scale_fill_manual(values=c(yellow="#ffda66",green="#8ace7e"),
                        breaks=c("green","yellow"),
                        labels=c("Ideal height","Stunted")) +
      theme_minimal(base_size=12) +
      theme(legend.title=element_blank()) +
      labs(x="Age (years)",y="Height (cm)") +
      ggtitle(titleH)
  })
  
  output$plot<-renderPlot({
    plotList<-list(plotWeight(),plotHeight())
    grid.arrange(grobs=plotList,ncol=2)
  })
})
