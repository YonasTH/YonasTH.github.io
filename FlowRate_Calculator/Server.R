library(shiny)
library(ggplot2)
g <- 9.81
rho <- 1000
flowRate <- function(b, y1, y2) b*y1*sqrt(2*g*y2)/sqrt((y1/y2)+1)
force <- function(b, y1, y2){
  v1 <- b*y1
  v2 <- b*y2
  f <- rho*b*(v2^2*y2-v1^2*y1)-rho*g*b/2*(y1^2-y2^2)
  -1*f/1e5
}
plt <- function(y1, y2) {
  data <- data.frame(x1=c(0,4),x2=c(4.5,8.5), Y1=c(y1,y1), Y2=c(y2, y2))
  ymin <- data.frame(ymin=y2, ymax=5, xmax=4.5, xmin=4, y1=y1)
  q <- ggplot()+geom_line(data=data, aes(x1, Y1), col="blue")+
    geom_line(data=data, aes(x2, Y2), col="blue")+xlab("x")+ylab("y")+
    geom_rect(data=ymin, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax), fill="brown", col ="black")+
    geom_rect(data=ymin, aes(xmin=0, xmax=8.5, ymin=0, ymax=0.25), fill="grey")
  q+coord_cartesian(xlim=c(0,8.5), ylim=c(0,5))+
    annotate("text", x=1, y=ymin$y1+0.25, label = "Y1")+
    annotate("text", x=7.5, y=ymin$ymin+0.25, label = "Y2")+
    annotate("text", x=4.75, y=(ymin$ymin+5)/2, label = "Gate")
}
shinyServer(
  function(input, output){
   
    output$flowRate <- renderPrint(if (input$y1<=0|input$y2<=0|input$b<=0) "Dimension should be greater than zero"
                                   else if (input$y1>5|input$y2>5|input$b>5) "Dimension exceeds canal dimensions 5mx5mx5m"
                                   else if (input$y1<input$y2) "Upstream depth should be greater or equal to downstream depth"
                                   else {flowRate(input$b, input$y1, input$y2)})
    output$force <- renderPrint(if (input$y1<=0|input$y2<=0|input$b<=0) "Dimension should be greater than zero"
                                else if (input$y1>5|input$y2>5|input$b>5) "Dimension exceeds canal dimensions 5mx5mx5m"
                                else if (input$y1<input$y2) "Upstream depth should be greater or equal to downstream depth"
                                else {force(input$b, input$y1, input$y2)})
    output$plot1 <- renderPlot(if (input$y1<=0|input$y2<=0|input$b<=0) "Dimension should be greater than zero"
                               else if (input$y1>5|input$y2>5|input$b>50) "Dimension exceeds canal dimensions 5mx5mx5m"
                               else if (input$y1<input$y2) "Upstream depth should be greater or equal to downstream depth"
                               else {plt(input$y1, input$y2)})
    }
  
  )
                                   
  