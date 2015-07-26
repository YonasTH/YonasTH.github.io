library(shiny)
require(markdown)
shinyUI(pageWithSidebar(
  headerPanel("Flow Under a Sluice Gate in a Rectangular Canal"),
  sidebarPanel(
    
    numericInput('y1', 'Upstream Depth m', 4, min=0, max=5, step=0.2),
    numericInput('y2', 'Downstream Depth m', 2, min=0, max=5, step=0.2),
    numericInput('b', 'Canal Width m', 1, min=0, max=5, step=0.2),
    submitButton('Submit'),
    plotOutput("plot1")
  ),
  mainPanel(
    
    h2('Output'),
    h3('Flow Rate (m3/s) = ', 
       verbatimTextOutput("flowRate")),
    h3('Horizontal Force on Gate (Dynes) = ', 
       verbatimTextOutput("force")),
      
    includeMarkdown("Documentation.md")
       )
    )
  )