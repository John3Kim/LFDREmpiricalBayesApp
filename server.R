library(shiny) 
library(matrixStats)
source("caution.parameter.actions.R")
source("SEL.caution.parameter.R")

shinyServer( 
    function(input, output){ 
        
        textInputLFDRCaution <- reactive ({
            #Remove TRUE/FALSE prompt when there are empty fields
            checkNullFields <- (is.null(input$l1Input)
                                ||is.null(input$l2Input))
            
            if(checkNullFields){ 
                return()
            }
            
            x1 <- c(as.numeric(unlist(
                      strsplit(input$x1Input, 
                               split = ",", fixed = TRUE))))
            x2 <- c(as.numeric(unlist(
                     strsplit(input$x2Input, 
                              split = ",", fixed = TRUE))))
            
            
            l1 <- as.numeric(input$l1Input) 
            l2 <- as.numeric(input$l2Input)
            
            caution.parameter.actions(x1,x2,l1,l2) 
            #SEL.caution.parameter(x1,x2)
            
            
        })
        
        
        fileInputLFDRCaution <- reactive ({
            inputFile <- input$LFDREstimatesFile
            
            # Remove TRUE/FALSE prompt when there are empty fields
            checkNullFields <- (is.null(inputFile)
                                ||is.null(input$l1Input)
                                ||is.null(input$l2Input))
            
            if(checkNullFields){ 
                return()
            }
            
            x1 <- read.csv(inputFile$datapath, 
                           header = input$chooseFileHeader)[[1]] 
            
            x2 <- read.csv(inputFile$datapath, 
                           header = input$chooseFileHeader)[[2]] 
            
            l1 <- as.numeric(input$l1Input) 
            l2 <- as.numeric(input$l2Input)
            
            caution.parameter.actions(x1,x2,l1,l2) 
            #SEL.caution.parameter(x1,x2)
        })  
      
            
      output$ZeroOneOutput <- renderPrint({ 
           
           if(input$choiceLFDRInput == "fileIn"){ 
               fileInputLFDRCaution()
           }else if(input$choiceLFDRInput == "textIn"){
               textInputLFDRCaution()
           }

       }) 
      
      output$CSVOut <- downloadHandler( 
          
          filename = function(){ 
              paste("LFDRResults_",Sys.time(),".csv", sep = "")
          }, 
          
          content = function(file){ 
              
              if(input$choiceLFDRInput == "fileIn"){ 
                  dFrame <- as.data.frame.list(fileInputLFDRCaution(), 
                                               optional = FALSE) 
              }else if(input$choiceLFDRInput == "textIn"){
                  dFrame <- as.data.frame.list(textInputLFDRCaution(), 
                                               optional = FALSE) 
              }
              
              write.csv(dFrame, file, 
                          quote = FALSE, 
                          col.names = c("CGM1", "CGM0","CGM0.5"))
          }
      )
    }
)
