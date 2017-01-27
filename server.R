library(shiny) 
library(matrixStats)
source("caution.parameter.actions.R")

shinyServer( 
    function(input, output){ 
       output$ZeroOne <- renderPrint({ 
           
           x1 <- c(as.numeric(unlist(
                   strsplit(input$x1Input, split = ", ", fixed = TRUE))))
           x2 <- c(as.numeric(unlist(
                   strsplit(input$x2Input, split = ", ", fixed = TRUE))))
           l1 <- as.numeric(input$l1Input) 
           l2 <- as.numeric(input$l2Input)
           
           caution.parameter.actions(x1,x2,l1,l2) 
       })    
    }
)
