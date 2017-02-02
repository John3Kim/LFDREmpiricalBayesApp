library(shiny)

shinyUI(fluidPage(theme = "main.css",
   titlePanel("LFDREmpiricalBayes Data Analysis Demo"),
   hr(),
   
   wellPanel(
      
      tags$div(class = "about",
         tags$h4("About"), 
         HTML(paste("The LFDREmpiricalBayes Data Analysis Demo allows the 
                 users to test out the functions", tags$strong(class = "code",
                 "caution.parameter.actions"),"and",
                 tags$strong(class = "code","SEL.caution.parameter"), 
                 "given two sets of LFDR estimates.  This RShiny app is based 
                 on the package LFDREmpiricalBayes and will be available soon
                 to install on R.  
                 *More details coming soon!*", sep = " "))
              ), 
      br(),
      p("To use this function, follow steps 1 to 3 as labelled on 
                the tabs.")
            ),
   
      hr(),
        
   tabsetPanel( 
      tabPanel("1. Set Parameters",
      br(),
      # Row by row is easiest to look at
      wellPanel(
         fluidRow( 
            column(3,
                   h4("1. Input LFDR estimates"),
                   radioButtons(inputId = "choiceLFDRInput",
                                label = "Choose method of input:", 
                                choices = c("File Import" = "fileIn", 
                                            "Text Input" = "textIn"))
                                    
                  ), 
             
            column(4, 
                   fileInput(inputId = "LFDREstimatesFile",
                             label = "Import LFDR estimates as a CSV file:", 
                             multiple = FALSE,
                             accept = c(".csv")),
                                    
                   checkboxInput(inputId = "chooseFileHeader", 
                                 label = "Contains header? (Check if true.)", 
                                 value = FALSE)
                   ),
            
            column(5,
                   strong("Input LFDR estimates by text input:"),
                   helpText("Separate LFDR estimates by a comma 
                             and zero or more spaces."),
                                    
                   textInput(inputId = "x1Input",
                             label = "Values of the first reference class (x1)", 
                             placeholder = "Input LFDR values", 
                             value = "0.14, 0.80, 0.16, 0.94"),
                   
                   textInput(inputId = "x2Input",
                             label = "Values of the second reference class (x2)", 
                             placeholder = "Input LFDR values", 
                             value = "0.21, 0.61, 0.12, 0.82")
                                    ))),
      wellPanel(
         fluidRow(
            column(3,
               h4("2. Input loss values"),
               helpText("Input values based on the cost/benefit ratio 
                        [threshold =  (l1 / (l1+l2))] of a true or false discovery. (Used only
                        in the Zero-One Loss output.)") 
                  ),
            
            column(4,
               textInput(inputId = "l1Input",
                         label = "Loss due to type-I error (l1):", 
                         value = "4", 
                         placeholder = "Input numerical loss value"),
               
               textInput(inputId = "l2Input",
                         label = "Loss due to type-II error (l2):", 
                         placeholder = "Input numerical loss value",
                         value = "1")
               ),
                             
            column(5,
               strong("Threshold:"), 
               helpText("This is the threshold of the LFDR (p-value) used 
                        to reject or fail to reject the null hypothesis."),
               verbatimTextOutput("cautionThreshold")
                  )
                  ))),
            
      tabPanel("2. See Results",
         br(),
         #column(3,
         #   strong("Given a threshold of:"),
         #   verbatimTextOutput("cautionThreshold")
         #),
         # Considering an ordinary printout and a table 
         # it would be easier if the user views the SEL and Zero-One 
         # outputs as tables rather than that of a 
         fluidRow(
         column(7,
            strong("Based on your LFDR estimates and loss values, 
                 your Zero-One output is:"),
            #verbatimTextOutput("ZeroOneOutput"), 
         
            wellPanel(
               tableOutput("ZeroOneOutput") 
                     )
         ),
      
         column(5,
            strong("Based on your LFDR estimates, your SEL output is:"),
            #verbatimTextOutput("SELOutput"),
            wellPanel(
               tableOutput("SELOutput")
                     ) 
               ) 
               )), 
      
      tabPanel("3. Download", 
        br(), 
        strong("Download your results here:"), 
        br(), 
        downloadButton(outputId = "CSVOut", 
               label = "Download Results (.csv)")
               ),
      
      tabPanel("Credits", 
         br(),
         wellPanel(
            h4("Credits"),
            p("This backend code is based on 
               caution.parameter.actions and SEL.caution.parameter 
               R function made by Ali Karimnezhad."), 
            p("The RShiny app and code modifications to Ali's R code
               is brought to you by Johnary Kim.")  
                  )
              )
)))

