library(shiny) 
library(matrixStats)
source("R/caution.parameter.actions.R")
source("R/SEL.caution.parameter.R") 
source("R/caution.threshold.R")
source("R/refresh_file_data.R")

shinyServer( 
    function(input, output, session){ 

        # Uses the render UI to change type of input to reflect the radio buttons
        output$ui<- renderUI({
            if (is.null(input$choiceLFDRInput)){
                return()
            } 
            
            # Do a refresh every 2 minutes 
            invalidateLater(120000,session)
            
            switch(input$choiceLFDRInput,
            
               "fileIn" = list(tags$strong("Import LFDR estimates as a 
                                      CSV file:"),
                            helpText("In order to use the file import 
                                      option, ensure that you have a .csv file 
                                      in the following order: gene name, 
                                      reference class one and reference class 
                                      two."),
                            
                            fileInput(inputId = "LFDREstimatesFile",
                                      label = "", 
                                      multiple = FALSE,
                                      accept = c(".csv"),),
 
                            checkboxInput(inputId = "chooseFileHeader", 
                                          label = ".csv file contains header? 
                                                   (Check if true.)", 
                                          value = FALSE)), 
                
                "textIn" = list(strong("Input LFDR estimates by text input:"),
                             helpText("Separate LFDR estimates by a comma. 
                                       (Can optionally be separated by a space 
                                        in addition to a comma.)"),
                
                             textInput(inputId = "x1Input",
                                       label = "Values of the first reference 
                                       class", 
                                       placeholder = "Input LFDR values", 
                                       #value = "0.14, 0.80, 0.16, 0.94"),
                                       value = lfdr1),
                
                             textInput(inputId = "x2Input",
                                       label = "Values of the second reference 
                                       class", 
                                       placeholder = "Input LFDR values",
                                       value = lfdr2)#,
                                       #value = "0.21, 0.61, 0.12, 0.82")
                             )
            
            )})
        

        
        textIOZeroOne <- reactive ({
            
            #Remove TRUE/FALSE prompt when there are empty fields
            checkNullFields <- (is.null(input$l1Input)
                                ||is.null(input$l2Input))
            
            if(checkNullFields){ 
                return()
            } 
            
            
            x1 <- as.numeric(unlist(
                             strsplit(input$x1Input, 
                                      split = ",", fixed = TRUE)))
            x2 <- as.numeric(unlist(
                             strsplit(input$x2Input, 
                                      split = ",", fixed = TRUE)))
            size <- length(x1) 
            
            Gene <- seq(from = 1, to = size)
            
            l1 <- as.numeric(input$l1Input) 
            l2 <- as.numeric(input$l2Input)
            
            textResultsTodFrame <- as.data.frame(
                caution.parameter.actions(x1,x2,l1,l2))
            
            resultsOut <- cbind(Gene, textResultsTodFrame) 
            return(resultsOut)
            
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
            
           Gene <- read.csv(inputFile$datapath, 
                                 header = input$chooseFileHeader)[[1]] 
            x1 <- read.csv(inputFile$datapath, 
                           header = input$chooseFileHeader)[[2]] 
            x2 <- read.csv(inputFile$datapath, 
                           header = input$chooseFileHeader)[[3]] 
            l1 <- as.numeric(input$l1Input) 
            l2 <- as.numeric(input$l2Input)
            
            fileResultsTodFrame <- as.data.frame(
                caution.parameter.actions(x1,x2,l1,l2)) 
            resultsOut <- cbind(fileResultsTodFrame) 
            return(fileResultsTodFrame)
        
        })  
        
        fileIOSEL <- reactive ({
            inputFile <- input$LFDREstimatesFile
            
            # Remove TRUE/FALSE prompt when there are empty fields
            checkNullFields <- (is.null(inputFile))
            
            if(checkNullFields){ return() }
            
            x1 <- read.csv(inputFile$datapath, 
                           header = input$chooseFileHeader)[[2]] 
            x2 <- read.csv(inputFile$datapath, 
                           header = input$chooseFileHeader)[[3]] 

            SEL.caution.parameter(x1,x2) 
        }) 
        
      threshold <- reactive({ 
          l1 <- as.numeric(input$l1Input) 
          l2 <- as.numeric(input$l2Input)
          
          caution.threshold(l1,l2)
          })

      output$cautionThreshold <- renderPrint({
          cat(format(threshold()))
      })
              
      output$ZeroOneOutput <- renderTable(digits = 0, { 
           if(input$choiceLFDRInput == "fileIn"){ 
               fileIOZeroOne()
           }else if(input$choiceLFDRInput == "textIn"){
               textIOZeroOne() 
           }
       })  
      
      output$SELOutput <- renderTable(digits = 3, { 
          if(input$choiceLFDRInput == "fileIn"){ 
              fileIOSEL()
          }else if(input$choiceLFDRInput == "textIn"){
              textIOSEL() 
          }
      }) 
      
      addPopover(session,
                 id = "ZeroOneOutput",
                 title = "Zero-One Output",
                 content = paste(strong("Outputs:"), br(), 
                                 tags$ul( 
                                     tags$li("CGM1- Conditional Gamma Minimax"), 
                                     tags$li("CGM0- Conditional Gamma Minimin"), 
                                     tags$li("CGM0.5- Caution/Action Parameter 
                                             (Balance between CGM0 and CGM1).")
                                     )), 
                 placement = "top", 
                 trigger = "hover") 
      
      addPopover(session,
                 id = "SELOutput",
                 title = "SEL Output",
                 content = paste(strong("Outputs:"), br(), 
                                 tags$ul( 
                                     tags$li("CGM1- Conditional Gamma Minimax"), 
                                     tags$li("CGM0- Conditional Gamma Minimin"), 
                                     tags$li("CGM0.5- Caution/Action Parameter 
                                             (Balance between CGM0 and CGM1).")
                                     )), 
                 placement = "top", 
                 trigger = "hover") 
      
      
      output$CSVOut <- downloadHandler( 
          filename = function(){ 
              paste("LFDRResults",Sys.time(),".csv", sep = "")
          }, 
          
          content = function(file){ 
              if(input$choiceLFDRInput == "fileIn"){ 
                  fileIOAppend <- append(fileIOZeroOne(), fileIOSEL())
                  dFrame <- as.data.frame.list(fileIOAppend, 
                                               optional = FALSE)
              }else if(input$choiceLFDRInput == "textIn"){
                  textIOAppend <- append(textIOZeroOne(), textIOSEL())
                  dFrame <- as.data.frame.list(textIOAppend, 
                                               optional = FALSE)
              }
              
              write.csv(dFrame, file, 
                          quote = FALSE)
          }, 
          contentType = NULL
      )
    }
) 