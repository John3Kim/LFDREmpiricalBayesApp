library(shiny) 
library(matrixStats)
source("caution.parameter.actions.R")
source("SEL.caution.parameter.R") 
source("caution.threshold.R")

shinyServer( 
    function(input, output){ 
        
        textIOZeroOne <- reactive ({
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
        })
        
        textIOSEL <- reactive ({
            x1 <- c(as.numeric(unlist(
                strsplit(input$x1Input, 
                         split = ",", fixed = TRUE))))
            x2 <- c(as.numeric(unlist(
                strsplit(input$x2Input, 
                         split = ",", fixed = TRUE))))
            
            SEL.caution.parameter(x1,x2) 
        })
        
        fileIOZeroOne <- reactive ({
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
        })  
        
        fileIOSEL <- reactive ({
            inputFile <- input$LFDREstimatesFile
            
            # Remove TRUE/FALSE prompt when there are empty fields
            checkNullFields <- (is.null(inputFile))
            
            if(checkNullFields){ return() }
            
            x1 <- read.csv(inputFile$datapath, 
                           header = input$chooseFileHeader)[[1]] 
            x2 <- read.csv(inputFile$datapath, 
                           header = input$chooseFileHeader)[[2]] 

            SEL.caution.parameter(x1,x2) 
        }) 
        
      threshold <- reactive({ 
          l1 <- as.numeric(input$l1Input) 
          l2 <- as.numeric(input$l2Input)
          
          caution.threshold(l1,l2)
          })
      
      output$cautionThreshold <- renderPrint({
          threshold()
      })
              
      output$ZeroOneOutput <- renderTable({ 
           if(input$choiceLFDRInput == "fileIn"){ 
               fileIOZeroOne()
           }else if(input$choiceLFDRInput == "textIn"){
               textIOZeroOne() 
           }
       })  
      
      output$SELOutput <- renderTable({ 
          if(input$choiceLFDRInput == "fileIn"){ 
              fileIOSEL()
          }else if(input$choiceLFDRInput == "textIn"){
              textIOSEL() 
          }
      })
      
      output$CSVOut <- downloadHandler( 
          filename = function(){ 
              paste("LFDRResults_",Sys.time(),".csv", sep = "")
          }, 
          
          content = function(file){ 
              if(input$choiceLFDRInput == "fileIn"){ 
                  fileIOAppend <- append(fileIOZeroOne(),fileIOSEL())
                  dFrame <- as.data.frame.list(fileIOAppend, 
                                               optional = FALSE) 
              }else if(input$choiceLFDRInput == "textIn"){
                  textIOAppend <- append(textIOZeroOne(),textIOSEL())
                  dFrame <- as.data.frame.list(textIOAppend, 
                                               optional = FALSE) 
              }
              
              write.csv(dFrame, file, 
                          quote = FALSE)
          }
      )
    }
) 


